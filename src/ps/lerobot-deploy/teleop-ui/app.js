'use strict';
const $ = id => document.getElementById(id);
let token = new URLSearchParams(location.hash.slice(1)).get('token') || sessionStorage.getItem('so101-token') || '';
if (location.hash) history.replaceState(null, '', location.pathname);
if (token) sessionStorage.setItem('so101-token', token);
let pending = false, refreshing = false, state = null;
const joints = {shoulder_pan:'肩部旋转',shoulder_lift:'肩部抬升',elbow_flex:'肘部屈伸',wrist_flex:'腕部俯仰',wrist_roll:'腕部旋转',gripper:'夹爪'};
for (const [key, name] of Object.entries(joints)) {
  const row = document.createElement('tr');
  const label = document.createElement('td'); label.textContent = name; row.append(label);
  for (const kind of ['present','goal','diff']) { const cell=document.createElement('td');cell.id=key+'-'+kind;cell.textContent='—';row.append(cell); }
  $('joints').append(row);
}
function message(text, error=false) { $('message').textContent=text;$('message').className=error?'error':''; }
async function api(path, data) {
  const controller=new AbortController(), timer=setTimeout(()=>controller.abort(),60000);
  try {
    const response = await fetch(path, {method:data?'POST':'GET', headers:{Authorization:'Bearer '+token,'Content-Type':'application/json'},body:data?JSON.stringify(data):undefined,signal:controller.signal});
    const result=await response.json();
    if(response.status===401){$('login').hidden=false;throw new Error(result.error);}
    if(!response.ok)throw new Error(result.error||'服务异常');
    return result;
  } finally { clearTimeout(timer); }
}
function badge(id,text,cls){$(id).textContent=text;$(id).className='pill '+cls;}
function card(prefix,data){
  badge(prefix+'-badge',!data.reachable?'不可达':data.running?'运行中':'已停止',data.running?'on':!data.reachable?'off':'');
  $(prefix+'-detail').textContent=data.error||(data.running?((data.mode==='hardware'?'实机模式':'模拟模式')+' · '+data.phase):'就绪，等待启动');
  $(prefix+'-device').textContent='串口设备：'+(data.serial_present?'已找到':'未找到或状态未知');
  $(prefix+'-log').textContent=data.log||'尚无日志';
}
function render(s){
  state=s;const local=s.role==='local';$('board-card').hidden=!local;$('board-log-card').hidden=!local;
  $('local-title').textContent=local?'本机 · 主臂':'KV260 · 从臂';$('log-local-title').textContent=local?'本机日志':'从臂日志';
  $('subtitle').textContent=local?'本机主臂 → 局域网 → KV260 从臂':'KV260 从臂接收端管理';
  $('start').textContent=local?'启动实机遥操作':'启动实机接收端';
  $('control-hint').textContent=local?'实机启动后，从臂会逐步跟随主臂当前位置。':'接收端启动后等待本机发送端，单独启动接收端不会开始跟随。';
  card('local',s.self);if(local)card('board',s.board);
  const connected=s.self.reachable&&(!local||s.board.reachable);
  badge('connection',connected?'控制服务已连接':'部分服务不可达',connected?'on':'off');
  const ready=connected&&!pending&&!s.busy;
  $('start').disabled=!ready||s.self.running||(local&&s.board.running&&s.board.mode!=='hardware');
  $('simulate').disabled=!ready||s.self.running||(local&&s.board.running&&s.board.mode!=='dry-run');
  $('stop').disabled=pending||(!s.self.reachable&&(!local||!s.board.reachable));
  const board=local?s.board:s.self;const sample=board.sample;
  const old=!board.running||board.log_age===null||board.log_age>12;
  $('sample-age').textContent=sample?((old?'历史数据 · ':'')+'日志更新于 '+Math.round(board.log_age||0)+' 秒前'):'尚无反馈';
  for(const key of Object.keys(joints)){
    const p=sample?.present?.[key],g=sample?.goal?.[key];
    $(key+'-present').textContent=Number.isFinite(p)?p.toFixed(2):'—';
    $(key+'-goal').textContent=Number.isFinite(g)?g.toFixed(2):'—';
    $(key+'-diff').textContent=Number.isFinite(p)&&Number.isFinite(g)?(g-p).toFixed(2):'—';
  }
  $('applied').textContent=sample?.applied??'—';$('latency').textContent=sample?sample.round_trip_ms+' ms':'—';
  $('updated').textContent='最近查询 '+new Date().toLocaleTimeString();$('login').hidden=true;
}
async function refresh(){
  if(refreshing||!token){if(!token)$('login').hidden=false;return;}
  refreshing=true;
  try{render(await api('/api/status'));if(!pending&&$('message').textContent==='等待状态同步…')message(state.self.running?'已接入当前运行会话。页面刷新不会中断遥操作。':'服务已就绪，选择实机遥操作或模拟联调。');}
  catch(e){badge('connection','连接失败','off');message(e.message,true);$('start').disabled=true;$('simulate').disabled=true;}
  finally{refreshing=false;}
}
async function action(action,mode){
  if(pending)return;
  pending=true;for(const id of ['start','simulate','stop'])$(id).disabled=true;
  message(action==='stop'?'正在停止两端进程…':'正在启动，请等待状态更新…');
  try{const result=await api('/api/action',{action,...(mode?{mode}: {})});message(result.message);}
  catch(e){message(e.message,true);}
  finally{pending=false;await refresh();}
}
$('start').onclick=()=>action('start','hardware');$('simulate').onclick=()=>action('start','dry-run');$('stop').onclick=()=>action('stop');$('refresh').onclick=refresh;
$('login-form').onsubmit=e=>{e.preventDefault();token=$('token').value.trim();sessionStorage.setItem('so101-token',token);$('token').value='';refresh();};
refresh();setInterval(refresh,2000);