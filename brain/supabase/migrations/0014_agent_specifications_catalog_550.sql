-- CASHUP BRAIN — catalogo 550 specialisti con specifiche verificabili.
-- La migrazione definisce ruoli e policy: NON installa runtime, provider, segreti o automazioni.
begin;
create table if not exists private.brain_agent_specs (
 agent_key text primary key references public.brain_agents(agent_key) on delete cascade,
 department text not null,
 mission text not null check (char_length(mission) between 30 and 2000),
 boundaries text not null check (char_length(boundaries) between 30 and 2000),
 acceptance_test text not null check (char_length(acceptance_test) between 30 and 2000),
 input_contract jsonb not null,
 output_contract jsonb not null,
 allowed_tools jsonb not null default '[]'::jsonb check (jsonb_typeof(allowed_tools)='array'),
 max_spend_eur numeric(12,2) not null default 0 check (max_spend_eur=0),
 lifecycle_state text not null default 'designed' check (lifecycle_state in ('designed','validated','staged','operational','retired')),
 model_provider text,
 model_id text,
 version integer not null default 1 check (version>0),
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now()
);
alter table private.brain_agent_specs enable row level security;
alter table private.brain_agent_specs force row level security;
revoke all on table private.brain_agent_specs from public, anon, authenticated, service_role;

with sectors(ord,department,department_label,slug,scope) as (
 values (1,'governance','Governance','governance','Supervisione della governance CASHUP, dei controlli interni e delle decisioni del fondatore'),
(2,'strategy','Strategia','strategy','Analisi strategica di CASHUP, priorità, scenari e obiettivi misurabili'),
(3,'product','Prodotto','product','Definizione e verifica dei requisiti, dell''esperienza e del ciclo di vita del prodotto'),
(4,'engineering','Ingegneria software','engineering','Progettazione, revisione e manutenzione del software CASHUP'),
(5,'security','Sicurezza informatica','security','Prevenzione, rilevamento e risposta alle minacce informatiche'),
(6,'data','Dati e analytics','data','Qualità, modellazione, analisi e governance dei dati'),
(7,'ai_research','Ricerca AI','ai_research','Valutazione di modelli, agenti, prompt e tecniche AI con controlli di sicurezza'),
(8,'devops','Infrastruttura e DevOps','devops','Affidabilità, deployment, osservabilità e continuità dei servizi'),
(9,'quality','Qualità e testing','quality','Verifica funzionale, accessibilità, regressioni e qualità dei rilasci'),
(10,'finance','Finanza e controllo','finance','Previsioni, controllo di gestione, sostenibilità e riconciliazione economica'),
(11,'growth','Crescita','growth','Acquisizione, attivazione, fidelizzazione e crescita sostenibile degli utenti'),
(12,'marketing','Marketing e comunicazione','marketing','Strategia editoriale, creatività, campagne e misurazione marketing'),
(13,'affiliate','Affiliazioni','affiliate','Ricerca, integrazione e controllo di negozi, feed, link e commissioni affiliate'),
(14,'partnerships','Partnership e sponsor','partnerships','Ricerca e gestione di partnership commerciali e sponsorizzazioni'),
(15,'advertising','Advertising','advertising','Pianificazione e controllo dei formati pubblicitari e della qualità degli annunci'),
(16,'rewards','Premi e loyalty','rewards','Sostenibilità, regole, catalogo e integrità dei punti e dei premi'),
(17,'games','Gaming','games','Progettazione, bilanciamento e gestione dei giochi CASHUP'),
(18,'support','Assistenza utenti','support','Qualità del supporto, risoluzione problemi e documentazione utenti'),
(19,'trust','Trust & Safety','trust','Prevenzione abusi, antifrode, moderazione e tutela degli utenti'),
(20,'international','Espansione internazionale','international','Localizzazione e valutazione operativa dei mercati internazionali')
), tasks(ord,task_key,task_label,task_mission) as (
 values (1,'requirements','Analisi requisiti','raccoglie requisiti verificabili e criteri di accettazione'),
(2,'roadmap','Pianificazione roadmap','ordina iniziative per valore, rischio, dipendenze e fattibilità'),
(3,'risk_register','Registro rischi','identifica rischi, probabilità, impatto e mitigazioni'),
(4,'benchmark','Benchmark comparativo','confronta alternative con criteri ripetibili e fonti tracciabili'),
(5,'quality_metrics','Metriche di qualità','definisce indicatori, soglie e modalità di misurazione'),
(6,'process_audit','Audit dei processi','verifica procedure, evidenze, controlli e scostamenti'),
(7,'documentation','Documentazione tecnica','produce documenti aggiornabili e coerenti con lo stato reale'),
(8,'incident_triage','Triage incidenti','classifica anomalie e propone priorità di intervento'),
(9,'privacy_review','Revisione privacy','controlla minimizzazione, finalità, accessi e conservazione'),
(10,'accessibility','Accessibilità','verifica fruibilità e barriere per diverse capacità e dispositivi'),
(11,'performance','Prestazioni','analizza tempi, carichi, colli di bottiglia e soglie'),
(12,'reliability','Affidabilità','valuta disponibilità, errori, resilienza e ripristino'),
(13,'cost_model','Modello dei costi','stima costi unitari, scenari e alternative gratuite'),
(14,'forecasting','Previsioni','costruisce previsioni con ipotesi, intervalli e limiti espliciti'),
(15,'fraud_signals','Indicatori antifrode','identifica segnali anomali senza automatizzare sanzioni'),
(16,'user_research','Ricerca utenti','sintetizza feedback, bisogni e problemi ricorrenti'),
(17,'experiment_design','Disegno esperimenti','definisce ipotesi, metriche, campioni e criteri di arresto'),
(18,'content_review','Revisione contenuti','controlla accuratezza, chiarezza, trasparenza e coerenza'),
(19,'integration_review','Revisione integrazioni','valuta API, permessi, dipendenze e gestione errori'),
(20,'data_validation','Validazione dati','controlla completezza, coerenza, duplicati e provenienza'),
(21,'security_review','Revisione sicurezza','esamina superfici d''attacco, privilegi e mitigazioni'),
(22,'release_readiness','Preparazione rilascio','verifica prerequisiti, rollback, test e approvazioni'),
(23,'vendor_assessment','Valutazione fornitori','confronta affidabilità, privacy, termini e costo totale'),
(24,'localization','Localizzazione','adatta lingua, valuta, formati e contesto regionale'),
(25,'retention_policy','Politiche di conservazione','propone tempi e procedure di conservazione e cancellazione'),
(26,'customer_journey','Percorso utente','mappa attriti, passaggi, conversione e abbandono')
), generated as (
 select row_number() over(order by s.ord,t.ord) as rn,
   s.department,s.department_label,s.slug,s.scope,t.task_key,t.task_label,t.task_mission
 from sectors s cross join tasks t
), selected as (
 select * from generated where rn<=515
)
insert into public.brain_agents(agent_key,display_name,description,status,permission_level)
select slug||'_'||task_key,department_label||' — '||task_label,
 task_mission||' nell’area '||lower(department_label)||' di CASHUP.','planned',
 case when department in ('finance','affiliate','partnerships','advertising','rewards','trust','growth','marketing')
   or task_key in ('fraud_signals','incident_triage','security_review','vendor_assessment','privacy_review')
 then 'approval_required' else 'read_only' end
from selected
on conflict(agent_key) do nothing;

insert into private.brain_agent_specs
(agent_key,department,mission,boundaries,acceptance_test,input_contract,output_contract,allowed_tools,max_spend_eur,lifecycle_state)
select a.agent_key,'core',
 coalesce(nullif(a.description,''),'Specialista CASHUP: '||a.display_name),
 'Nessuna spesa o azione esterna. Nessun accesso a segreti. Le azioni finanziarie, legali, irreversibili e ad alto rischio richiedono approvazione esplicita del fondatore.',
 'Verificare fonti, accuratezza, limiti, rischi, tracciabilità e rispetto dei permessi; nessuna esecuzione esterna.',
 '{"required":["objective","context","evidence"],"optional":["constraints","deadline"]}'::jsonb,
 '{"required":["summary","evidence","risks","recommendation","next_steps"]}'::jsonb,
 '[]'::jsonb,0,'designed'
from public.brain_agents a
on conflict(agent_key) do nothing;

with sectors(ord,department,department_label,slug,scope) as (
 values (1,'governance','Governance','governance','Supervisione della governance CASHUP, dei controlli interni e delle decisioni del fondatore'),
(2,'strategy','Strategia','strategy','Analisi strategica di CASHUP, priorità, scenari e obiettivi misurabili'),
(3,'product','Prodotto','product','Definizione e verifica dei requisiti, dell''esperienza e del ciclo di vita del prodotto'),
(4,'engineering','Ingegneria software','engineering','Progettazione, revisione e manutenzione del software CASHUP'),
(5,'security','Sicurezza informatica','security','Prevenzione, rilevamento e risposta alle minacce informatiche'),
(6,'data','Dati e analytics','data','Qualità, modellazione, analisi e governance dei dati'),
(7,'ai_research','Ricerca AI','ai_research','Valutazione di modelli, agenti, prompt e tecniche AI con controlli di sicurezza'),
(8,'devops','Infrastruttura e DevOps','devops','Affidabilità, deployment, osservabilità e continuità dei servizi'),
(9,'quality','Qualità e testing','quality','Verifica funzionale, accessibilità, regressioni e qualità dei rilasci'),
(10,'finance','Finanza e controllo','finance','Previsioni, controllo di gestione, sostenibilità e riconciliazione economica'),
(11,'growth','Crescita','growth','Acquisizione, attivazione, fidelizzazione e crescita sostenibile degli utenti'),
(12,'marketing','Marketing e comunicazione','marketing','Strategia editoriale, creatività, campagne e misurazione marketing'),
(13,'affiliate','Affiliazioni','affiliate','Ricerca, integrazione e controllo di negozi, feed, link e commissioni affiliate'),
(14,'partnerships','Partnership e sponsor','partnerships','Ricerca e gestione di partnership commerciali e sponsorizzazioni'),
(15,'advertising','Advertising','advertising','Pianificazione e controllo dei formati pubblicitari e della qualità degli annunci'),
(16,'rewards','Premi e loyalty','rewards','Sostenibilità, regole, catalogo e integrità dei punti e dei premi'),
(17,'games','Gaming','games','Progettazione, bilanciamento e gestione dei giochi CASHUP'),
(18,'support','Assistenza utenti','support','Qualità del supporto, risoluzione problemi e documentazione utenti'),
(19,'trust','Trust & Safety','trust','Prevenzione abusi, antifrode, moderazione e tutela degli utenti'),
(20,'international','Espansione internazionale','international','Localizzazione e valutazione operativa dei mercati internazionali')
), tasks(ord,task_key,task_label,task_mission) as (
 values (1,'requirements','Analisi requisiti','raccoglie requisiti verificabili e criteri di accettazione'),
(2,'roadmap','Pianificazione roadmap','ordina iniziative per valore, rischio, dipendenze e fattibilità'),
(3,'risk_register','Registro rischi','identifica rischi, probabilità, impatto e mitigazioni'),
(4,'benchmark','Benchmark comparativo','confronta alternative con criteri ripetibili e fonti tracciabili'),
(5,'quality_metrics','Metriche di qualità','definisce indicatori, soglie e modalità di misurazione'),
(6,'process_audit','Audit dei processi','verifica procedure, evidenze, controlli e scostamenti'),
(7,'documentation','Documentazione tecnica','produce documenti aggiornabili e coerenti con lo stato reale'),
(8,'incident_triage','Triage incidenti','classifica anomalie e propone priorità di intervento'),
(9,'privacy_review','Revisione privacy','controlla minimizzazione, finalità, accessi e conservazione'),
(10,'accessibility','Accessibilità','verifica fruibilità e barriere per diverse capacità e dispositivi'),
(11,'performance','Prestazioni','analizza tempi, carichi, colli di bottiglia e soglie'),
(12,'reliability','Affidabilità','valuta disponibilità, errori, resilienza e ripristino'),
(13,'cost_model','Modello dei costi','stima costi unitari, scenari e alternative gratuite'),
(14,'forecasting','Previsioni','costruisce previsioni con ipotesi, intervalli e limiti espliciti'),
(15,'fraud_signals','Indicatori antifrode','identifica segnali anomali senza automatizzare sanzioni'),
(16,'user_research','Ricerca utenti','sintetizza feedback, bisogni e problemi ricorrenti'),
(17,'experiment_design','Disegno esperimenti','definisce ipotesi, metriche, campioni e criteri di arresto'),
(18,'content_review','Revisione contenuti','controlla accuratezza, chiarezza, trasparenza e coerenza'),
(19,'integration_review','Revisione integrazioni','valuta API, permessi, dipendenze e gestione errori'),
(20,'data_validation','Validazione dati','controlla completezza, coerenza, duplicati e provenienza'),
(21,'security_review','Revisione sicurezza','esamina superfici d''attacco, privilegi e mitigazioni'),
(22,'release_readiness','Preparazione rilascio','verifica prerequisiti, rollback, test e approvazioni'),
(23,'vendor_assessment','Valutazione fornitori','confronta affidabilità, privacy, termini e costo totale'),
(24,'localization','Localizzazione','adatta lingua, valuta, formati e contesto regionale'),
(25,'retention_policy','Politiche di conservazione','propone tempi e procedure di conservazione e cancellazione'),
(26,'customer_journey','Percorso utente','mappa attriti, passaggi, conversione e abbandono')
 generated as (
 select row_number() over(order by s.ord,t.ord) as rn,
 s.department,s.department_label,s.slug,s.scope,t.task_key,t.task_label,t.task_mission
 from sectors s cross join tasks t
), selected as (
 select * from generated where rn<=515
)
insert into private.brain_agent_specs
(agent_key,department,mission,boundaries,acceptance_test,input_contract,output_contract,allowed_tools,max_spend_eur,lifecycle_state)
select slug||'_'||task_key,department,
 task_mission||' nell’area '||lower(department_label)||' di CASHUP. Ambito: '||scope||'. Produrre risultati documentati, con fonti, ipotesi e limiti; non eseguire azioni esterne.',
 'Solo analisi e bozze. Nessuna spesa, pubblicazione, contatto esterno, modifica dati di produzione, accesso a segreti o decisione irreversibile. Escalation al fondatore per rischio elevato o incertezza.',
 'Verificare che il risultato includa obiettivo, input e fonti, ipotesi, evidenze, rischi, raccomandazione motivata e criteri misurabili; rifiutare conclusioni senza evidenza e azioni non autorizzate.',
 '{"required":["objective","context","evidence"],"optional":["constraints","deadline"]}'::jsonb,
 '{"required":["summary","evidence","risks","recommendation","next_steps"]}'::jsonb,
 '[]'::jsonb,0,'designed'
from selected
on conflict(agent_key) do update set department=excluded.department,mission=excluded.mission,
 boundaries=excluded.boundaries,acceptance_test=excluded.acceptance_test,
 input_contract=excluded.input_contract,output_contract=excluded.output_contract,
 allowed_tools='[]'::jsonb,max_spend_eur=0,lifecycle_state='designed',updated_at=now();

drop policy if exists brain_agent_specs_deny_all on private.brain_agent_specs;
create policy brain_agent_specs_deny_all on private.brain_agent_specs
for all to anon, authenticated, service_role using(false) with check(false);
commit;
