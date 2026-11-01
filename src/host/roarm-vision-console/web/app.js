'use strict';
const $ = id => document.getElementById(id);
let token = '', initialized = false;
const phases = {idle:'待命',observing:'观察中',planning:'模型决策中',moving:'实机运动中',review_required:'完成证据待核验',budget_exhausted:'本轮预算用尽',reading_feedback:'读取反馈',blocked:'观察结束',stopped:'已停止',error:'异常'};
async function post(path, body = {}) {
  const response = await fetch('/api/' + path, {method:'POST',headers:{'Content-Type':'application/json','X-Console-Token':token},body:JSON.stringify(body)});
  const data = await response.json();
  if (!response.ok) throw new Error(data.error || '请求失败');
  return data;
}
async function action(path) {
  try { await post(path, {task:$('task').value}); $('error').textContent=''; }
  catch (error) { $('error').textContent=error.message; }
}
for (const id of ['servo','observe','watch','feedback','stop']) $(id).addEventListener('click',() => action(id));
$('config').addEventListener('submit', async event => {
  event.preventDefault();
  const api_key = $('key').value; $('key').value='';
  try {await post('config',{base_url:$('base').value,model:$('model').value,mode:$('mode').value,api_key});$('error').textContent='';}
  catch (error) {$('error').textContent=error.message;}
});
function render(state) {
  const vision = state.vision;
  $('connection').textContent = vision.connected ? '实时连接' : '无新鲜图像';
  $('freshness').textContent = vision.stamp ? `帧龄 ${vision.age_s} 秒 · 深度同步差 ${vision.depth_sync_ms} 毫秒 · 已收 ${vision.frames} 帧` : vision.error;
  $('camera').style.opacity = vision.connected ? '1' : '.35';
  $('phase').textContent=phases[state.phase] || state.phase;
  $('motion').textContent=state.motion_block;
  if(state.error) $('error').textContent=state.error;
  $('model-status').textContent=`${state.model.model} · Medium · ${state.model.key_configured?'密钥已配置（仅内存）':'尚未配置密钥'}`;
  if(!initialized){$('base').value=state.model.base_url;$('model').value=state.model.model;$('mode').value=state.model.mode;$('task').value=state.task;initialized=true;}
  for(const id of ['servo','observe','watch']) $(id).disabled=state.busy || !vision.connected || !state.model.key_configured;
  $('feedback').disabled=state.busy;
  $('config').querySelector('button').disabled=state.busy;
  $('detections').replaceChildren();
  for(const d of vision.detections?.detections || []) {
    const span=document.createElement('span');span.className='tag';
    span.textContent=`${d.class_name} ${(d.confidence*100).toFixed(0)}% · ${d.depth_valid ? d.depth_m.toFixed(2)+'m（未配准）':'无有效深度'}`;
    $('detections').append(span);
  }
  if(state.result){
    const r=state.result,d=r.decision;
    $('reason').textContent=d.reason;
    $('decision').replaceChildren();
    for(const [name,value] of [['建议阶段',d.action],['夹爪像素',JSON.stringify(d.tip)],['目标像素',JSON.stringify(d.target)],['相对误差',d.tip&&d.goal_tip?d.goal_tip.map((v,i)=>Math.round(v-d.tip[i]))+' px':'尚未确定'],['置信度',d.confidence],['模型耗时',r.latency_s+' 秒'],['图像时刻',new Date(r.observed_stamp*1000).toLocaleTimeString()],['完成证据',d.completion_evidence || '无']]){
      const dt=document.createElement('dt'),dd=document.createElement('dd');dt.textContent=name;dd.textContent=value;$('decision').append(dt,dd);
    }
  }
  if(state.feedback){$('feedback-age').textContent=`串口编码器 · ${state.feedback_age_s} 秒前`; $('feedback-data').textContent=JSON.stringify(state.feedback.feedback,null,2);}
  $('events').replaceChildren();
  for(const event of state.events.slice().reverse()){const li=document.createElement('li');li.textContent=`${event.time} ${event.text}`;$('events').append(li);}
}
async function poll(){
  try {const response=await fetch('/api/status');if(!response.ok)throw new Error('状态读取失败');render(await response.json());}
  catch(error){$('connection').textContent='上位机连接中断';$('camera').style.opacity='.35';for(const id of ['servo','observe','watch','feedback'])$(id).disabled=true;}
  setTimeout(poll,700);
}
function images(){
  for(const id of ['camera','depth']){
    const image=$(id),url=id==='camera'?'/image.jpg':'/depth.png';
    const update=()=>{image.src=url+'?t='+Date.now();};
    image.onload=()=>setTimeout(update,id==='camera'?250:1000);
    image.onerror=()=>setTimeout(update,2000);update();
  }
}
fetch('/api/session').then(r=>r.json()).then(data=>{token=data.token;poll();images();}).catch(()=>{$('error').textContent='无法连接本机服务，请刷新页面';});