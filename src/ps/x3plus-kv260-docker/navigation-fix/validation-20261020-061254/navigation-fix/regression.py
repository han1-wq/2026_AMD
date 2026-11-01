#!/usr/bin/env python
"""Real AMCL and production guard regression against an inert planner."""
from __future__ import print_function
import rospy
rospy.init_node('isolated_navigation_regression')
from simulation_environment import *

def planner(goal):
    forwarded.append(goal)
    while not rospy.is_shutdown() and not fake.is_preempt_requested():
        command = Twist()
        command.linear.x = .1
        raw_pub.publish(command)
        time.sleep(.05)
    fake.set_preempted(MoveBaseResult())


fake = actionlib.SimpleActionServer('/navigation_internal/move_base', MoveBaseAction, execute_cb=planner, auto_start=False)
fake.start()
client = actionlib.SimpleActionClient('/move_base', MoveBaseAction)


def spawn(args, filename):
    f = open(root+'/navigation-fix/'+filename, 'w')
    p = subprocess.Popen(args, stdout=f, stderr=subprocess.STDOUT)
    processes.append((p, f))
    return p


def stop(p):
    if p.poll() is None:
        p.send_signal(signal.SIGINT)
        end = time.time()+6
        while p.poll() is None and time.time() < end:
            time.sleep(.05)
        if p.poll() is None:
            p.kill()
            p.wait()


def wait_until(predicate, seconds=15):
    end = time.time()+seconds
    while time.time() < end:
        assert all(p.poll() is None for p, f in processes if p is not stopped_amcl), 'Child exited early'
        if predicate():
            return
        time.sleep(.05)
    raise AssertionError('Condition timeout; guard='+json.dumps(state))


def record(name, **values):
    result = dict(phase=name, guard=dict(state), **values)
    results.append(result)
    print(json.dumps(result))
    __import__('sys').stdout.flush()


def initialize(x=truth[0], y=truth[1], angle=truth[2]):
    m = PoseWithCovarianceStamped()
    m.header.frame_id = 'map'
    m.header.stamp = rospy.Time.now()
    m.pose.pose.position.x, m.pose.pose.position.y = x, y
    q = tf.transformations.quaternion_from_euler(0, 0, angle)
    m.pose.pose.orientation.x, m.pose.pose.orientation.y, m.pose.pose.orientation.z, m.pose.pose.orientation.w = q
    m.pose.covariance[0] = m.pose.covariance[7] = .25
    m.pose.covariance[35] = math.radians(15)**2
    init_pub.publish(m)


def goal():
    g = MoveBaseGoal()
    g.target_pose.header.frame_id = 'map'
    g.target_pose.header.stamp = rospy.Time.now()
    g.target_pose.pose.position.x = 3.
    g.target_pose.pose.orientation.w = 1.
    return g


def rejected(name):
    before = len(forwarded)
    client.send_goal(goal())
    assert client.wait_for_result(rospy.Duration(3.)), 'Public action hung'
    assert client.get_state() == GoalStatus.ABORTED, 'Unconfirmed action not rejected'
    simple_pub.publish(goal().target_pose)
    for i in range(8):
        cmd = Twist()
        cmd.linear.x = .4
        raw_pub.publish(cmd)
        time.sleep(.05)
    assert len(forwarded) == before, 'Unconfirmed goal reached planner'
    assert all(abs(v) < 1e-9 for t, v in output[-4:]), 'Unconfirmed raw speed passed guard'
    record(name, forwarded=len(forwarded), output_zero=True)


def confirm(name):
    started = rospy.Time.now().to_sec()
    initialize()
    wait_until(lambda: state.get('ready') and state.get('stamp', 0) > started+2., 22)
    p = poses[-1].pose.pose.position
    error = math.hypot(p.x-truth[0], p.y-truth[1])
    assert error < .3, 'Correct AMCL initialization inaccurate'
    record(name, position_error_m=error)


stopped_amcl = None
worker = threading.Thread(target=environment)
worker.daemon = True
worker.start()
amcl = spawn(['roslaunch', package+'/launch/library/amcl.launch'], 'regression-amcl.log')
guard = spawn(['python', package+'/scripts/navigation_guard.py'], 'regression-guard.log')
try:
    time.sleep(2)
    map_pub.publish(msg_map)
    assert client.wait_for_server(rospy.Duration(10.))
    wait_until(lambda: len(poses) > 3)
    rejected('cold_start_rejects_all_goal_and_speed_inputs')
    initialize(0., 0., 0.)
    time.sleep(6)
    assert not state.get('ready'), 'Wrong initial pose accepted'
    rejected('explicit_wrong_initial_pose_rejected')
    confirm('correct_initial_pose_converges_and_confirms')
    before = len(forwarded)
    client.send_goal(goal())
    wait_until(lambda: len(forwarded) > before)
    wait_until(lambda: any(abs(v-.1) < .001 for t, v in output[-3:]))
    record('confirmed_action_and_speed_forwarded')
    lost_at = time.time()
    mode['scan'] = False
    wait_until(lambda: not state.get('ready'), 3)
    assert client.wait_for_result(rospy.Duration(3.))
    time.sleep(.3)
    assert all(abs(v) < 1e-9 for t, v in output if t > lost_at+1.1)
    record('scan_loss_cancels_goal_and_stops', stop_latency_s=time.time()-lost_at)
    mode['scan'] = True
    time.sleep(3)
    assert not state.get('ready'), 'Auto-resumed after scan loss'
    rejected('scan_recovery_requires_new_initial_pose')
    confirm('reinitialize_after_scan_loss')
    mode['bad_scan'] = True
    wait_until(lambda: not state.get('ready'), 3)
    record('scan_map_mismatch_stops_navigation')
    mode['bad_scan'] = False
    confirm('reinitialize_after_scan_mismatch')
    mode['tf'] = False
    wait_until(lambda: not state.get('ready'), 3)
    record('tf_loss_stops_navigation')
    mode['tf'] = True
    confirm('reinitialize_after_tf_loss')
    rospy.ServiceProxy('/navigation_guard/reset', Trigger)()
    time.sleep(.3)
    rejected('same_map_reuse_resets_confirmation')
    confirm('confirm_before_amcl_restart')
    stopped_amcl = amcl
    stop(amcl)
    wait_until(lambda: not state.get('ready'), 5)
    amcl = spawn(['roslaunch', package+'/launch/library/amcl.launch'], 'regression-amcl-restart.log')
    time.sleep(4)
    rejected('amcl_restart_never_reuses_confirmation')
    confirm('correct_initial_pose_after_restart')
    stale_goal = goal()
    rospy.ServiceProxy('/navigation_guard/reset', Trigger)()
    confirm('confirm_after_second_session_reset')
    before = len(forwarded)
    client.send_goal(stale_goal)
    assert client.wait_for_result(rospy.Duration(3.))
    assert client.get_state() == GoalStatus.ABORTED and len(forwarded) == before
    record('previous_session_goal_rejected')
    assert poses
    import sys
    import copy
    sys.path.insert(0, package+'/scripts')
    from navigation_guard import NavigationGuard
    # Exercise the actual quality checker before any TF access so this checks
    # covariance rejection independently from publisher restart detection.
    checker = NavigationGuard.__new__(NavigationGuard)
    checker.initial = truth
    checker.initial_time = 0.
    checker.grid = grid
    checker.scan = scan
    checker.scan_wall = time.time()
    checker.pose = copy.deepcopy(poses[-1])
    checker.pose.pose.covariance = list(checker.pose.pose.covariance)
    checker.pose.pose.covariance[0] = 2.
    checker.pose.header.stamp = rospy.Time.now()
    checker.pose_wall = time.time()
    checker.max_age, checker.pose_max_age = .7, 3.
    checker.max_position_std, checker.max_yaw_std = .35, .30
    assert checker.check() == 'high_pose_uncertainty'
    record('high_covariance_rejected_by_quality_checker')
    msg_map.data = list(msg_map.data)
    msg_map.data[100*240+200] = 100
    map_pub.publish(msg_map)
    wait_until(lambda: not state.get('ready'), 2)
    rejected('map_replacement_revokes_confirmation')
    msg_map.data[100*240+200] = 0
    map_pub.publish(msg_map)
    time.sleep(.3)
    confirm('reinitialize_after_map_replacement')
    # An invalid initial message immediately revokes an existing confirmation.
    invalid = PoseWithCovarianceStamped()
    invalid.header.frame_id = 'odom'
    invalid.header.stamp = rospy.Time.now()
    init_pub.publish(invalid)
    wait_until(lambda: not state.get('ready'), 2)
    rejected('invalid_initial_pose_revokes_confirmation')
    with open(root+'/navigation-fix/regression-results.json', 'w') as f:
        json.dump({'results': results, 'scope': 'Real AMCL + production guard, synthetic scan/map/TF, inert planner, no hardware'}, f, indent=2)
    print('NAVIGATION_GUARD_REGRESSION_PASS')
finally:
    mode['quit'] = True
    for p, f in reversed(processes):
        stop(p)
        f.close()
    rospy.signal_shutdown('regression complete')