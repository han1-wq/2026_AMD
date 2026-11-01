#!/usr/bin/env python
"""One bounded ROS operation inside the viewer (Python 2/3).

The host passes JSON on stdin, never as shell source. The guard owns map
validation, initialpose publication and cancellation; this client cannot move.
"""
from __future__ import print_function
import json
import sys
import threading
import time
import uuid

import rospy
from std_msgs.msg import String
from std_srvs.srv import Trigger


def main():
    request = json.loads(sys.stdin.readline())
    rospy.init_node('pc_start_pose', anonymous=True, disable_signals=True)
    rospy.wait_for_service('/navigation_guard/bookmark_snapshot', timeout=4.)
    reply = rospy.ServiceProxy('/navigation_guard/bookmark_snapshot', Trigger)()
    if not reply.success:
        raise ValueError(reply.message)
    snapshot = json.loads(reply.message)
    if request['action'] == 'snapshot':
        return snapshot
    response = []
    event = threading.Event()
    token = uuid.uuid4().hex

    def receive(msg):
        result = json.loads(msg.data)
        if result.get('id') == token:
            response.append(result)
            event.set()

    subscriber = rospy.Subscriber('/navigation/bookmark_reply', String, receive, queue_size=1)
    publisher = rospy.Publisher('/navigation/bookmark_request', String, queue_size=1)
    end = time.time()+3
    while publisher.get_num_connections() < 1 and time.time() < end:
        time.sleep(.05)
    if not publisher.get_num_connections():
        raise ValueError('Guard request subscriber unavailable')
    request.update(id=token, stamp=rospy.Time.now().to_sec(), session=snapshot['session'])
    publisher.publish(json.dumps(request))
    if not event.wait(4.):
        raise ValueError('Guard acknowledgement timeout; inspect localization before retrying')
    subscriber.unregister()
    if not response[0].get('ok'):
        raise ValueError(response[0].get('error', 'Bookmark request refused'))
    return response[0]


if __name__ == '__main__':
    try:
        print(json.dumps({'ok': True, 'result': main()}))
    except Exception as exc:
        print(json.dumps({'ok': False, 'error': str(exc)}))
        sys.exit(1)