"""Local visual-servo coordinator with validated model-proposed short steps."""
import copy
import threading
import time

from model import ModelClient
from transport import ArmClient
from vision import Vision


MOTION_BLOCK = '实机闭环可执行模型选择的低速单关节短步；先标定局部视觉方向，再接近与推动'


class Console:
    def __init__(self):
        self.vision = Vision()
        self.arm = ArmClient()
        self.model = ModelClient()
        self.lock = threading.RLock()
        self.worker = None
        self.cancel = threading.Event()
        self.closed = False
        self.task = '把瓶子远离相机推一点'
        self.direction = 'away_from_camera'
        self.phase = 'idle'
        self.error = ''
        self.result = None
        self.feedback = None
        self.feedback_at = None
        self.events = []

    def start(self):
        threading.Thread(target=self.vision.run,daemon=True).start()

    def event(self, text):
        with self.lock:
            self.events.append({'time':time.strftime('%H:%M:%S'),'text':text})
            self.events = self.events[-60:]

    def status(self):
        with self.lock:
            return copy.deepcopy(dict(
                vision=self.vision.status(), model=self.model.public(),
                task=self.task, direction=self.direction, phase=self.phase,
                busy=bool(self.worker and self.worker.is_alive()), error=self.error,
                result=self.result, feedback=self.feedback,
                feedback_age_s=None if self.feedback_at is None else round(time.monotonic()-self.feedback_at,2),
                events=self.events, motion_enabled=True, motion_block=MOTION_BLOCK))

    def configure(self, data):
        with self.lock:
            if self.worker and self.worker.is_alive():
                raise ValueError('请等待当前操作结束后修改模型配置')
            self.model.configure(data)

    def submit(self, operation, data):
        with self.lock:
            if self.closed:
                raise RuntimeError('上位机已关闭')
            if self.worker and self.worker.is_alive():
                raise ValueError('当前操作仍在运行')
            if operation not in ('observe','watch','feedback','servo'):
                raise ValueError('未知操作')
            if operation != 'feedback':
                task = data.get('task',self.task)
                if not isinstance(task,str) or not 1 <= len(task.strip()) <= 2000:
                    raise ValueError('任务必须为 1–2000 字符')
                if not self.model.key:
                    raise ValueError('请在界面输入 API 密钥，密钥仅保存在本机进程内存')
                self.vision.snapshot()
                self.task = task.strip()
            self.cancel = threading.Event()
            self.error = ''
            self.phase = 'reading_feedback' if operation == 'feedback' else 'observing'
            self.worker = threading.Thread(target=self._work,args=(operation,self.cancel),daemon=True)
            self.worker.start()

    def _read_feedback(self):
        self.arm.connect()
        feedback = self.arm.call('feedback')
        with self.lock:
            self.feedback, self.feedback_at = feedback,time.monotonic()
        return feedback

    def _work(self, operation, cancel):
        try:
            if operation == 'servo':
                from servo import run_servo
                run_servo(self,cancel)
                if cancel.is_set():
                    self.phase='stopped'
                return
            if operation == 'feedback':
                self._read_feedback()
                self.event('已读取串口编码器反馈；未发送运动命令')
                with self.lock:
                    self.phase = 'stopped' if cancel.is_set() else 'idle'
                return
            previous = None
            for index in range(20 if operation == 'watch' else 1):
                if cancel.is_set():
                    break
                feedback = self._read_feedback()
                if cancel.is_set():
                    break
                frame = self.vision.snapshot()
                context = dict(forward_direction=self.direction, depth_registered=False,
                               motion_enabled=False, feedback=feedback,
                               previous_observation=previous, observation_number=index+1,
                               instruction='只评估当前图像；目标为瓶子；操作者报告线缆离得远；评估实际局部运动路径。')
                self.event('正在分析新画面（第 %d 次）' % (index+1))
                result = self.model.observe(frame,self.task,context)
                if cancel.is_set():
                    break
                latest = self.vision.snapshot()
                result['scene_elapsed_s'] = round(latest['stamp']-frame['stamp'],3)
                result['observation_only'] = True
                with self.lock:
                    if cancel.is_set():
                        break
                    self.result = result
                    self.phase = 'observing' if operation == 'watch' else 'blocked'
                previous = result['decision']
                self.event(previous['reason'])
                if operation != 'watch' or cancel.wait(3):
                    break
            with self.lock:
                self.phase = 'stopped' if cancel.is_set() else 'blocked'
            if not cancel.is_set():
                self.event(MOTION_BLOCK)
        except Exception as exc:
            # Provider exceptions and response bodies may contain credentials.
            message = str(exc) if isinstance(exc,(ValueError,RuntimeError)) else type(exc).__name__
            if self.model.key:
                message = message.replace(self.model.key,'[已隐藏]')
            with self.lock:
                self.error = message[:300]
                self.phase = 'stopped' if cancel.is_set() else 'error'
            self.event('操作结束：'+self.error)

    def stop(self):
        # Set before acquiring the dispatch lock, even during a feedback wait.
        self.cancel.set()
        with self.lock:
            self.phase = 'stopped'
        self.event('已取消后续动作与在途模型结果；已发出的单个 ≤0.012 rad 短步可能完成；不是硬件急停')

    def close(self):
        self.closed = True
        self.stop()
        self.vision.close()
        self.arm.close()