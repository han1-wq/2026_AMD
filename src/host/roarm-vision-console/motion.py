"""Single-joint commissioning bounds shared by controller and SSH worker."""
import math

# Conservative intersection of SDK and the installed RoArm M3 URDF.
LIMITS = ((-3.14,3.14),(-1.57,1.57),(-1.,2.95),(-1.57,1.57),(-3.14,3.14))
MAX_STEP = .012
MAX_TRAVEL = .18
SPEED = 30
ACC = 5


def vector(values, size):
    if not isinstance(values,(list,tuple)) or len(values)!=size or any(
        isinstance(v,bool) or not isinstance(v,(int,float)) or not math.isfinite(v) for v in values):
        raise ValueError('运动数值无效')
    return list(values)


def step_target(before, expected, joint, delta, origin, travel):
    before, expected, origin = (vector(v,10) for v in (before,expected,origin))
    if type(joint) is not int or not 1<=joint<=5:
        raise ValueError('仅允许关节 1–5；推动任务禁止夹爪开合')
    vector([delta,travel],2)
    if not .003<=abs(delta)<=MAX_STEP or not 0<=travel or travel+abs(delta)>MAX_TRAVEL+1e-9:
        raise ValueError('单步或累计运动预算超限')
    if max(abs(a-b) for a,b in zip(before[4:],expected[4:]))>.006:
        raise ValueError('决策后机械臂姿态改变，丢弃动作')
    target = before[joint+3]+delta
    low,high = LIMITS[joint-1]
    if not low<=target<=high or abs(target-origin[joint+3])>.08:
        raise ValueError('关节超出本次局部工作范围')
    return target


def check_feedback(before, after, joint, delta, target):
    before, after = vector(before,10),vector(after,10)
    measured = after[joint+3]-before[joint+3]
    if measured*delta<=0 or abs(measured)<.001:
        raise RuntimeError('编码器未确认同向位移：实测 %+.6f rad；停止后续运动'%measured)
    if abs(after[joint+3]-target)>.004:
        raise RuntimeError('编码器目标误差超限；停止后续运动')
    if any(abs(after[i]-before[i])>.009 for i in range(4,10) if i!=joint+3):
        raise RuntimeError('其他关节偏移；停止后续运动')
    return measured