import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.119.1?bundle';
const SUPABASE_URL='https://fzcricigqqpzcujrenkf.supabase.co';
const SUPABASE_PUBLISHABLE_KEY='sb_publishable_uy1xJ_55eYnmne1K8UrBQg_lV3LEyae';
const supabase=createClient(SUPABASE_URL,SUPABASE_PUBLISHABLE_KEY,{auth:{experimental:{passkey:true}}});
const $=id=>document.getElementById(id);
const setStatus=(id,msg,error=false)=>{$(id).textContent=msg;$(id).classList.toggle('error',error)};
const esc=value=>String(value??'').replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
const date=value=>value?new Date(value).toLocaleString('it-IT'):'—';
let currentUser=null;
let mfaFactorId=null;
let mfaMode=null;

async function audit(action,objectType,objectId,details={}){
 const {error}=await supabase.from('brain_audit_log').insert({actor_user_id:currentUser.id,actor_type:'founder',action,object_type:objectType,object_id:objectId?String(objectId):null,outcome:'recorded',details});
 if(error){console.error('Audit log non scritto:',error.message);return false}
 return true;
}
function showMfa(mode,factorId,qrCode='',secret=''){
 mfaMode=mode;mfaFactorId=factorId;
 $('login').classList.add('hidden');$('app').classList.add('hidden');$('mfa').classList.remove('hidden');$('signout').classList.remove('hidden');
 $('mfaEnroll').classList.toggle('hidden',mode!=='enroll');
 $('mfaChallenge').classList.toggle('hidden',mode!=='challenge');
 $('mfaQr').src=qrCode||'';
 $('mfaSecret').textContent=secret||'';
 $('mfaCode').value='';
 setStatus('mfaStatus',mode==='enroll'?'Scansiona il QR, aggiungi CASHUP BRAIN all’app autenticatrice e poi inserisci il codice a 6 cifre.':'Inserisci il codice a 6 cifre generato dalla tua app autenticatrice.');
}
async function requireMfa(){
 const {data:aal,error:aalError}=await supabase.auth.mfa.getAuthenticatorAssuranceLevel();
 if(aalError){setStatus('loginStatus','Controllo MFA non riuscito: '+aalError.message,true);return false}
 if(aal?.currentLevel==='aal2')return true;
 const {data:factors,error:factorsError}=await supabase.auth.mfa.listFactors();
 if(factorsError){setStatus('loginStatus','Lettura dei fattori MFA non riuscita: '+factorsError.message,true);return false}
 const verified=(factors?.totp||[]).filter(x=>x.status==='verified');
 if(verified.length){
  showMfa('challenge',verified[0].id);
  return false;
 }
 const pending=(factors?.all||[]).filter(x=>x.factor_type==='totp'&&x.status==='unverified');
 for(const factor of pending){
  const {error}=await supabase.auth.mfa.unenroll({factorId:factor.id});
  if(error){setStatus('loginStatus','Non è stato possibile riprendere la configurazione MFA precedente: '+error.message,true);return false}
 }
 const {data:enrollment,error:enrollError}=await supabase.auth.mfa.enroll({factorType:'totp',friendlyName:'CASHUP BRAIN Founder'});
 if(enrollError){setStatus('loginStatus','Configurazione MFA non riuscita: '+enrollError.message,true);return false}
 showMfa('enroll',enrollment.id,enrollment.totp?.qr_code||'',enrollment.totp?.secret||'');
 return false;
}
async function loadPasskeys(){
 try{
  const {data,error}=await supabase.auth.passkey.list();
  if(error){$('passkeyList').textContent='Passkey non disponibili: '+error.message;return}
  $('passkeyList').innerHTML=data?.length?data.map(p=>'<div class="item"><div class="row"><span>'+esc(p.friendly_name||'Passkey')+' · '+date(p.created_at)+'</span><button class="danger" data-passkey-delete="'+esc(p.id)+'">Rimuovi</button></div></div>').join(''):'Nessuna passkey registrata per questo account.';
 }catch(e){$('passkeyList').textContent='Funzione passkey non attiva o non supportata: '+(e?.message||'errore non specificato')}
}
async function showApp(user){
 currentUser=user;
 const {data:founder,error}=await supabase.from('brain_founders').select('user_id,active').eq('user_id',user.id).eq('active',true).maybeSingle();
 if(error||!founder){setStatus('loginStatus',error?'Verifica accesso non riuscita: '+error.message:'Questo account non risulta autorizzato come fondatore.',true);await supabase.auth.signOut();return}
 const mfaReady=await requireMfa();
 if(!mfaReady)return;
 $('login').classList.add('hidden');$('mfa').classList.add('hidden');$('app').classList.remove('hidden');$('signout').classList.remove('hidden');
 $('welcome').textContent='Accesso fondatore verificato con MFA · '+(user.email||'account fondatore');
 await loadDashboard();
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
 $('safetySettings').innerHTML=safetyItems.map(([label,value])=>'<div class="metric">'+esc(label)+'<strong class="small-value">'+esc(value)+'</strong></div>').join('');
 $('tasksList').innerHTML=tasks.data.length?tasks.data.map(x=>'<div class="item"><div class="row"><strong>'+esc(x.title)+'</strong><span class="pill">'+esc(x.status)+'</span></div><small class="muted">Priorità: '+esc(x.priority)+' · '+date(x.created_at)+'</small><p class="muted">'+esc(x.description)+'</p></div>').join(''):'<div class="empty">Nessuna attività ancora. Puoi crearne una qui sopra.</div>';
 $('agentsList').innerHTML=agents.data.length?agents.data.map(x=>'<div class="item"><div class="row"><strong>'+esc(x.display_name)+'</strong><span class="pill">'+esc(x.status)+'</span></div><p class="muted">'+esc(x.description)+'<br>Permessi: '+esc(x.permission_level)+'</p></div>').join(''):'<div class="empty">Nessun agente configurato. Gli agenti verranno aggiunti e testati uno alla volta.</div>';
 $('approvalsList').innerHTML=approvals.data.length?approvals.data.map(x=>'<div class="item"><div class="row"><strong>'+esc(x.action_type)+'</strong><span class="pill">'+esc(x.status)+'</span></div><p class="muted">'+esc(x.description)+'<br>Rischio: '+esc(x.risk_level)+' · '+date(x.created_at)+'</p>'+(x.status==='pending'?'<div class="actions"><button class="secondary" data-approval="'+x.id+'" data-decision="approved">Approva richiesta</button><button class="danger" data-approval="'+x.id+'" data-decision="rejected">Rifiuta</button></div>':'')+'</div>').join(''):'<div class="empty">Nessuna approvazione in attesa.</div>';
 $('auditList').innerHTML=auditRows.data.length?auditRows.data.map(x=>'<div class="item"><strong>'+esc(x.action)+'</strong><p class="muted">'+esc(x.object_type)+' · '+esc(x.outcome)+' · '+date(x.created_at)+'</p></div>').join(''):'<div class="empty">Il registro è vuoto.</div>';
 setStatus('appStatus','Dati caricati. Le protezioni del database sono attive.');
}
$('passkeyLogin').addEventListener('click',async()=>{
 $('passkeyLogin').disabled=true;setStatus('loginStatus','Attendi la verifica del dispositivo…');
 try{const {data,error}=await supabase.auth.signInWithPasskey();if(error){setStatus('loginStatus','Accesso con passkey non riuscito: '+error.message,true);return}await showApp(data.user)}catch(e){setStatus('loginStatus','Passkey non disponibile: '+(e?.message||'errore'),true)}finally{$('passkeyLogin').disabled=false}
});
$('loginBtn').addEventListener('click',async()=>{
 const email=$('email').value.trim(),password=$('password').value;
 if(!email||!password){setStatus('loginStatus','Inserisci email e password.',true);return}
 $('loginBtn').disabled=true;setStatus('loginStatus','Accesso in corso…');
 const {data,error}=await supabase.auth.signInWithPassword({email,password});
 $('loginBtn').disabled=false;
 if(error){setStatus('loginStatus','Accesso non riuscito: '+error.message,true);return}
 await showApp(data.user);
});
$('mfaVerify').addEventListener('click',async()=>{
 const code=$('mfaCode').value.trim();
 if(!/^\d{6}$/.test(code)){setStatus('mfaStatus','Inserisci il codice a 6 cifre.',true);return}
 if(!mfaFactorId){setStatus('mfaStatus','Fattore MFA non disponibile. Esci e ripeti l’accesso.',true);return}
 $('mfaVerify').disabled=true;setStatus('mfaStatus','Verifica del codice in corso…');
 const {data:challenge,error:challengeError}=await supabase.auth.mfa.challenge({factorId:mfaFactorId});
 if(challengeError){$('mfaVerify').disabled=false;setStatus('mfaStatus','Richiesta del codice non riuscita: '+challengeError.message,true);return}
 const {error:verifyError}=await supabase.auth.mfa.verify({factorId:mfaFactorId,challengeId:challenge.id,code});
 $('mfaVerify').disabled=false;
 if(verifyError){setStatus('mfaStatus','Codice non valido o scaduto. Riprova: '+verifyError.message,true);return}
 $('mfaQr').removeAttribute('src');$('mfaSecret').textContent='';$('mfaCode').value='';
 const {data:aal,error:aalError}=await supabase.auth.mfa.getAuthenticatorAssuranceLevel();
 if(aalError||aal?.currentLevel!=='aal2'){setStatus('mfaStatus','Il secondo fattore non risulta verificato. Riprova.',true);return}
 await showApp(currentUser);
});
$('registerPasskey').addEventListener('click',async()=>{
 const {data:aal,error:aalError}=await supabase.auth.mfa.getAuthenticatorAssuranceLevel();
 if(aalError||aal?.currentLevel!=='aal2'){setStatus('passkeyStatus','Prima completa la verifica MFA (AAL2).',true);return}
 $('registerPasskey').disabled=true;setStatus('passkeyStatus','Segui la richiesta di sicurezza del telefono per registrare la passkey…');
 try{const {data,error}=await supabase.auth.registerPasskey();if(error){setStatus('passkeyStatus','Registrazione non riuscita: '+error.message,true)}else{setStatus('passkeyStatus','Passkey registrata. Il telefono potrà richiedere impronta, volto o PIN.');await loadPasskeys();await audit('passkey_registered','auth_passkey',data?.id||null,{})}}catch(e){setStatus('passkeyStatus','Funzione passkey non disponibile: '+(e?.message||'errore'),true)}finally{$('registerPasskey').disabled=false}
});
$('passkeyList').addEventListener('click',async event=>{
 const button=event.target.closest('button[data-passkey-delete]');if(!button)return;
 if(!confirm('Rimuovere questa passkey? Dovrai usare un altro metodo per accedere.'))return;
 button.disabled=true;const id=button.dataset.passkeyDelete;
 const {error}=await supabase.auth.passkey.delete({passkeyId:id});
 if(error){button.disabled=false;setStatus('passkeyStatus','Rimozione non riuscita: '+error.message,true);return}
 await audit('passkey_removed','auth_passkey',id,{});await loadPasskeys();setStatus('passkeyStatus','Passkey rimossa.');
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
