#!/usr/bin/env python3

import time

import numpy as np


def bbox_iou(box_a, box_b):
    """
    计算两个 [x1, y1, x2, y2] 检测框的 IoU。
    """
    intersection_x1 = max(
        float(box_a[0]),
        float(box_b[0]),
    )

    intersection_y1 = max(
        float(box_a[1]),
        float(box_b[1]),
    )

    intersection_x2 = min(
        float(box_a[2]),
        float(box_b[2]),
    )

    intersection_y2 = min(
        float(box_a[3]),
        float(box_b[3]),
    )

    intersection_width = max(
        0.0,
        intersection_x2 - intersection_x1,
    )

    intersection_height = max(
        0.0,
        intersection_y2 - intersection_y1,
    )

    intersection_area = (
        intersection_width
        * intersection_height
    )

    area_a = (
        max(
            0.0,
            float(box_a[2]) - float(box_a[0]),
        )
        * max(
            0.0,
            float(box_a[3]) - float(box_a[1]),
        )
    )

    area_b = (
        max(
            0.0,
            float(box_b[2]) - float(box_b[0]),
        )
        * max(
            0.0,
            float(box_b[3]) - float(box_b[1]),
        )
    )

    union = (
        area_a
        + area_b
        - intersection_area
    )

    if union <= 1e-9:
        return 0.0

    return intersection_area / union


class Track:
    """
    单个目标轨迹。

    使用：
      - IoU 检测关联
      - 恒定速度位置预测
      - 指数移动平均平滑
    """

    def __init__(
        self,
        track_id,
        bbox,
        score,
        class_id,
        timestamp,
    ):
        self.track_id = int(track_id)
        self.class_id = int(class_id)
        self.score = float(score)

        self.bbox = np.asarray(
            bbox,
            dtype=np.float32,
        ).copy()

        self.velocity = np.zeros(
            (4,),
            dtype=np.float32,
        )

        self.last_detection_bbox = (
            self.bbox.copy()
        )

        self.created_time = float(timestamp)
        self.last_state_time = float(timestamp)
        self.last_detection_time = float(timestamp)

        self.hits = 1
        self.misses = 0

    def predict(self, timestamp):
        """
        根据恒速模型，把框预测到 timestamp。
        """
        timestamp = float(timestamp)

        dt = timestamp - self.last_state_time

        if dt <= 0.0:
            return

        # 防止系统临时卡顿后预测框突然飞走。
        dt = min(dt, 0.15)

        self.bbox = (
            self.bbox
            + self.velocity * dt
        )

        self.last_state_time = timestamp

    def update(
        self,
        measured_bbox,
        score,
        timestamp,
        position_alpha,
        velocity_alpha,
    ):
        """
        使用新的 YOLO 检测结果修正轨迹。

        position_alpha:
          越大越相信新的检测框；
          越小越平滑，但响应较慢。

        velocity_alpha:
          越大，速度响应越快；
          越小，预测运动越平稳。
        """
        timestamp = float(timestamp)

        measured_bbox = np.asarray(
            measured_bbox,
            dtype=np.float32,
        )

        # 先把当前状态预测到检测完成时刻。
        self.predict(timestamp)

        detection_dt = max(
            timestamp - self.last_detection_time,
            1e-3,
        )

        measured_velocity = (
            measured_bbox
            - self.last_detection_bbox
        ) / detection_dt

        # 限制异常速度，防止误匹配后框快速飞走。
        measured_velocity = np.clip(
            measured_velocity,
            -2000.0,
            2000.0,
        )

        self.velocity = (
            self.velocity
            * (1.0 - velocity_alpha)
            + measured_velocity
            * velocity_alpha
        )

        self.bbox = (
            self.bbox
            * (1.0 - position_alpha)
            + measured_bbox
            * position_alpha
        )

        self.last_detection_bbox = (
            measured_bbox.copy()
        )

        self.score = float(score)
        self.last_detection_time = timestamp
        self.last_state_time = timestamp

        self.hits += 1
        self.misses = 0


class SortLikeTracker:
    """
    适合 KV260 的轻量级 SORT-like 跟踪器。

    特点：
      - 不依赖 scipy
      - 不依赖额外神经网络
      - 相同类别按 IoU 关联
      - 贪心匹配
      - 恒速预测
      - 坐标平滑
      - 自动清理过期轨迹
    """

    def __init__(
        self,
        iou_threshold=0.30,
        new_track_threshold=0.45,
        max_age_seconds=0.60,
        max_output_age_seconds=0.35,
        min_hits=1,
        position_alpha=0.70,
        velocity_alpha=0.35,
    ):
        self.iou_threshold = float(
            iou_threshold
        )

        self.new_track_threshold = float(
            new_track_threshold
        )

        self.max_age_seconds = float(
            max_age_seconds
        )

        self.max_output_age_seconds = float(
            max_output_age_seconds
        )

        self.min_hits = int(min_hits)

        self.position_alpha = float(
            position_alpha
        )

        self.velocity_alpha = float(
            velocity_alpha
        )

        self.tracks = []
        self.next_track_id = 1

    def _predict_all(self, timestamp):
        for track in self.tracks:
            track.predict(timestamp)

    def _associate(
        self,
        boxes,
        classes,
    ):
        """
        在相同类别的检测框和轨迹之间执行贪心 IoU 匹配。
        """
        candidates = []

        for track_index, track in enumerate(
            self.tracks
        ):
            for detection_index in range(
                len(boxes)
            ):
                if (
                    track.class_id
                    != int(classes[detection_index])
                ):
                    continue

                iou = bbox_iou(
                    track.bbox,
                    boxes[detection_index],
                )

                if iou >= self.iou_threshold:
                    candidates.append(
                        (
                            iou,
                            track_index,
                            detection_index,
                        )
                    )

        # 优先匹配 IoU 最大的组合。
        candidates.sort(
            key=lambda item: item[0],
            reverse=True,
        )

        used_tracks = set()
        used_detections = set()
        matches = []

        for (
            iou,
            track_index,
            detection_index,
        ) in candidates:
            if track_index in used_tracks:
                continue

            if detection_index in used_detections:
                continue

            used_tracks.add(track_index)
            used_detections.add(
                detection_index
            )

            matches.append(
                (
                    track_index,
                    detection_index,
                    iou,
                )
            )

        unmatched_tracks = [
            index
            for index in range(len(self.tracks))
            if index not in used_tracks
        ]

        unmatched_detections = [
            index
            for index in range(len(boxes))
            if index not in used_detections
        ]

        return (
            matches,
            unmatched_tracks,
            unmatched_detections,
        )

    def _remove_expired(self, timestamp):
        """
        删除长时间没有被 YOLO 检测更新的轨迹。
        """
        remaining_tracks = []

        for track in self.tracks:
            detection_age = (
                timestamp
                - track.last_detection_time
            )

            if detection_age <= self.max_age_seconds:
                remaining_tracks.append(track)

        self.tracks = remaining_tracks

    def update(
        self,
        boxes,
        scores,
        classes,
        timestamp=None,
    ):
        """
        收到一组新的 YOLO 检测结果时调用。
        """
        if timestamp is None:
            timestamp = time.perf_counter()

        timestamp = float(timestamp)

        boxes = np.asarray(
            boxes,
            dtype=np.float32,
        ).reshape(-1, 4)

        scores = np.asarray(
            scores,
            dtype=np.float32,
        ).reshape(-1)

        classes = np.asarray(
            classes,
            dtype=np.int32,
        ).reshape(-1)

        self._predict_all(timestamp)

        (
            matches,
            unmatched_tracks,
            unmatched_detections,
        ) = self._associate(
            boxes,
            classes,
        )

        # 修正匹配成功的轨迹。
        for (
            track_index,
            detection_index,
            _,
        ) in matches:
            self.tracks[track_index].update(
                boxes[detection_index],
                scores[detection_index],
                timestamp,
                self.position_alpha,
                self.velocity_alpha,
            )

        # 未匹配轨迹记录一次丢失。
        for track_index in unmatched_tracks:
            self.tracks[track_index].misses += 1

        # 为未匹配的高置信度检测创建新轨迹。
        for detection_index in unmatched_detections:
            if (
                float(scores[detection_index])
                < self.new_track_threshold
            ):
                continue

            track = Track(
                track_id=self.next_track_id,
                bbox=boxes[detection_index],
                score=scores[detection_index],
                class_id=classes[detection_index],
                timestamp=timestamp,
            )

            self.tracks.append(track)
            self.next_track_id += 1

        self._remove_expired(timestamp)

        return self.get_tracks(timestamp)

    def predict(self, timestamp=None):
        """
        两次 YOLO 检测之间，根据速度预测目标位置。
        """
        if timestamp is None:
            timestamp = time.perf_counter()

        timestamp = float(timestamp)

        self._predict_all(timestamp)
        self._remove_expired(timestamp)

        return self.get_tracks(timestamp)

    def get_tracks(self, timestamp=None):
        """
        返回当前可以显示的轨迹。

        返回：
          boxes
          scores
          classes
          track_ids
        """
        if timestamp is None:
            timestamp = time.perf_counter()

        timestamp = float(timestamp)

        output_boxes = []
        output_scores = []
        output_classes = []
        output_ids = []

        for track in self.tracks:
            detection_age = (
                timestamp
                - track.last_detection_time
            )

            if track.hits < self.min_hits:
                continue

            # 检测结果太旧时不再显示，但轨迹可以继续保留，
            # 等待短时间内重新匹配。
            if (
                detection_age
                > self.max_output_age_seconds
            ):
                continue

            output_boxes.append(
                track.bbox.copy()
            )

            output_scores.append(
                track.score
            )

            output_classes.append(
                track.class_id
            )

            output_ids.append(
                track.track_id
            )

        if not output_boxes:
            return (
                np.empty(
                    (0, 4),
                    dtype=np.float32,
                ),
                np.empty(
                    (0,),
                    dtype=np.float32,
                ),
                np.empty(
                    (0,),
                    dtype=np.int32,
                ),
                np.empty(
                    (0,),
                    dtype=np.int32,
                ),
            )

        return (
            np.asarray(
                output_boxes,
                dtype=np.float32,
            ),
            np.asarray(
                output_scores,
                dtype=np.float32,
            ),
            np.asarray(
                output_classes,
                dtype=np.int32,
            ),
            np.asarray(
                output_ids,
                dtype=np.int32,
            ),
        )

    def reset(self):
        """
        清除全部轨迹。
        """
        self.tracks = []
        self.next_track_id = 1
