"""Temporary SSH RPC: call existing RoarmDriver/SDK, never modify roarm_ws."""
import contextlib
import fcntl
import json
import math
import sys
import time
import subprocess

from motion import step_target, check_feedback, SPEED, ACC


def main():
    output = sys.stdout
    # Reject competing serial owners before constructing the existing driver.
    if subprocess.run(['fuser','/dev/roarm'],stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL).returncode == 0:
        print(json.dumps({'error':'串口已有占用者，未连接'}),flush=True)
        return
    lock = open('/run/user/1000/roarm-vision-console.lock','w')
    fcntl.flock(lock,fcntl.LOCK_EX|fcntl.LOCK_NB)
    with contextlib.redirect_stdout(sys.stderr):
        import rclpy
        from roarm_driver.roarm_driver import RoarmDriver
        rclpy.init()
        driver = RoarmDriver()
        driver.destroy_subscription(driver.joint_states_sub)

    def feedback():
        with contextlib.redirect_stdout(sys.stderr):
            values = driver.roarm.feedback_get()
        if not isinstance(values,(list,tuple)) or len(values)!=10 or any(not math.isfinite(float(v)) for v in values):
            raise RuntimeError('实机反馈无效，拒绝运动')
        return list(values)

    try:
        origin = feedback()
        travel = 0.
        failed = False
        print(json.dumps({'ready':True,'feedback':feedback(),'source':'serial_encoder'}),file=output,flush=True)
        for line in sys.stdin:
            request = {}
            evidence = {'dispatch':'not_sent','motion_verified':False}
            try:
                request = json.loads(line)
                if not isinstance(request,dict):
                    request = {}
                    raise ValueError('无效请求')
                op = request.get('op')
                if op not in ('feedback','step'):
                    raise ValueError('仅允许反馈和有界单关节短步')
                before = feedback()
                target = None
                if op == 'step':
                    if failed:
                        raise RuntimeError('本连接曾发生动作异常，只允许读取反馈')
                    if abs(time.time()-request.get('issued_at',0))>3:
                        raise ValueError('运动请求已过期')
                    joint,delta = request.get('joint'),request.get('delta_rad')
                    target = step_target(before,request.get('expected'),joint,delta,origin,travel)
                    travel += abs(delta)
                    evidence.update(before=before,target_rad=target,travel_rad=travel,
                                    dispatch='unknown',joint=joint,delta_rad=delta)
                    with contextlib.redirect_stdout(sys.stderr):
                        driver.roarm.joint_radian_ctrl(joint=joint,radian=target,speed=SPEED,acc=ACC)
                    evidence['dispatch']='sent'
                    # No queued trajectory: each request is at most 0.012 radians.
                    time.sleep(.5)
                    after = feedback()
                    evidence['feedback']=after
                    evidence['measured_rad']=after[joint+3]-before[joint+3]
                    check_feedback(before,after,joint,delta,target)
                    evidence['motion_verified']=True
                else:
                    after = feedback()
                print(json.dumps({'id':request.get('id'),'feedback':after,'before':before,
                                  'target_rad':target,'travel_rad':travel,
                                  **evidence,
                                  'source':'serial_encoder','time':time.time()}),file=output,flush=True)
            except Exception as exc:
                if request.get('op')=='step':
                    failed = True
                print(json.dumps({'id':request.get('id'),'error':str(exc),**evidence,
                                  'source':'serial_encoder','time':time.time()}),file=output,flush=True)
    finally:
        with contextlib.redirect_stdout(sys.stderr):
            try:
                driver.roarm.disconnect()
            finally:
                driver.destroy_node()
                rclpy.shutdown()
                lock.close()


if __name__ == '__main__':
    main()