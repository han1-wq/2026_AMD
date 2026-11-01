"""Guard-owned, map-bound bookmark protocol; no goal/velocity publishers."""
from __future__ import division
import json
import math
import time
import uuid
from collections import deque

import rospy
import tf
from geometry_msgs.msg import PoseWithCovarianceStamped
from nav_msgs.msg import Odometry
from std_msgs.msg import String
from std_srvs.srv import Trigger, TriggerResponse
from visualization_msgs.msg import Marker, MarkerArray


class NavigationBookmarks(object):
    def __init__(self, guard):
        self.guard = guard
        self.session = uuid.uuid4().hex
        self.seen = deque(maxlen=256)
        self.odometry = deque(maxlen=50)
        self.reply = rospy.Publisher('/navigation/bookmark_reply', String, queue_size=10)
        self.initial = rospy.Publisher('/initialpose', PoseWithCovarianceStamped, queue_size=1)
        self.markers = rospy.Publisher('/navigation/start_pose', MarkerArray, queue_size=1, latch=True)
        self.subs = [rospy.Subscriber('/navigation/bookmark_request', String, self.request, queue_size=1),
                     rospy.Subscriber('/odom', Odometry, self.on_odom, queue_size=10)]
        self.service = rospy.Service('/navigation_guard/bookmark_snapshot', Trigger, self.snapshot)

    def reset_map(self):
        self.session = uuid.uuid4().hex
        marker = Marker()
        marker.action = Marker.DELETEALL
        self.markers.publish(MarkerArray([marker]))

    def on_odom(self, message):
        with self.guard.lock:
            self.odometry.append((time.time(), message))

    def stationary(self):
        now = time.time()
        recent = [(wall, msg) for wall, msg in self.odometry if now-wall <= 1.2]
        if len(recent) < 5 or now-recent[0][0] < .7:
            return False
        if not self.guard.fresh(recent[-1][1].header.stamp, recent[-1][0], .3):
            return False
        for wall, msg in recent:
            v = msg.twist.twist
            values = [v.linear.x, v.linear.y, v.linear.z, v.angular.x, v.angular.y, v.angular.z]
            if any(math.isnan(x) or math.isinf(x) or abs(x) > .01 for x in values):
                return False
        return True

    def require_saved_map(self):
        g = self.guard
        if g.grid is None:
            raise ValueError('No valid map')
        # A viewer mode is not proof of the robot's mode. Check the live graph.
        code, message, system = rospy.get_master().getSystemState()
        if code != 1:
            raise ValueError('Cannot verify ROS graph: '+message)
        pubs = dict(system[0])
        if pubs.get('/map') != ['/map_server'] or pubs.get('/amcl_pose') != ['/amcl']:
            raise ValueError('Bookmarks require saved-map map_server + AMCL, not active SLAM')

    def snapshot(self, unused):
        with self.guard.lock:
            try:
                self.require_saved_map()
                g = self.guard
                result = {'map': g.map_identity, 'session': self.session,
                          'ready': g.ready and not bool(g.check()),
                          'stationary': self.stationary(), 'stamp': rospy.Time.now().to_sec()}
                if result['ready'] and result['stationary']:
                    trans, q = g.listener.lookupTransform('map', 'base_footprint', g.scan.header.stamp)
                    result['pose'] = [trans[0], trans[1], tf.transformations.euler_from_quaternion(q)[2]]
                return TriggerResponse(True, json.dumps(result))
            except Exception as exc:
                return TriggerResponse(False, str(exc))

    def show(self, entry):
        arrow = Marker()
        arrow.header.frame_id = 'map'
        arrow.ns, arrow.id, arrow.type, arrow.action = 'saved_start', 0, Marker.ARROW, Marker.ADD
        arrow.pose.position.x, arrow.pose.position.y = entry['pose'][:2]
        q = tf.transformations.quaternion_from_euler(0, 0, entry['pose'][2])
        arrow.pose.orientation.x, arrow.pose.orientation.y, arrow.pose.orientation.z, arrow.pose.orientation.w = q
        arrow.scale.x, arrow.scale.y, arrow.scale.z = .6, .09, .09
        arrow.color.r, arrow.color.g, arrow.color.b, arrow.color.a = .1, .8, 1., 1.
        label = Marker()
        label.header.frame_id = 'map'
        label.ns, label.id, label.type, label.action = 'saved_start', 1, Marker.TEXT_VIEW_FACING, Marker.ADD
        label.pose.position.x, label.pose.position.y = entry['pose'][:2]
        label.pose.position.z = .5
        label.pose.orientation.w = 1.
        label.scale.z = .2
        label.color.r = label.color.g = label.color.b = label.color.a = 1.
        label.text = entry['name']
        self.markers.publish(MarkerArray([arrow, label]))

    def request(self, message):
        response = {'id': '', 'ok': False}
        with self.guard.lock:
            try:
                if len(message.data) > 8192:
                    raise ValueError('Request too large')
                req = json.loads(message.data)
                token = req['id']
                if not isinstance(token, type(u'')) and not isinstance(token, str):
                    raise ValueError('Invalid request ID')
                response['id'] = token
                if len(token) != 32 or token in self.seen:
                    raise ValueError('Duplicate/invalid request')
                self.seen.append(token)
                stamp = float(req['stamp'])
                age = rospy.Time.now().to_sec()-stamp
                if not 0 <= age <= 3. or req['session'] != self.session:
                    raise ValueError('Expired request or changed map/session')
                self.require_saved_map()
                entry = req['entry']
                g = self.guard
                if entry['map'] != g.map_identity or entry.get('frame') != 'map':
                    raise ValueError('Map fingerprint/metadata mismatch')
                pose = entry['pose']
                if (len(pose) != 3 or any(isinstance(v, bool) or not isinstance(v, (int, float)) or
                        math.isnan(v) or math.isinf(v) for v in pose) or abs(pose[2]) > math.pi):
                    raise ValueError('Invalid bookmark pose')
                if not isinstance(entry['name'], (str, type(u''))) or not 1 <= len(entry['name']) <= 40:
                    raise ValueError('Invalid bookmark name')
                info = g.map_info
                x, y = pose[0]-info.origin.position.x, pose[1]-info.origin.position.y
                c, s = math.cos(g.map_angle), math.sin(g.map_angle)
                ix, iy = int(math.floor((c*x+s*y)/info.resolution)), int(math.floor((-s*x+c*y)/info.resolution))
                if not (0 <= ix < info.width and 0 <= iy < info.height) or g.raw_grid[iy, ix] != 0:
                    raise ValueError('Bookmark is outside known free space')
                action = req['action']
                if action == 'restore':
                    if req.get('physical_placement_confirmed') is not True or not self.stationary():
                        raise ValueError('Confirm physical placement; fresh stationary odometry required')
                    if self.initial.get_num_connections() < 2:
                        raise ValueError('AMCL/guard initial-pose subscribers not connected')
                    # Same lock as map/goal callbacks: revoke BEFORE publishing.
                    g.invalidate('bookmark_restore_initial_pose_required')
                    initial = PoseWithCovarianceStamped()
                    initial.header.frame_id, initial.header.stamp = 'map', rospy.Time.now()
                    initial.pose.pose.position.x, initial.pose.pose.position.y = pose[:2]
                    q = tf.transformations.quaternion_from_euler(0, 0, pose[2])
                    o = initial.pose.pose.orientation
                    o.x, o.y, o.z, o.w = q
                    initial.pose.covariance[0] = initial.pose.covariance[7] = .25
                    initial.pose.covariance[35] = math.radians(15)**2
                    self.initial.publish(initial)
                elif action != 'preview':
                    raise ValueError('Unsupported action')
                self.show(entry)
                response.update(ok=True, action=action, ready=False if action == 'restore' else g.ready)
            except Exception as exc:
                response['error'] = str(exc)
            self.reply.publish(json.dumps(response))