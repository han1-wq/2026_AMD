#!/usr/bin/env python
"""Real move_base launch, AMCL and guard; kinematic simulation, no devices."""
from __future__ import print_function
import rospy
rospy.init_node('isolated_navigation_integration')
from simulation_environment import *
import rosgraph
from actionlib_msgs.msg import GoalStatusArray
from move_base_msgs.msg import MoveBaseActionGoal, MoveBaseActionResult

children = []
latest = {'cmd': Twist()}
moving_odom = [odom[0], odom[1], odom[2]]
moving_truth = [truth[0], truth[1], truth[2]]
public_goals, internal_goals, public_results, initial_messages = [], [], [], []
public_status = {}


def receive_status(msg):
    public_status.update({s.goal_id.id: s.status for s in msg.status_list})


rospy.Subscriber('/move_base/goal', MoveBaseActionGoal, lambda m: public_goals.append(m), queue_size=10)
rospy.Subscriber('/navigation_internal/move_base/goal', MoveBaseActionGoal, lambda m: internal_goals.append(m), queue_size=10)
rospy.Subscriber('/move_base/result', MoveBaseActionResult, lambda m: public_results.append(m), queue_size=10)
rospy.Subscriber('/move_base/status', GoalStatusArray, receive_status, queue_size=10)
rospy.Subscriber('/initialpose', PoseWithCovarianceStamped, lambda m: initial_messages.append(m), queue_size=10)


def receive_cmd(msg):
    latest['cmd'] = msg


rospy.Subscriber('/cmd_vel', Twist, receive_cmd, queue_size=1)
from nav_msgs.msg import Odometry
odom_pub = rospy.Publisher('/odom', Odometry, queue_size=1)


def kinematics():
    last = time.time()
    scans = ranges[:]
    count = 0
    while not mode['quit'] and not rospy.is_shutdown():
        now_wall = time.time()
        dt = min(.1, now_wall-last)
        last = now_wall
        cmd = latest['cmd']
        for pose in (moving_odom, moving_truth):
            c, s = math.cos(pose[2]), math.sin(pose[2])
            pose[0] += (c*cmd.linear.x-s*cmd.linear.y)*dt
            pose[1] += (s*cmd.linear.x+c*cmd.linear.y)*dt
            pose[2] += cmd.angular.z*dt
        now = rospy.Time.now()
        if mode['tf']:
            br.sendTransform((moving_odom[0], moving_odom[1], 0), tf.transformations.quaternion_from_euler(0, 0, moving_odom[2]), now, 'base_footprint', 'odom')
            br.sendTransform((0, 0, 0), (0, 0, 0, 1), now, 'laser', 'base_footprint')
            m = Odometry()
            m.header.frame_id, m.child_frame_id, m.header.stamp = 'odom', 'base_footprint', now
            m.pose.pose.position.x, m.pose.pose.position.y = moving_odom[:2]
            q = tf.transformations.quaternion_from_euler(0, 0, moving_odom[2])
            m.pose.pose.orientation.x, m.pose.pose.orientation.y, m.pose.pose.orientation.z, m.pose.pose.orientation.w = q
            m.twist.twist = cmd
            odom_pub.publish(m)
        if mode['scan'] and count % 2 == 0:
            points = np.arange(.05, 12., .025)
            angles = moving_truth[2]+scan.angle_min+np.arange(360)*scan.angle_increment
            x = np.floor((moving_truth[0]+np.cos(angles[:, None])*points[None, :]+4.)/.05).astype(int)
            y = np.floor((moving_truth[1]+np.sin(angles[:, None])*points[None, :]+4.)/.05).astype(int)
            outside = (x < 0) | (y < 0) | (x >= 240) | (y >= 200)
            hits = outside | (grid[np.clip(y, 0, 199), np.clip(x, 0, 239)] > 0)
            first = hits.argmax(axis=1)
            scans = np.where(hits.any(axis=1), points[first], 12.).tolist()
            scan.header.stamp, scan.ranges = now, scans
            scan_pub.publish(scan)
        count += 1
        time.sleep(.025)


def spawn(args, name):
    f = open(root+'/navigation-fix/integration-'+name+'.log', 'w')
    p = subprocess.Popen(args, stdout=f, stderr=subprocess.STDOUT)
    children.append((p, f))
    return p


def wait_for(predicate, seconds):
    until = time.time()+seconds
    while time.time() < until:
        assert all(p.poll() is None for p, f in children), 'Integration child exited'
        if predicate():
            return
        time.sleep(.05)
    raise AssertionError('Timed out: '+json.dumps(state))


def initialize():
    m = PoseWithCovarianceStamped()
    m.header.frame_id, m.header.stamp = 'map', rospy.Time.now()
    m.pose.pose.position.x, m.pose.pose.position.y = moving_truth[:2]
    q = tf.transformations.quaternion_from_euler(0, 0, moving_truth[2])
    m.pose.pose.orientation.x, m.pose.pose.orientation.y, m.pose.pose.orientation.z, m.pose.pose.orientation.w = q
    m.pose.covariance[0] = m.pose.covariance[7] = .25
    m.pose.covariance[35] = math.radians(15)**2
    init_pub.publish(m)


def endpoint_errors(goal):
    p = goal.target_pose.pose
    error = math.hypot(moving_truth[0]-p.position.x, moving_truth[1]-p.position.y)
    q = p.orientation
    angle = tf.transformations.euler_from_quaternion([q.x, q.y, q.z, q.w])[2]
    yaw_error = abs(math.atan2(math.sin(moving_truth[2]-angle), math.cos(moving_truth[2]-angle)))
    assert error < .25, 'Kinematic navigation endpoint error too large'
    assert yaw_error < .2, 'Kinematic navigation heading error too large'
    return {'position_error_m': error, 'yaw_error_rad': yaw_error}


worker = threading.Thread(target=kinematics)
worker.daemon = True
worker.start()
map_base = '/tmp/navigation-integration-map'
with open(map_base+'.pgm', 'wb') as f:
    f.write(b'P5\n240 200\n255\n')
    f.write(np.where(np.flipud(grid) > 0, 0, 254).astype(np.uint8).tostring())
with open(map_base+'.yaml', 'w') as f:
    f.write('image: navigation-integration-map.pgm\nresolution: 0.05\norigin: [-4.0, -4.0, 0.0]\nnegate: 0\noccupied_thresh: 0.65\nfree_thresh: 0.196\n')
launch = spawn(['roslaunch', package+'/launch/yahboomcar_navigation.launch',
                'use_rviz:=false', 'map:='+map_base], 'full-launch')
client = actionlib.SimpleActionClient('/move_base', MoveBaseAction)
try:
    time.sleep(2)
    assert client.wait_for_server(rospy.Duration(10.))
    wait_for(lambda: len(poses) > 3, 15)
    master = rosgraph.Master('/integration_audit')
    pubs, subs, services = master.getSystemState()
    publishers = dict(pubs)
    subscribers = dict(subs)
    assert publishers.get('/cmd_vel') == ['/navigation_guard'], str(publishers.get('/cmd_vel'))
    assert '/move_base' in publishers.get('/navigation_internal/cmd_vel', [])
    assert '/navigation_guard' in subscribers.get('/move_base/goal', [])
    assert '/move_base' not in subscribers.get('/move_base_simple/goal', [])
    g = MoveBaseGoal()
    g.target_pose.header.frame_id = 'map'
    g.target_pose.header.stamp = rospy.Time.now()
    g.target_pose.pose.position.x = truth[0]+.7
    g.target_pose.pose.position.y = truth[1]+.3
    q = tf.transformations.quaternion_from_euler(0, 0, truth[2]+.7)
    g.target_pose.pose.orientation.x, g.target_pose.pose.orientation.y, g.target_pose.pose.orientation.z, g.target_pose.pose.orientation.w = q
    client.send_goal(g)
    assert client.wait_for_result(rospy.Duration(3.))
    assert client.get_state() == GoalStatus.ABORTED
    initialize()
    wait_for(lambda: state.get('ready'), 22)
    g.target_pose.header.stamp = rospy.Time.now()
    before_goals = len(public_goals)
    before_internal = len(internal_goals)
    # Exercise the actual RViz entry point, not a second public action send.
    simple_pub.publish(g.target_pose)
    wait_for(lambda: math.hypot(latest['cmd'].linear.x, latest['cmd'].linear.y) > .02, 20)
    wait_for(lambda: len(public_goals) == before_goals+1, 3)
    retained_id = public_goals[-1].goal_id.id
    assert retained_id.startswith('rviz-')
    # Exactly one initial pose and one accepted goal. No resend after dropout.
    time.sleep(.4)
    mode['scan'] = False
    wait_for(lambda: not state.get('ready') and state.get('goal_retained'), 3)
    assert public_status.get(retained_id) == GoalStatus.ACTIVE, 'Paused public goal became terminal'
    assert not any(r.status.goal_id.id == retained_id for r in public_results)
    time.sleep(.3)
    stopped_pose = list(moving_truth)
    for i in range(6):
        assert all(abs(v) < 1e-9 for v in (latest['cmd'].linear.x, latest['cmd'].linear.y, latest['cmd'].angular.z))
        time.sleep(.05)
    assert math.hypot(moving_truth[0]-stopped_pose[0], moving_truth[1]-stopped_pose[1]) < .001
    mode['scan'] = True
    wait_for(lambda: state.get('ready') and state.get('resume_count') == 1, 5)
    wait_for(lambda: any(r.status.goal_id.id == retained_id for r in public_results), 35)
    result = next(r for r in public_results if r.status.goal_id.id == retained_id)
    assert result.status.status == GoalStatus.SUCCEEDED, 'Retained RViz goal failed: '+str(result.status)
    assert len(initial_messages) == 1 and len(public_goals) == before_goals+1
    assert len(internal_goals) == before_internal+2
    assert internal_goals[-1].goal_id.id != internal_goals[-2].goal_id.id
    assert internal_goals[-1].goal.target_pose.pose == internal_goals[-2].goal.target_pose.pose
    first_endpoint = endpoint_errors(g)
    # Reopening/reusing the same navigation session cancels motion, not AMCL.
    assert rospy.ServiceProxy('/navigation_guard/stop', Trigger)().success
    wait_for(lambda: state.get('ready'), 3)
    error = first_endpoint['position_error_m']
    pc_probe = json.loads(subprocess.check_output(['python', root+'/pc-console/probe-ros.py']).splitlines()[-1])
    assert pc_probe['received']['localization']['fresh']
    assert pc_probe['received']['scan']['fresh']
    assert pc_probe['received']['navigation']['fresh']
    assert pc_probe['received']['navigation']['status']['ready']
    assert pc_probe['received']['cmd_vel']['fresh']
    assert pc_probe['received']['internal_move_base']['fresh']
    assert 'goals' in pc_probe['received']['internal_move_base']
    assert all(item['ok'] for item in pc_probe['tf'].values()), pc_probe['tf']
    with open(root+'/navigation-fix/integration-pc-probe.json', 'w') as f:
        json.dump(pc_probe, f, indent=2)
    # A second target requires both translation and a different final heading.
    g.target_pose.pose.position.x += .45
    g.target_pose.pose.position.y -= .2
    q = tf.transformations.quaternion_from_euler(0, 0, truth[2]+1.)
    g.target_pose.pose.orientation.x, g.target_pose.pose.orientation.y, g.target_pose.pose.orientation.z, g.target_pose.pose.orientation.w = q
    g.target_pose.header.stamp = rospy.Time.now()
    client.send_goal(g)
    assert client.wait_for_result(rospy.Duration(40.)), 'Heading-change goal timed out'
    assert client.get_state() == GoalStatus.SUCCEEDED, 'Heading-change goal failed: '+str(client.get_state())
    heading_endpoint = endpoint_errors(g)
    # RViz orientation-only goal: same position, different arrow direction.
    g.target_pose.pose.position.x, g.target_pose.pose.position.y = moving_truth[:2]
    q = tf.transformations.quaternion_from_euler(0, 0, moving_truth[2]-.8)
    g.target_pose.pose.orientation.x, g.target_pose.pose.orientation.y, g.target_pose.pose.orientation.z, g.target_pose.pose.orientation.w = q
    g.target_pose.header.stamp = rospy.Time.now()
    simple_pub.publish(g.target_pose)
    wait_for(lambda: abs(latest['cmd'].angular.z) > .02, 12)
    wait_for(lambda: abs(latest['cmd'].angular.z) < .001 and not any(abs(v) > .001 for v in
             (latest['cmd'].linear.x, latest['cmd'].linear.y)), 30)
    rotation_endpoint = endpoint_errors(g)
    g.target_pose.pose.position.x += .8
    g.target_pose.header.stamp = rospy.Time.now()
    client.send_goal(g)
    wait_for(lambda: math.hypot(latest['cmd'].linear.x, latest['cmd'].linear.y) > .02, 10)
    mode['scan'] = False
    wait_for(lambda: not state.get('ready'), 3)
    assert client.get_state() == GoalStatus.ACTIVE
    assert client.wait_for_result(rospy.Duration(7.))
    assert client.get_state() != GoalStatus.SUCCEEDED
    time.sleep(.4)
    assert abs(latest['cmd'].linear.x) < 1e-9 and abs(latest['cmd'].angular.z) < 1e-9
    report = {'real_move_base_goal_succeeded': True, 'kinematic_endpoint_error_m': error,
              'single_initialpose_single_accepted_goal_transient_auto_resume': True,
              'paused_public_action_remained_active': True, 'paused_velocity_zero': True,
              'automatic_resume_count': 1,
              'rviz_simple_goal_submissions': 1, 'initialpose_submissions': 1,
              'internal_attempts_with_distinct_ids': 2,
              'first_endpoint': first_endpoint, 'heading_change_endpoint': heading_endpoint,
              'heading_change_goal_succeeded': True,
              'orientation_only_simple_goal_endpoint': rotation_endpoint,
              'same_session_reuse_preserved_localization': True,
              'consecutive_goals_without_initialpose': True,
              'pc_probe_verified_fresh_localization_and_guard': True,
              'public_cmd_vel_publishers': publishers.get('/cmd_vel'),
              'scan_loss_cancelled_real_goal': True, 'guard': dict(state),
              'scope': 'Real AMCL, guard and move_base, ideal kinematics/raycast scan/odom; no physics or hardware.'}
    with open(root+'/navigation-fix/integration-results.json', 'w') as f:
        json.dump(report, f, indent=2)
    print(json.dumps(report))
    print('NAVIGATION_MOVE_BASE_INTEGRATION_PASS')
finally:
    mode['quit'] = True
    for p, f in reversed(children):
        if p.poll() is None:
            p.send_signal(signal.SIGINT)
            deadline = time.time()+6
            while p.poll() is None and time.time() < deadline:
                time.sleep(.05)
            if p.poll() is None:
                p.kill()
                p.wait()
        f.close()
    rospy.signal_shutdown('integration complete')