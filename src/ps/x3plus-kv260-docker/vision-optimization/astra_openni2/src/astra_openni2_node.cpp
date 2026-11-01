#include <OpenNI.h>

#include <atomic>
#include <chrono>
#include <cstdint>
#include <cstring>
#include <memory>
#include <stdexcept>
#include <string>
#include <thread>

#include "rclcpp/rclcpp.hpp"
#include "sensor_msgs/image_encodings.hpp"
#include "sensor_msgs/msg/image.hpp"

class AstraDepthNode final : public rclcpp::Node {
public:
  AstraDepthNode() : Node("astra_openni2") {
    device_uri_ = declare_parameter<std::string>("device_uri", "");
    // 640x480@30 saturates the KV260 USB2 path when the Astra UVC RGB
    // endpoint is active at the same time.  320x240@30 is the default
    // low-bandwidth mode; callers can still request another exact mode.
    depth_width_ = declare_parameter<int>("depth_width", 320);
    depth_height_ = declare_parameter<int>("depth_height", 240);
    depth_fps_ = declare_parameter<int>("depth_fps", 30);
    frame_id_ = declare_parameter<std::string>(
      "frame_id", "camera_depth_optical_frame");

    // The consumer uses newest-frame semantics. Retaining one depth image
    // bounds ROS buffering without changing the 30 FPS capture mode.
    depth_pub_ = create_publisher<sensor_msgs::msg::Image>(
      "/camera/depth/image_raw", rclcpp::QoS(1));

    if (!open_device()) {
      throw std::runtime_error(
        "Unable to open Astra depth stream through bundled OpenNI2");
    }

    capture_thread_ = std::thread(&AstraDepthNode::capture_loop, this);
  }

  ~AstraDepthNode() override
  {
    close_device();
  }

private:
  static bool select_mode(
    const openni::SensorInfo * info,
    openni::PixelFormat format,
    int width,
    int height,
    int fps,
    openni::VideoMode * selected)
  {
    if (info == nullptr || selected == nullptr) {
      return false;
    }

    const auto & modes = info->getSupportedVideoModes();
    for (int index = 0; index < modes.getSize(); ++index) {
      const auto & mode = modes[index];
      if (mode.getPixelFormat() == format &&
          mode.getResolutionX() == width &&
          mode.getResolutionY() == height &&
          mode.getFps() == fps) {
        *selected = mode;
        return true;
      }
    }

    return false;
  }

  bool open_device()
  {
    openni::Status status = openni::OpenNI::initialize();
    if (status != openni::STATUS_OK) {
      RCLCPP_ERROR(
        get_logger(), "OpenNI initialize failed: %s",
        openni::OpenNI::getExtendedError());
      return false;
    }
    openni_initialized_ = true;

    openni::Array<openni::DeviceInfo> devices;
    openni::OpenNI::enumerateDevices(&devices);
    if (devices.getSize() == 0) {
      RCLCPP_ERROR(get_logger(), "No OpenNI2 device found");
      close_device();
      return false;
    }

    const char * uri = device_uri_.empty() ? devices[0].getUri() : device_uri_.c_str();
    status = device_.open(uri);
    if (status != openni::STATUS_OK) {
      RCLCPP_ERROR(
        get_logger(), "Astra open failed for '%s': %s", uri,
        openni::OpenNI::getExtendedError());
      close_device();
      return false;
    }
    RCLCPP_INFO(get_logger(), "Opened Astra depth device: %s", uri);

    status = depth_stream_.create(device_, openni::SENSOR_DEPTH);
    if (status != openni::STATUS_OK) {
      RCLCPP_ERROR(
        get_logger(), "Failed to create depth stream: %s",
        openni::OpenNI::getExtendedError());
      close_device();
      return false;
    }

    openni::VideoMode depth_mode;
    if (!select_mode(
        device_.getSensorInfo(openni::SENSOR_DEPTH),
        openni::PIXEL_FORMAT_DEPTH_1_MM,
        depth_width_, depth_height_, depth_fps_, &depth_mode)) {
      RCLCPP_ERROR(
        get_logger(),
        "Requested exact depth mode %dx%d@%d is not supported; refusing an "
        "implicit fallback to another bandwidth mode",
        depth_width_, depth_height_, depth_fps_);
      const auto * info = device_.getSensorInfo(openni::SENSOR_DEPTH);
      if (info != nullptr) {
        const auto & modes = info->getSupportedVideoModes();
        for (int index = 0; index < modes.getSize(); ++index) {
          const auto & mode = modes[index];
          if (mode.getPixelFormat() == openni::PIXEL_FORMAT_DEPTH_1_MM) {
            RCLCPP_ERROR(
              get_logger(), "Available depth mode: %dx%d@%d",
              mode.getResolutionX(), mode.getResolutionY(), mode.getFps());
          }
        }
      }
      close_device();
      return false;
    }

    status = depth_stream_.setVideoMode(depth_mode);
    if (status != openni::STATUS_OK) {
      RCLCPP_ERROR(
        get_logger(), "Failed to set depth mode: %s",
        openni::OpenNI::getExtendedError());
      close_device();
      return false;
    }

    RCLCPP_INFO(
      get_logger(), "Depth mode: %dx%d @ %d FPS, pixel format DEPTH_1_MM",
      depth_mode.getResolutionX(), depth_mode.getResolutionY(),
      depth_mode.getFps());

    status = depth_stream_.start();
    if (status != openni::STATUS_OK) {
      RCLCPP_ERROR(
        get_logger(), "Failed to start depth stream: %s",
        openni::OpenNI::getExtendedError());
      close_device();
      return false;
    }
    return true;
  }

  void capture_loop()
  {
    std::uint64_t frame_count = 0;
    auto last_report = std::chrono::steady_clock::now();

    while (rclcpp::ok() && !stop_requested_.load()) {
      openni::VideoFrameRef frame;
      const openni::Status status = depth_stream_.readFrame(&frame);
      if (status != openni::STATUS_OK) {
        if (!stop_requested_.load()) {
          RCLCPP_ERROR(
            get_logger(), "Depth readFrame failed: %s",
            openni::OpenNI::getExtendedError());
        }
        break;
      }

      const int width = frame.getWidth();
      const int height = frame.getHeight();
      const int stride = frame.getStrideInBytes();
      const auto * source = static_cast<const std::uint8_t *>(frame.getData());
      const std::size_t packed_row_bytes =
        static_cast<std::size_t>(width) * sizeof(std::uint16_t);

      const std::size_t required_bytes =
        static_cast<std::size_t>(height) * static_cast<std::size_t>(stride);
      if (width <= 0 || height <= 0 || stride < 0 ||
          static_cast<std::size_t>(stride) < packed_row_bytes || source == nullptr ||
          frame.getDataSize() < static_cast<int>(required_bytes)) {
        RCLCPP_ERROR(
          get_logger(), "Invalid depth frame: width=%d height=%d stride=%d bytes=%d",
          width, height, stride, frame.getDataSize());
        continue;
      }

      sensor_msgs::msg::Image message;
      message.header.stamp = now();
      message.header.frame_id = frame_id_;
      message.height = static_cast<std::uint32_t>(height);
      message.width = static_cast<std::uint32_t>(width);
      message.encoding = sensor_msgs::image_encodings::TYPE_16UC1;
      message.is_bigendian = false;
      message.step = static_cast<std::uint32_t>(stride);
      message.data.resize(
        static_cast<std::size_t>(height) * static_cast<std::size_t>(stride));

      // Keep the OpenNI row stride instead of assuming tightly packed rows.
      for (int row = 0; row < height; ++row) {
        std::memcpy(
          message.data.data() + static_cast<std::size_t>(row) * stride,
          source + static_cast<std::size_t>(row) * stride,
          static_cast<std::size_t>(stride));
      }
      depth_pub_->publish(message);

      ++frame_count;
      if (frame_count == 1) {
        RCLCPP_INFO(
          get_logger(), "Publishing /camera/depth/image_raw: %dx%d, %s, step=%d",
          width, height, message.encoding.c_str(), stride);
      }

      const auto now_time = std::chrono::steady_clock::now();
      if (now_time - last_report >= std::chrono::seconds(5)) {
        const double seconds =
          std::chrono::duration<double>(now_time - last_report).count();
        RCLCPP_INFO(
          get_logger(), "Depth interval: %llu frames (%.2f FPS)",
          static_cast<unsigned long long>(frame_count),
          static_cast<double>(frame_count) / seconds);
        frame_count = 0;
        last_report = now_time;
      }
    }
  }

  void close_device()
  {
    stop_requested_.store(true);
    if (depth_stream_.isValid()) {
      depth_stream_.stop();
    }
    if (capture_thread_.joinable()) {
      capture_thread_.join();
    }
    if (depth_stream_.isValid()) {
      depth_stream_.destroy();
    }
    if (device_.isValid()) {
      device_.close();
    }
    if (openni_initialized_) {
      openni::OpenNI::shutdown();
      openni_initialized_ = false;
    }
  }

  std::string device_uri_;
  std::string frame_id_;
  int depth_width_{320};
  int depth_height_{240};
  int depth_fps_{30};
  bool openni_initialized_{false};
  std::atomic<bool> stop_requested_{false};
  openni::Device device_;
  openni::VideoStream depth_stream_;
  std::thread capture_thread_;
  rclcpp::Publisher<sensor_msgs::msg::Image>::SharedPtr depth_pub_;
};

int main(int argc, char ** argv)
{
  rclcpp::init(argc, argv);
  int return_code = 0;
  try {
    auto node = std::make_shared<AstraDepthNode>();
    rclcpp::spin(node);
  } catch (const std::exception & error) {
    RCLCPP_ERROR(rclcpp::get_logger("astra_openni2"), "%s", error.what());
    return_code = 1;
  }
  if (rclcpp::ok()) {
    rclcpp::shutdown();
  }
  return return_code;
}