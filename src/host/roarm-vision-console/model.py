import json
import time
from urllib.parse import urlparse

import requests

from transport import ROOT


class ModelClient:
    def __init__(self):
        self.base_url = 'https://code.rayinai.com/v1'
        self.model = 'gpt-6-astra'
        self.key = ''
        self.mode = 'responses'
        self.effort = 'medium'
        self.session = requests.Session()

    def configure(self, data):
        base = data.get('base_url', self.base_url).rstrip('/')
        parsed = urlparse(base)
        if parsed.scheme != 'https' or not parsed.hostname or parsed.username or parsed.query or parsed.fragment:
            raise ValueError('API 地址必须是 HTTPS，且不能包含凭据或查询参数')
        mode = data.get('mode', self.mode)
        if mode not in ('responses', 'chat'):
            raise ValueError('接口类型必须是 responses 或 chat')
        model = data.get('model', self.model).strip()
        if not model or len(model) > 150:
            raise ValueError('模型名无效')
        self.base_url = base if parsed.path.rstrip('/') else base + '/v1'
        self.model, self.mode = model, mode
        if data.get('api_key'):
            self.key = data['api_key'].strip()

    def public(self):
        return dict(base_url=self.base_url, model=self.model, mode=self.mode,
                    effort=self.effort, key_configured=bool(self.key))

    def observe(self, frame, task, context=None, previous_frame=None):
        if not self.key:
            raise ValueError('请在本机配置 API 密钥')
        instructions = (ROOT / 'skills/visual-servo/SKILL.md').read_text()
        text = json.dumps(dict(task=task, width=frame['width'], height=frame['height'],
                               detections=frame['detections'], context=context or {}), ensure_ascii=False)
        image = 'data:image/jpeg;base64,' + frame['jpeg']
        if self.mode == 'responses':
            body = dict(model=self.model, reasoning={'effort':self.effort},
                        instructions=instructions, max_output_tokens=1400,
                        input=[{'role':'user','content':[{'type':'input_text','text':text},
                               {'type':'input_image','image_url':image}]}])
            endpoint = '/responses'
        else:
            body = dict(model=self.model, reasoning_effort=self.effort, max_completion_tokens=1400,
                        messages=[{'role':'system','content':instructions},
                                  {'role':'user','content':[{'type':'text','text':text},
                                   {'type':'image_url','image_url':{'url':image}}]}])
            endpoint = '/chat/completions'
        if previous_frame:
            previous_image = 'data:image/jpeg;base64,'+previous_frame['jpeg']
            if self.mode == 'responses':
                body['input'][0]['content'].extend([
                    {'type':'input_text','text':'下面是上一步动作前图像；第一张才是当前图像。'},
                    {'type':'input_image','image_url':previous_image}])
            else:
                body['messages'][-1]['content'].extend([
                    {'type':'text','text':'下面是上一步动作前图像；第一张才是当前图像。'},
                    {'type':'image_url','image_url':{'url':previous_image}}])
        started = time.monotonic()
        try:
            response = self.session.post(self.base_url + endpoint, json=body,
                                         headers={'Authorization':'Bearer '+self.key},
                                         timeout=(10, 90), allow_redirects=False)
        except requests.RequestException as exc:
            raise RuntimeError('模型连接失败：' + type(exc).__name__) from None
        if response.status_code != 200:
            # Never surface request headers, keys or provider response bodies.
            raise RuntimeError('模型 API HTTP %s；检查端点、模型和 Medium 参数支持' % response.status_code)
        raw = response.json()
        if self.mode == 'responses':
            output = ''.join(c.get('text','') for item in raw.get('output',[])
                             if item.get('type') == 'message' for c in item.get('content',[])
                             if c.get('type') == 'output_text')
        else:
            output = raw['choices'][0]['message']['content']
        output = output.strip()
        if output.startswith('```'):
            output = output.split('\n', 1)[1].rsplit('```', 1)[0].strip()
        decision = json.loads(output)
        validate_decision(decision, frame['width'], frame['height'])
        return dict(decision=decision, latency_s=round(time.monotonic()-started,3),
                    usage=raw.get('usage',{}), model=raw.get('model',self.model),
                    requested_effort=self.effort, observed_stamp=frame['stamp'])


def validate_decision(d, width, height):
    import math
    required = {'action','confidence','tip','target','goal_tip','reason',
                'target_label','completion_evidence','contact_ready'}
    if not isinstance(d,dict) or not required.issubset(d):
        raise ValueError('模型缺少必需字段')
    if d.get('action') not in ('observe','calibrate','approach','push','grasp','release','done','blocked'):
        raise ValueError('模型动作不在允许列表中')
    if isinstance(d.get('confidence'),bool) or not isinstance(d.get('confidence'), (int,float)) or not math.isfinite(d['confidence']) or not 0 <= d['confidence'] <= 1:
        raise ValueError('模型置信度无效')
    for key in ('tip','target','goal_tip'):
        point = d.get(key)
        if point is not None and (not isinstance(point,list) or len(point)!=2 or
            any(isinstance(v,bool) or not isinstance(v,(int,float)) or not math.isfinite(v) for v in point) or
            not (0<=point[0]<width and 0<=point[1]<height)):
            raise ValueError('模型像素坐标无效：'+key)
    for key in ('reason','target_label','completion_evidence'):
        if not isinstance(d.get(key),str) or len(d[key])>500:
            raise ValueError('模型字段无效：'+key)
    if not isinstance(d.get('contact_ready'),bool):
        raise ValueError('模型 contact_ready 字段无效')
    if d.get('step') is not None:
        from motion import MAX_STEP, vector
        step = d['step']
        if not isinstance(step,dict) or set(step)!={'joint','delta_rad'} or type(step['joint']) is not int or not 1<=step['joint']<=5:
            raise ValueError('模型短步格式无效')
        vector([step['delta_rad']],1)
        if not .003<=abs(step['delta_rad'])<=MAX_STEP:
            raise ValueError('模型短步超限')