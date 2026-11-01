from __future__ import print_function
import os, time, math, json, subprocess, signal, sys
import numpy as np
import rospy, tf
from nav_msgs.msg import OccupancyGrid
from sensor_msgs.msg import LaserScan
from geometry_msgs.msg import PoseWithCovarianceStamped
from std_srvs.srv import Empty

rospy.init_node('isolated_localization_test')
grid = np.zeros((200, 240), dtype=np.int8)
grid[:2,:] = 100; grid[-2:,:] = 100
grid[:,:2] = 100; grid[:,-2:] = 100
grid[40:90,80:86] = 100
grid[135:140,140:195] = 100
grid[25:45,185:205] = 100
resolution = .05
origin = (-4., -4.)
truth = (2., 1., .6)
odom = (4., -2., 1.)
map_msg = OccupancyGrid()
map_msg.header.frame_id = 'map'
map_msg.info.resolution = resolution
map_msg.info.width = 240; map_msg.info.height = 200
map_msg.info.origin.position.x, map_msg.info.origin.position.y = origin
map_msg.info.origin.orientation.w = 1.
map_msg.data = grid.ravel().tolist()
map_pub = rospy.Publisher('/map', OccupancyGrid, queue_size=1, latch=True)
scan_pub = rospy.Publisher('/scan', LaserScan, queue_size=1)
wrong_pub = rospy.Publisher('/start_point', PoseWithCovarianceStamped, queue_size=1)
init_pub = rospy.Publisher('/initialpose', PoseWithCovarianceStamped, queue_size=1)
br = tf.TransformBroadcaster()
listener = tf.TransformListener()
poses = []
def on_pose(m):
    q = m.pose.pose.orientation
    poses.append({'x': m.pose.pose.position.x, 'y': m.pose.pose.position.y,
                  'yaw': tf.transformations.euler_from_quaternion([q.x,q.y,q.z,q.w])[2],
                  'cov_x':m.pose.covariance[0], 'cov_y':m.pose.covariance[7]})
sub = rospy.Subscriber('/amcl_pose', PoseWithCovarianceStamped, on_pose)
scan = LaserScan()
scan.header.frame_id = 'laser'
scan.angle_min = -math.pi
scan.angle_increment = 2*math.pi/360
scan.angle_max = scan.angle_min+359*scan.angle_increment
scan.range_min = .05; scan.range_max = 12.; scan.scan_time = .1
ranges=[]
for i in range(360):
    a=truth[2]+scan.angle_min+i*scan.angle_increment
    distance=12.
    for r in np.arange(.05,12.,.025):
        x=int((truth[0]+r*math.cos(a)-origin[0])/resolution)
        y=int((truth[1]+r*math.sin(a)-origin[1])/resolution)
        if x<0 or y<0 or x>=240 or y>=200 or grid[y,x]:
            distance=float(r); break
    ranges.append(distance)
scan.ranges=ranges
results=[]
def output(text):
    print(text)
    sys.stdout.flush()
def publish_environment():
    now=rospy.Time.now()
    br.sendTransform((odom[0],odom[1],0),tf.transformations.quaternion_from_euler(0,0,odom[2]),now,'base_footprint','odom')
    br.sendTransform((0,0,0),(0,0,0,1),now,'laser','base_footprint')
    scan.header.stamp=now
    scan_pub.publish(scan)

def phase(name,seconds):
    end=time.time()+seconds
    start_count=len(poses)
    last_force=0
    while time.time()<end and not rospy.is_shutdown():
        publish_environment()
        # Force stationary scan updates so each comparison has equal evidence.
        if time.time()-last_force>.5:
            try: rospy.ServiceProxy('/request_nomotion_update',Empty)()
            except rospy.ServiceException: pass
            last_force=time.time()
        time.sleep(.1)
    pose=poses[-1] if len(poses)>start_count else None
    result={'phase':name,'pose':pose,'new_pose_messages':len(poses)-start_count,
            'map_to_odom_exists':listener.canTransform('map','odom',rospy.Time(0)),
            'initialpose_subscribers':init_pub.get_num_connections(),
            'start_point_subscribers':wrong_pub.get_num_connections()}
    if pose:result['position_error_m']=math.hypot(pose['x']-truth[0],pose['y']-truth[1])
    results.append(result);output(json.dumps(result))

def send_pose(pub):
    msg=PoseWithCovarianceStamped();msg.header.frame_id='map';msg.header.stamp=rospy.Time.now()
    msg.pose.pose.position.x=truth[0];msg.pose.pose.position.y=truth[1]
    q=tf.transformations.quaternion_from_euler(0,0,truth[2])
    msg.pose.pose.orientation.x,msg.pose.pose.orientation.y,msg.pose.pose.orientation.z,msg.pose.pose.orientation.w=q
    msg.pose.covariance[0]=.25;msg.pose.covariance[7]=.25
    msg.pose.covariance[35]=math.radians(15)**2
    pub.publish(msg)

launch='/audit/container/opt/x3plus_ws/src/yahboomcar_nav/launch/library/amcl.launch'
def start_amcl(tag):
    f=open('/audit/amcl-'+tag+'.log','w')
    p=subprocess.Popen(['roslaunch',launch],stdout=f,stderr=subprocess.STDOUT)
    time.sleep(2)
    return p,f
def stop_amcl(p,f):
    p.send_signal(signal.SIGINT)
    deadline=time.time()+8
    while p.poll() is None and time.time()<deadline:time.sleep(.1)
    if p.poll() is None:p.kill();p.wait()
    f.close()

map_pub.publish(map_msg)
p,f=start_amcl('first')
try:
    phase('cold_start_default_zero',6)
    send_pose(wrong_pub);phase('rviz_start_point_wrong_topic',4)
    send_pose(init_pub);phase('rviz_initialpose_correct_topic',8)
finally:stop_amcl(p,f)
saved={k:rospy.get_param('/amcl/'+k,None) for k in ['initial_pose_x','initial_pose_y','initial_pose_a','resample_interval']}
p,f=start_amcl('restart')
try:
    reloaded={k:rospy.get_param('/amcl/'+k,None) for k in saved}
    phase('restart_launch_overwrites_saved_pose',6)
finally:stop_amcl(p,f)
report={'truth':truth,'odom':odom,'saved_after_shutdown':saved,'reloaded_after_restart':reloaded,'results':results,
        'scope':'Real AMCL, copied production launch; synthetic static map/raycast laser and odometry; forced stationary updates; no base driver or move_base.'}
with open('/audit/amcl-results.json','w') as f:json.dump(report,f,indent=2)
assert all(r['pose'] is not None for r in results), 'Missing AMCL output'
assert results[0]['position_error_m']>1., 'Wrong-origin case not reproduced'
assert results[1]['position_error_m']>1., 'Wrong-topic case not reproduced'
assert results[2]['position_error_m']<.3, 'Correct initialization did not converge'
assert results[0]['map_to_odom_exists'], 'Missing TF for false-ready reproduction'
assert reloaded['initial_pose_x']==0. and reloaded['initial_pose_y']==0., 'Restart did not reset parameters'
output('AMCL_REPRODUCTION_PASS')