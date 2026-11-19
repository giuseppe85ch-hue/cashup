-- CASHUP BRAIN — catalogo esteso di agenti specialistici
-- Tutti gli agenti restano planned: questa migrazione NON avvia runtime, spese o automazioni.
begin;
insert into public.brain_agents (agent_key,display_name,description,status,permission_level)
values
('product_strategy','Strategia e direzione prodotto','Analizza obiettivi, priorità, roadmap e dipendenze; prepara decisioni motivate.','planned','read_only'),
('product_management','Gestione prodotto e requisiti','Traduce idee in requisiti, attività, criteri di accettazione e piani di rilascio.','planned','read_only'),
('product_engineering','Tecnologia e sviluppo prodotto','Analizza architettura, codice, integrazioni, debito tecnico e soluzioni implementabili.','planned','read_only'),
('qa_release','Qualità e collaudo','Prepara test, controlli di regressione, checklist di rilascio e verifica risultati.','planned','read_only'),
('security','Sicurezza applicativa','Controlla permessi, vulnerabilità, configurazioni, segreti, dipendenze e posture di sicurezza.','planned','read_only'),
('fraud_detection','Antifrode e anomalie','Individua pattern sospetti su account, passi, punti, referral, transazioni e campagne; propone misure proporzionate.','planned','approval_required'),
('anti_piracy','Anti-pirateria e licenze','Progetta e verifica entitlement server-side, firme, integrità dei pacchetti, limiti e rilevamento di bypass.','planned','approval_required'),
('trust_safety','Fiducia, abusi e ricorsi','Gestisce triage di abusi, impersonificazione, molestie, segnalazioni, sospensioni e ricorsi con revisione umana.','planned','approval_required'),
('privacy_data','Privacy e governance dati','Controlla minimizzazione, accessi, conservazione, esportazione e cancellazione dei dati.','planned','read_only'),
('legal_compliance','Conformità e monitoraggio legale','Raccoglie requisiti e scadenze normative; prepara quesiti e documenti da sottoporre a professionisti.','planned','read_only'),
('ip_brand','Marchio e proprietà intellettuale','Organizza prove di titolarità, licenze, marchi, copyright, asset e segnalazioni di contraffazione.','planned','approval_required'),
('finance','Finanza e controllo economico','Analizza budget, margini, flussi e scenari; non dispone pagamenti né fondi.','planned','approval_required'),
('cost_optimizer','Ottimizzazione costi','Monitora costi infrastrutturali e propone alternative a costo minimo; nessun acquisto autonomo.','planned','approval_required'),
('growth','Crescita e acquisizione','Studia canali, conversioni, retention e crescita sostenibile.','planned','approval_required'),
('partnerships','Partnership e sponsor','Ricerca partner, prepara proposte e monitora condizioni e scadenze contrattuali.','planned','approval_required'),
('affiliate_ops','Affiliazioni e negozi','Gestisce catalogo partner, feed, tracking, commissioni e riconciliazione delle offerte.','planned','approval_required'),
('ads_monetization','Pubblicità e monetizzazione','Analizza campagne, formati pubblicitari, ricavi e rispetto delle regole delle piattaforme.','planned','approval_required'),
('marketing_content','Marketing e contenuti','Prepara campagne, comunicazioni, contenuti e calendario editoriale con revisione prima della pubblicazione.','planned','approval_required'),
('customer_support','Assistenza clienti','Classifica richieste, prepara risposte e individua problemi ricorrenti; non modifica account o rimborsi.','planned','approval_required'),
('community_moderation','Community e moderazione','Rileva spam, impersonificazione, truffe e contenuti abusivi; propone misure e conserva evidenze.','planned','approval_required'),
('international','Espansione internazionale','Analizza mercati, lingue, localizzazione, pagamenti e vincoli territoriali.','planned','read_only'),
('analytics','Dati e indicatori','Costruisce metriche, analisi, previsioni e report con provenienza dei dati.','planned','read_only'),
('game_economy','Giochi ed economia virtuale','Analizza bilanciamento, pacchetti, progressione e sostenibilità; nessun vantaggio pay-to-win nelle competizioni premio.','planned','approval_required'),
('rewards_loyalty','Premi, punti e fidelizzazione','Progetta regole anti-abuso, limiti, premi e programmi fedeltà; non accredita punti direttamente.','planned','approval_required'),
('payments_reconciliation','Pagamenti e riconciliazione','Verifica eventi di pagamento, rimborsi e discrepanze; nessun trasferimento autonomo.','planned','approval_required'),
('operations','Operazioni e coordinamento','Trasforma obiettivi in piani, procedure, responsabilità e controlli di completamento.','planned','read_only'),
('infrastructure_devops','Infrastruttura e continuità','Monitora hosting, deploy, backup, disponibilità, dipendenze e procedure di ripristino.','planned','approval_required'),
('incident_response','Risposta agli incidenti','Coordina contenimento, raccolta evidenze, comunicazioni e ripristino; azioni irreversibili solo con approvazione.','planned','approval_required'),
('data_governance','Qualità e governance dei dati','Controlla coerenza, duplicati, provenienza, retention e integrità dei registri.','planned','read_only'),
('research_intelligence','Ricerca e intelligence','Raccoglie fonti, confronta concorrenti e produce analisi con citazioni e livello di affidabilità.','planned','read_only'),
('procurement_vendor','Fornitori e acquisti','Confronta fornitori, licenze, costi e condizioni; non può ordinare o sottoscrivere.','planned','approval_required'),
('founder_assistant','Assistente personale del fondatore','Prepara briefing, riepiloghi, priorità, promemoria e prossime azioni in linguaggio semplice.','planned','read_only')
on conflict (agent_key) do nothing;
commit;
