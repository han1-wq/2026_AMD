#!/usr/bin/env python
"""Real AMCL/guard bookmark protocol against synthetic stationary odometry."""
from __future__ import print_function
import rospy
rospy.init_node('map_server')
from simulation_environment import *
import copy
import uuid
from nav_msgs.msg import Odometry
from std_srvs.srv import Trigger
from visualization_msgs.msg import Marker, MarkerArray

# The fixture advertises an unused pose publisher; only real AMCL may publish.
pose_pub.unregister()
odom_pub = rospy.Publisher('/odom', Odometry, queue_size=1)
request_pub = rospy.Publisher('/navigation/bookmark_request', String, queue_size=1)
replies, markers, initials = [], [], []
velocity_vectors = []
rospy.Subscriber('/navigation/bookmark_reply', String, lambda m: replies.append(json.loads(m.data)), queue_size=10)
rospy.Subscriber('/navigation/start_pose', MarkerArray, lambda m: markers.append(m), queue_size=10)
rospy.Subscriber('/initialpose', PoseWithCovarianceStamped, lambda m: initials.append(m), queue_size=10)
rospy.Subscriber('/cmd_vel', Twist, lambda m: velocity_vectors.append(
    [m.linear.x, m.linear.y, m.linear.z, m.angular.x, m.angular.y, m.angular.z]), queue_size=100)
mode['moving'] = mode['stale_odom'] = mode['no_odom'] = False


def odometry():
    while not mode['quit'] and not rospy.is_shutdown():
        msg = Odometry()
        msg.header.stamp = rospy.Time.now()-rospy.Duration(2. if mode['stale_odom'] else 0.)
        msg.twist.twist.linear.x = .1 if mode['moving'] else 0.
        if not mode['no_odom']:
            odom_pub.publish(msg)
        time.sleep(.05)


def planner(goal):
    forwarded.append(goal)
    while not rospy.is_shutdown() and not fake.is_preempt_requested():
        raw_pub.publish(Twist())
        time.sleep(.05)
    fake.set_preempted(MoveBaseResult())


fake = actionlib.SimpleActionServer('/navigation_internal/move_base', MoveBaseAction, execute_cb=planner, auto_start=False)
fake.start()
client = actionlib.SimpleActionClient('/move_base', MoveBaseAction)


def wait(predicate, timeout=15.):
    end = time.time()+timeout
    while time.time() < end:
        assert all(p.poll() is None for p, f in processes), 'child exited'
        if predicate():
            return
        time.sleep(.05)
    raise AssertionError('timeout; '+json.dumps(state))


def spawn(args, name):
    f = open(root+'/navigation-fix/bookmark-'+name+'.log', 'w')
    processes.append((subprocess.Popen(args, stdout=f, stderr=subprocess.STDOUT), f))


def snapshot():
    result = rospy.ServiceProxy('/navigation_guard/bookmark_snapshot', Trigger)()
    assert result.success, result.message
    return json.loads(result.message)


def command(entry, action='restore', confirmed=True, **overrides):
    req = {'id': uuid.uuid4().hex, 'action': action, 'entry': entry,
           'stamp': rospy.Time.now().to_sec(), 'session': snapshot()['session'],
           'physical_placement_confirmed': confirmed}
    req.update(overrides)
    before = len(replies)
    request_pub.publish(json.dumps(req))
    wait(lambda: len(replies) > before, 4.)
    return replies[-1], req


def record(phase):
    results.append({'phase': phase, 'guard': dict(state)})
    print(phase)


def console_request(request):
    process = subprocess.Popen(['python', root+'/pc-console/bookmark-ros.py'],
                               stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout, stderr = process.communicate(json.dumps(request)+'\n')
    assert process.returncode == 0, stdout+stderr
    result = json.loads(stdout.splitlines()[-1])
    assert result['ok'], result
    return result['result']


passed = False
for target in (environment, odometry):
    worker = threading.Thread(target=target)
    worker.daemon = True
    worker.start()
spawn(['roslaunch', package+'/launch/library/amcl.launch'], 'amcl')
spawn(['python', package+'/scripts/navigation_guard.py'], 'guard')
try:
    time.sleep(2.)
    map_pub.publish(msg_map)
    rospy.wait_for_service('/navigation_guard/bookmark_snapshot', timeout=10.)
    wait(lambda: request_pub.get_num_connections() > 0)
    wait(lambda: len(poses) > 3)
    m = PoseWithCovarianceStamped()
    m.header.frame_id, m.header.stamp = 'map', rospy.Time.now()
    m.pose.pose.position.x, m.pose.pose.position.y = truth[:2]
    q = tf.transformations.quaternion_from_euler(0, 0, truth[2])
    o = m.pose.pose.orientation
    o.x, o.y, o.z, o.w = q
    m.pose.covariance[0] = m.pose.covariance[7] = .25
    m.pose.covariance[35] = math.radians(15)**2
    init_pub.publish(m)
    wait(lambda: state.get('ready'), 22.)
    snap = snapshot()
    assert snap['ready'] and snap['stationary'] and len(snap['pose']) == 3
    entry = {'version': 1, 'name': u'\u56fa\u5b9a\u8d77\u70b9', 'map': snap['map'], 'frame': 'map', 'pose': snap['pose']}
    assert console_request({'action': 'snapshot'})['map'] == snap['map']
    record('saved_map_snapshot_ready_stationary')
    n = len(initials)
    reply, req = command(entry, 'preview')
    assert reply['ok'] and len(initials) == n and not forwarded
    wait(lambda: markers and len(markers[-1].markers) == 2)
    assert markers[-1].markers[0].type == Marker.ARROW
    assert console_request({'action': 'preview', 'entry': entry})['ok']
    assert len(initials) == n
    record('preview_marker_only_no_initialpose_goal_or_motion')
    for field, value in (('physical_placement_confirmed', False), ('stamp', rospy.Time.now().to_sec()-10.),
                         ('session', 'old-session')):
        reply, req = command(entry, **{field: value})
        assert not reply['ok'] and len(initials) == n
    for bad in (dict(entry, frame='odom'), dict(entry, pose=[2., 1., float('nan')]),
                dict(entry, pose=[-100., 1., .6]), dict(entry, map=dict(snap['map'], sha256='b'*64))):
        reply, req = command(bad)
        assert not reply['ok'] and len(initials) == n
    record('unconfirmed_stale_wrong_session_map_and_invalid_pose_rejected')
    for flag in ('moving', 'stale_odom', 'no_odom'):
        mode[flag] = True
        time.sleep(1.4)
        reply, req = command(entry)
        assert not reply['ok'] and len(initials) == n, flag
        mode[flag] = False
        time.sleep(1.4)
    record('moving_stale_and_missing_odometry_rejected')
    # Live graph checks reject a SLAM/extra-map publisher even in navigation UI.
    extra = subprocess.Popen(['python', '-c',
        'import rospy; from nav_msgs.msg import OccupancyGrid; '
        'rospy.init_node("slam_gmapping"); p=rospy.Publisher("/map",OccupancyGrid,queue_size=1); rospy.spin()'])
    try:
        # ARM/Python 2 startup can exceed one second. Exercise the live graph
        # guard only after the competing publisher is registered with Master.
        wait(lambda: set(dict(rospy.get_master().getSystemState()[2][0]).get('/map', []))
             == set(['/map_server', '/slam_gmapping']), 10.)
        denied = rospy.ServiceProxy('/navigation_guard/bookmark_snapshot', Trigger)()
        assert not denied.success
    finally:
        extra.send_signal(signal.SIGINT)
        extra.wait()
    time.sleep(.5)
    record('active_slam_or_multiple_map_publishers_rejected')
    assert client.wait_for_server(rospy.Duration(3.))
    goal = MoveBaseGoal()
    goal.target_pose.header.frame_id, goal.target_pose.header.stamp = 'map', rospy.Time.now()
    goal.target_pose.pose.position.x, goal.target_pose.pose.position.y = truth[:2]
    goal.target_pose.pose.orientation.w = 1.
    client.send_goal(goal)
    wait(lambda: len(forwarded) == 1)
    reply, req = command(entry)
    assert reply['ok'] and not reply['ready']
    assert client.wait_for_result(rospy.Duration(3.)) and client.get_state() != GoalStatus.SUCCEEDED
    wait(lambda: len(initials) == n+1)
    restored = initials[-1]
    assert restored.header.frame_id == 'map' and abs(restored.pose.covariance[35]-math.radians(15)**2) < 1e-9
    before = len(replies)
    request_pub.publish(json.dumps(req))
    wait(lambda: len(replies) > before)
    assert not replies[-1]['ok']
    wait(lambda: state.get('ready'), 22.)
    time.sleep(.5)
    assert len(initials) == n+1 and len(forwarded) == 1
    assert velocity_vectors and all(abs(v) < 1e-9 for values in velocity_vectors for v in values)
    client.send_goal(goal)  # same old timestamp: must not be revived after restore
    assert client.wait_for_result(rospy.Duration(3.)) and client.get_state() == GoalStatus.ABORTED
    assert len(forwarded) == 1
    record('restore_cancels_active_goal_once_rechecks_and_never_auto_moves')
    assert console_request({'action': 'restore', 'entry': entry,
                            'physical_placement_confirmed': True})['ok']
    wait(lambda: len(initials) == n+2)
    wait(lambda: state.get('ready'), 22.)
    assert len(forwarded) == 1 and all(abs(v) < 1e-9 for values in velocity_vectors for v in values)
    record('actual_console_ros_client_snapshot_preview_restore_acknowledged')
    msg_map.data = list(msg_map.data)
    msg_map.data[100*240+200] = 100
    map_pub.publish(msg_map)
    wait(lambda: markers[-1].markers[0].action == Marker.DELETEALL)
    reply, req = command(entry, 'preview')
    assert not reply['ok'] and not state.get('ready')
    record('changed_map_clears_marker_and_rejects_old_bookmark')
    passed = True
    print('NAVIGATION_BOOKMARK_REGRESSION_PASS')
finally:
    with open(root+'/navigation-fix/bookmark-results.json', 'w') as stream:
        json.dump({'passed': passed, 'results': results,
                   'scope': 'Real AMCL/guard; synthetic map/scan/TF/odom; inert stationary planner; no hardware'}, stream, indent=2)
    mode['quit'] = True
    for p, f in reversed(processes):
        if p.poll() is None:
            p.send_signal(signal.SIGINT)
            try:
                end = time.time()+6
                while p.poll() is None and time.time() < end:
                    time.sleep(.05)
                if p.poll() is None:
                    p.kill()
                p.wait()
            finally:
                f.close()
    rospy.signal_shutdown('bookmark regression complete')