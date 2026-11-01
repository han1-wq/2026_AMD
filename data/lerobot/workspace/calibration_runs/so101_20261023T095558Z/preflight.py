import json,signal
from pathlib import Path
from lerobot.motors import Motor,MotorNormMode
from lerobot.motors.feetech import FeetechMotorsBus
names=['shoulder_pan','shoulder_lift','elbow_flex','wrist_flex','wrist_roll','gripper']
bus=FeetechMotorsBus(port='/dev/follower',motors={name:Motor(i+1,'sts3215',MotorNormMode.RANGE_0_100 if name=='gripper' else MotorNormMode.RANGE_M100_100) for i,name in enumerate(names)})
def timeout(*_):raise TimeoutError('Read-only preflight exceeded 25 seconds')
signal.signal(signal.SIGALRM,timeout);signal.alarm(25)
try:
 bus.connect()
 registers=['Torque_Enable','Operating_Mode','Homing_Offset','Min_Position_Limit','Max_Position_Limit','Max_Torque_Limit','Torque_Limit','Overload_Torque','Protective_Torque','Protection_Time','Protection_Current','P_Coefficient','I_Coefficient','D_Coefficient','Goal_Velocity','Present_Position','Present_Velocity']
 state={name:{'id':motor.id,'model':motor.model,'registers':{reg:bus.read(reg,name,normalize=False) for reg in registers}} for name,motor in bus.motors.items()}
 Path('/run_artifacts/before.json').write_text(json.dumps(state,indent=2)+chr(10))
 print('PREFLIGHT_PASS: expected six STS3215 IDs and firmware handshake passed',flush=True)
 print(json.dumps(state,indent=2),flush=True)
finally:
 signal.alarm(0)
 if bus.is_connected:bus.disconnect(disable_torque=False)
