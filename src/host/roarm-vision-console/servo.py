"""Model-proposed, bounded visual feedback loop; no open-loop trajectory queue."""
import base64
import json
import time

import numpy as np
from PIL import Image
import io

from motion import step_target, check_feedback, MAX_STEP, MAX_TRAVEL
from transport import ROOT


def scene_change(a,b):
    def pixels(frame):
        return np.asarray(Image.open(io.BytesIO(base64.b64decode(frame['jpeg']))).convert('L').resize((80,60)),dtype=float)
    return float(np.mean(abs(pixels(a)-pixels(b))))


def check_plan(d, history):
    if d['action'] not in ('calibrate','approach','push'):
        raise ValueError('当前模型决策不是可执行运动')
    if d.get('confidence',0)<.85 or d.get('clearance_verified') is not True or not d.get('step'):
        raise ValueError('缺少可信短步或局部运动空间证据')
    if d['action']!='calibrate':
        if d.get('tip') is None or d.get('goal_tip') is None or d.get('mapping_verified') is not True:
            raise ValueError('接近前需要可见接触尖端和已验证的局部方向')
        if not any(h.get('execution') and h['decision']['step']['joint']==d['step']['joint'] for h in history):
            raise ValueError('该关节尚无实测视觉标定')
    if d['action']=='push' and d.get('contact_ready') is not True:
        raise ValueError('尚未建立推动接触')


def run_servo(console, cancel):
    folder = ROOT/'inspection'/('servo-'+time.strftime('%Y%m%d-%H%M%S'))
    folder.mkdir()
    history, previous_frame = [],None
    origin = console._read_feedback()['feedback']
    travel = 0.
    console.event('模型实机闭环开始；单步 ≤0.012 rad，累计 ≤0.18 rad；夹爪开合禁用')
    for index in range(20):
        if cancel.is_set():
            return
        feedback = console._read_feedback()
        frame = console.vision.snapshot()
        (folder/('%02d-before.jpg'%index)).write_bytes(base64.b64decode(frame['jpeg']))
        context = dict(motion_enabled=True, feedback=feedback,
            feedback_units='x,y,z mm; tilt,b,s,e,t,r,g radians',
            forward_direction='away_from_camera',depth_registered=False,
            target='operator-designated bottle',operator_report='cables far away',
            available_command='single joint delta radians; IDs 1 base,2 shoulder,3 elbow,4 wrist,5 roll',
            max_step_rad=MAX_STEP,remaining_travel_rad=MAX_TRAVEL-travel,
            history=history,observation_number=index+1)
        console.phase = 'planning'
        console.event('模型正在选择第 %d 步（读取当前图像、上一步图像和实机反馈）'%(index+1))
        result = console.model.observe(frame,console.task,context,previous_frame=previous_frame)
        if cancel.is_set():
            return
        result['observation_only'] = False
        console.result = result
        d = result['decision']
        row = {'decision':d,'feedback':feedback,'observed_stamp':frame['stamp'],
               'dispatch':'not_sent','motion_verified':False}
        (folder/('%02d-plan.json'%index)).write_text(json.dumps(row,ensure_ascii=False,indent=2))
        console.event(d['reason'])
        if d['action']=='done':
            console.phase = 'review_required'
            console.event('模型报告完成，前后图像已保存；需核验瓶子远离相机的实际位移')
            return
        if d['action'] in ('observe','blocked'):
            history.append(row)
            if sum(1 for h in history[-3:] if not h.get('execution'))>=3:
                raise RuntimeError('连续三次无可执行动作：'+d['reason'])
            previous_frame=frame
            continue
        try:
            check_plan(d,history)
        except ValueError as exc:
            row['rejection']=str(exc)
            (folder/('%02d-plan.json'%index)).write_text(json.dumps(row,ensure_ascii=False,indent=2))
            history.append(row)
            console.event('动作未发送：'+str(exc)+'；反馈模型重新评估')
            if sum('rejection' in h for h in history[-3:])>=3:
                raise RuntimeError('连续三次动作未通过校验；'+str(exc)) from None
            previous_frame=frame
            continue
        latest = console.vision.snapshot()
        if scene_change(frame,latest)>5.:
            row['rejection']='scene_changed: 动作在发送前丢弃，未发送串口命令'
            (folder/('%02d-plan.json'%index)).write_text(json.dumps(row,ensure_ascii=False,indent=2))
            console.event('模型推理期间画面改变，丢弃本次动作并重新观察')
            history.append(row)
            continue
        current = console._read_feedback()['feedback']
        step=d['step']
        step_target(current,feedback['feedback'],step['joint'],step['delta_rad'],origin,travel)
        with console.lock:
            if cancel.is_set():
                return
            console.phase = 'moving'
            # Dispatch under lock; stop cannot race a new command after cancellation.
            row['dispatch']='unknown'
            (folder/('%02d-dispatch.json'%index)).write_text(json.dumps(row,ensure_ascii=False,indent=2))
            try:
                execution = console.arm.call('step',**step,expected=current,issued_at=time.time())
                row['dispatch']='sent'
                row['execution']=execution
                check_feedback(execution['before'],execution['feedback'],step['joint'],
                               step['delta_rad'],current[step['joint']+3]+step['delta_rad'])
                row['motion_verified']=True
            except Exception as exc:
                evidence=getattr(exc,'evidence',{})
                row['dispatch']=evidence.get('dispatch',row['dispatch'])
                row['execution_error']=str(exc)
                row['execution_evidence']=evidence
                (folder/('%02d-failed.json'%index)).write_text(json.dumps(row,ensure_ascii=False,indent=2))
                raise
        console.feedback,console.feedback_at=execution,time.monotonic()
        travel+=abs(step['delta_rad'])
        row['execution']=execution
        history.append(row)
        (folder/('%02d-executed.json'%index)).write_text(json.dumps(row,ensure_ascii=False,indent=2))
        console.event('实机已执行 J%d %+.4f rad；编码器 %.4f → %.4f'%(
            step['joint'],step['delta_rad'],execution['before'][step['joint']+3],execution['feedback'][step['joint']+3]))
        # A frame after the completion-time snapshot, not merely after planning.
        completed = console.vision.snapshot()['stamp']
        after = console.vision.fresh_after(completed)
        (folder/('%02d-after.jpg'%index)).write_bytes(base64.b64decode(after['jpeg']))
        previous_frame=frame
    console.phase='budget_exhausted'
    console.event('本轮视觉闭环达到 20 次决策预算，停止；未自动声明成功')