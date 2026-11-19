import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';
const SUPABASE_URL='https://fzcricigqqpzcujrenkf.supabase.co';
const SUPABASE_PUBLISHABLE_KEY='sb_publishable_uy1xJ_55eYnmne1K8UrBQg_lV3LEyae';
const supabase=createClient(SUPABASE_URL,SUPABASE_PUBLISHABLE_KEY);
const $=id=>document.getElementById(id);
const setStatus=(id,msg,error=false)=>{$(id).textContent=msg;$(id).classList.toggle('error',error)};
const esc=value=>String(value??'').replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
const date=value=>value?new Date(value).toLocaleString('it-IT'):'—';
let currentUser=null;
async function audit(action,objectType,objectId,details={}){
 const {error}=await supabase.from('brain_audit_log').insert({actor_user_id:currentUser.id,actor_type:'founder',action,object_type:objectType,object_id:objectId?String(objectId):null,outcome:'recorded',details});
 if(error){console.error('Audit log non scritto:',error.message);return false}
 return true;
}
async function loadDashboard(){
 const [tasks,agents,approvals,auditRows,settings]=await Promise.all([
  supabase.from('brain_tasks').select('id,title,description,status,priority,sector,created_at').order('created_at',{ascending:false}).limit(12),
  supabase.from('brain_agents').select('id,display_name,description,status,permission_level').order('display_name'),
  supabase.from('brain_approvals').select('id,action_type,description,risk_level,status,created_at').order('created_at',{ascending:false}).limit(12),
  supabase.from('brain_audit_log').select('id,action,object_type,outcome,created_at').order('created_at',{ascending:false}).limit(10),
  supabase.from('brain_settings').select('setting_key,setting_value,description').order('setting_key')
 ]);
 const firstError=[tasks,agents,approvals,auditRows,settings].find(x=>x.error)?.error;
 if(firstError){setStatus('appStatus','Errore nel caricamento: '+firstError.message,true);return}
 $('tasksOpen').textContent=tasks.data.filter(x=>!['done','cancelled'].includes(x.status)).length;
 $('agentsCount').textContent=agents.data.length;
 $('approvalsCount').textContent=approvals.data.filter(x=>x.status==='pending').length;
 $('auditCount').textContent=auditRows.data.length;
 const settingMap=Object.fromEntries(settings.data.map(x=>[x.setting_key,x.setting_value]));
 const safetyItems=[['Autonomia',typeof settingMap.autonomy_enabled==='boolean'?(settingMap.autonomy_enabled?'ATTIVA':'DISATTIVATA'):'NON CONFERMATA'],['Arresto di emergenza',typeof settingMap.emergency_stop==='boolean'?(settingMap.emergency_stop?'ATTIVO':'NON ATTIVO'):'NON CONFERMATO'],['Spesa automatizzata',String(settingMap.max_automated_spend_eur??'—')+' €'],['Approvazione azioni finanziarie',settingMap.require_human_approval_for_financial_actions===true?'OBBLIGATORIA':'NON CONFERMATA'],['Approvazione alto rischio',settingMap.require_human_approval_for_high_risk===true?'OBBLIGATORIA':'NON CONFERMATA']];
 $('safetySettings').innerHTML=safetyItems.map(([label,value])=>'<div class="metric">'+esc(label)+'<strong style="font-size:17px">'+esc(value)+'</strong></div>').join('');
 $('tasksList').innerHTML=tasks.data.length?tasks.data.map(x=>'<div class="item"><div class="row"><strong>'+esc(x.title)+'</strong><span class="pill">'+esc(x.status)+'</span></div><small class="muted">Priorità: '+esc(x.priority)+' · '+date(x.created_at)+'</small><p class="muted">'+esc(x.description)+'</p></div>').join(''):'<div class="empty">Nessuna attività ancora. Puoi crearne una qui sopra.</div>';
 $('agentsList').innerHTML=agents.data.length?agents.data.map(x=>'<div class="item"><div class="row"><strong>'+esc(x.display_name)+'</strong><span class="pill">'+esc(x.status)+'</span></div><p class="muted">'+esc(x.description)+'<br>Permessi: '+esc(x.permission_level)+'</p></div>').join(''):'<div class="empty">Nessun agente configurato. Gli agenti verranno aggiunti e testati uno alla volta.</div>';
 $('approvalsList').innerHTML=approvals.data.length?approvals.data.map(x=>'<div class="item"><div class="row"><strong>'+esc(x.action_type)+'</strong><span class="pill">'+esc(x.status)+'</span></div><p class="muted">'+esc(x.description)+'<br>Rischio: '+esc(x.risk_level)+' · '+date(x.created_at)+'</p>'+(x.status==='pending'?'<div class="actions"><button class="secondary" data-approval="'+x.id+'" data-decision="approved">Approva richiesta</button><button class="danger" data-approval="'+x.id+'" data-decision="rejected">Rifiuta</button></div>':'')+'</div>').join(''):'<div class="empty">Nessuna approvazione in attesa.</div>';
 $('auditList').innerHTML=auditRows.data.length?auditRows.data.map(x=>'<div class="item"><strong>'+esc(x.action)+'</strong><p class="muted">'+esc(x.object_type)+' · '+esc(x.outcome)+' · '+date(x.created_at)+'</p></div>').join(''):'<div class="empty">Il registro è vuoto.</div>';
 setStatus('appStatus','Dati caricati. Le protezioni del database sono attive.');
}
async function showApp(user){
 currentUser=user;
 const {data:founder,error}=await supabase.from('brain_founders').select('user_id,active').eq('user_id',user.id).eq('active',true).maybeSingle();
 if(error||!founder){setStatus('loginStatus',error?'Verifica accesso non riuscita: '+error.message:'Questo account non risulta autorizzato come fondatore.',true);await supabase.auth.signOut();return}
 $('login').classList.add('hidden');$('app').classList.remove('hidden');$('signout').classList.remove('hidden');
 $('welcome').textContent='Accesso verificato · '+(user.email||'account fondatore');
 await loadDashboard();
}
$('loginBtn').addEventListener('click',async()=>{
 const email=$('email').value.trim(),password=$('password').value;
 if(!email||!password){setStatus('loginStatus','Inserisci email e password.',true);return}
 $('loginBtn').disabled=true;setStatus('loginStatus','Accesso in corso…');
 const {data,error}=await supabase.auth.signInWithPassword({email,password});
 $('loginBtn').disabled=false;
 if(error){setStatus('loginStatus','Accesso non riuscito: '+error.message,true);return}
 await showApp(data.user);
});
$('signout').addEventListener('click',async()=>{await supabase.auth.signOut();location.reload()});
$('addTask').addEventListener('click',async()=>{
 const title=$('taskTitle').value.trim();if(!title){$('taskStatus').textContent='Inserisci un titolo.';return}
 $('addTask').disabled=true;
 const {data,error}=await supabase.from('brain_tasks').insert({title,description:$('taskDesc').value.trim(),priority:$('taskPriority').value,sector:'core',created_by:currentUser.id}).select('id').single();
 $('addTask').disabled=false;
 if(error){$('taskStatus').textContent='Non è stato possibile creare l’attività: '+error.message;return}
 const logged=await audit('task_created','brain_task',data.id,{title});
 $('taskTitle').value='';$('taskDesc').value='';$('taskStatus').textContent=logged?'Attività creata e registrata.':'Attività creata, ma ATTENZIONE: registrazione audit non riuscita.';
 await loadDashboard();
});
$('approvalsList').addEventListener('click',async event=>{
 const button=event.target.closest('button[data-approval]');if(!button)return;
 const id=button.dataset.approval,decision=button.dataset.decision;
 if(!confirm((decision==='approved'?'Approvare':'Rifiutare')+' questa richiesta? La decisione non esegue l’azione.'))return;
 button.disabled=true;
 const {error}=await supabase.from('brain_approvals').update({status:decision,decided_by:currentUser.id,decided_at:new Date().toISOString()}).eq('id',id).eq('status','pending');
 if(error){button.disabled=false;setStatus('appStatus','Decisione non salvata: '+error.message,true);return}
 const logged=await audit('approval_'+decision,'brain_approval',id,{decision});
 if(!logged)setStatus('appStatus','Decisione salvata, ma ATTENZIONE: registrazione audit non riuscita.',true);
 await loadDashboard();
});
const {data:sessionData}=await supabase.auth.getSession();
if(sessionData.session?.user) await showApp(sessionData.session.user);
