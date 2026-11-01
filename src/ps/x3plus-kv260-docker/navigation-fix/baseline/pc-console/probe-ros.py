#!/usr/bin/env python
"""Python 2/3 ROS Melodic probe. Subscribe only; use wall-clock deadlines."""
from __future__ import print_function
import json
import threading
import time
import rospy
import tf
from actionlib_msgs.msg import GoalStatusArray
from geometry_msgs.msg import PoseWithCovarianceStamped
from nav_msgs.msg import OccupancyGrid
from sensor_msgs.msg import LaserScan


def main():
    rospy.init_node('pc_console_probe', anonymous=True, disable_signals=True)
    listener = tf.TransformListener()
    received = {}
    lock = threading.Lock()

    def callback(message, key):
        with lock:
            item = received.setdefault(key, {'count': 0})
            item['count'] += 1
            if key == 'map':
                item.update(width=message.info.width, height=message.info.height)
            if key == 'scan':
                item['frame'] = message.header.frame_id

    specs = [('map', '/map', OccupancyGrid), ('scan', '/scan', LaserScan),
             ('localization', '/amcl_pose', PoseWithCovarianceStamped),
             ('move_base', '/move_base/status', GoalStatusArray)]
    subscribers = [rospy.Subscriber(topic, kind, callback, callback_args=key, queue_size=1)
                   for key, topic, kind in specs]
    started = time.time()
    while time.time() - started < 6 and not rospy.is_shutdown():
        time.sleep(0.1)
    with lock:
        result = {'received': {key: dict(value) for key, value in received.items()}, 'tf': {}}
    laser = result['received'].get('scan', {}).get('frame', 'laser')
    for target in ('base_footprint', laser):
        key = 'map -> ' + target
        try:
            stamp = listener.getLatestCommonTime('map', target)
            listener.lookupTransform('map', target, rospy.Time(0))
            age = (rospy.Time.now() - stamp).to_sec()
            result['tf'][key] = {'ok': -2 <= age <= 5, 'age_seconds': round(age, 2)}
        except tf.Exception as exc:
            result['tf'][key] = {'ok': False, 'error': str(exc)}
    for subscriber in subscribers:
        subscriber.unregister()
    rospy.signal_shutdown('probe complete')
    print(json.dumps(result))


if __name__ == '__main__':
    main()