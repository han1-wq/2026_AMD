#!/usr/bin/python3
# encoding:utf-8
import time
import sys

import rclpy
from rclpy.node import Node
from std_msgs.msg import String


class ServoPublisher(Node):

    def __init__(self, id, servo_id, angle):
        super().__init__('servo')
        if "null" in id:
            topic = 'servo'
        else:
            topic = id + '/servo'
        self.publisher = self.create_publisher(String, topic, 10)
        # 等待订阅者连接，最多等5秒
        self.get_logger().info(f'等待订阅者连接 {topic} ...')
        timeout = 5.0
        start = self.get_clock().now().nanoseconds / 1e9
        while self.publisher.get_subscription_count() == 0:
            time.sleep(0.1)
            if self.get_clock().now().nanoseconds / 1e9 - start > timeout:
                self.get_logger().warn('等待订阅者超时，直接发送')
                break
        msg = String()
        msg.data = f"{servo_id}:{angle}:1000:0"   # 舵机ID:角度：时延：是否转到角度后释放舵机(0不释放，1释放)。
        self.publisher.publish(msg)
        self.get_logger().info(f"舵机{servo_id}设置角度{angle}完毕 ")
        time.sleep(0.2)


def main(args=None):
    rclpy.init(args=args)
    id = sys.argv[1]
    servo_id = sys.argv[2] if len(sys.argv) > 2 else "1"
    angle = sys.argv[3] if len(sys.argv) > 3 else "90"
    node = ServoPublisher(id, servo_id, angle)
    node.destroy_node()
    rclpy.shutdown()


if __name__ == '__main__':
    main()
