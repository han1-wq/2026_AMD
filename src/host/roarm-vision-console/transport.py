import subprocess
import base64
import json
import queue
import threading
from pathlib import Path

ROOT = Path(__file__).resolve().parent
SSH = ['ssh', '-S', '/run/user/1000/kv260-desktop-amd-16080.sock', '-o', 'BatchMode=yes',
       '-o', 'ConnectTimeout=8', '-o', 'ServerAliveInterval=5', '-o', 'ServerAliveCountMax=2',
       'ubuntu@192.168.43.182']
ROS = 'source /opt/ros/humble/setup.bash; source /home/ubuntu/roarm_ws/install/setup.bash; '
VISION_ENV = ('export ROS_DOMAIN_ID=0 ROS_LOCALHOST_ONLY=0 '
              'FASTRTPS_DEFAULT_PROFILES_FILE=/home/ubuntu/x3plus-kv260-docker/ofdm_ros_udp.xml '
              'FASTDDS_DEFAULT_PROFILES_FILE=/home/ubuntu/x3plus-kv260-docker/ofdm_ros_udp.xml; ')


def vision_process():
    log = (ROOT / 'inspection/vision-transport.log').open('a')
    try:
        process = subprocess.Popen(SSH + [ROS + VISION_ENV + 'exec python3 -u -'],
                                   stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=log,
                                   text=True, bufsize=1)
    finally:
        log.close()
    process.stdin.write((ROOT / 'remote_vision.py').read_text())
    process.stdin.close()
    return process


class ArmCommandError(RuntimeError):
    def __init__(self, message, evidence):
        super().__init__(message)
        self.evidence = evidence


class ArmClient:
    def __init__(self):
        self.process = None
        self.lock = threading.Lock()
        self.responses = queue.Queue()
        self.sequence = 0
        self.latest = None

    def connect(self):
        with self.lock:
            if self.process and self.process.poll() is None:
                return self.latest
            self.responses = queue.Queue()
            # Bundle the same bounds into the in-memory remote worker.
            bundled = (ROOT/'motion.py').read_text()+'\n'+(ROOT/'remote_arm.py').read_text().replace(
                'from motion import step_target, check_feedback, SPEED, ACC','')
            source = base64.b64encode(bundled.encode()).decode()
            command = (ROS + 'export PYTHONDONTWRITEBYTECODE=1 ROARM_MODEL=roarm_m3 ROS_DOMAIN_ID=99 '
                       'ROS_LOCALHOST_ONLY=1; exec python3 -u -c ' +
                       __import__('shlex').quote("import base64;exec(base64.b64decode(%r))" % source))
            with (ROOT/'inspection/arm-transport.log').open('a') as log:
                self.process = subprocess.Popen(SSH+[command],stdin=subprocess.PIPE,stdout=subprocess.PIPE,
                                                stderr=log,text=True,bufsize=1)
            process = self.process
            responses = self.responses
            def reader():
                try:
                    for line in process.stdout:
                        if line.startswith('{'):
                            responses.put(json.loads(line))
                finally:
                    responses.put({'error':'机械臂 SSH 连接已关闭'})
            threading.Thread(target=reader,daemon=True).start()
            try:
                answer = self.responses.get(timeout=15)
                if not answer.get('ready'):
                    raise RuntimeError(answer.get('error','机械臂未就绪'))
                self.latest = answer
                return answer
            except Exception:
                process.stdin.close()
                process.terminate()
                raise

    def call(self, op, **args):
        with self.lock:
            if not self.process or self.process.poll() is not None:
                raise RuntimeError('请先连接机械臂实机反馈')
            self.sequence += 1
            request = dict(id=self.sequence,op=op,**args)
            self.process.stdin.write(json.dumps(request)+'\n')
            self.process.stdin.flush()
            try:
                answer = self.responses.get(timeout=8)
            except queue.Empty:
                self.process.stdin.close()
                self.process.terminate()
                self.process = None
                self.latest = None
                raise RuntimeError('实机反馈超时，连接停止发送动作') from None
            if answer.get('id') != self.sequence or answer.get('error'):
                if answer.get('id') != self.sequence:
                    self.process.stdin.close()
                    self.process.terminate()
                    self.process = None
                    self.latest = None
                evidence = answer if answer.get('id') == self.sequence else {'dispatch':'unknown'}
                raise ArmCommandError(answer.get('error','反馈序列号不匹配'),evidence)
            self.latest = answer
            return answer

    def close(self):
        with self.lock:
            if self.process and self.process.poll() is None:
                self.process.stdin.close()
                try:
                    self.process.wait(timeout=5)
                except subprocess.TimeoutExpired:
                    self.process.terminate()
            self.process = None