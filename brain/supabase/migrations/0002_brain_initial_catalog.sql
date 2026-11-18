-- CASHUP BRAIN — catalogo iniziale non operativo
-- Inserisce soltanto schede descrittive: nessun agente viene avviato.
-- Eseguire manualmente solo dopo aver verificato il progetto Supabase corretto.

begin;

insert into public.brain_agents
  (agent_key, display_name, description, status, permission_level)
values
  ('orchestrator', 'BRAIN Orchestrator', 'Coordina le richieste, suddivide il lavoro e prepara piani; nessuna esecuzione autonoma in questa fase.', 'planned', 'read_only'),
  ('engineering', 'Technology & Engineering', 'Analisi tecnica, manutenzione del codice, test e documentazione.', 'planned', 'read_only'),
  ('security', 'Security & Privacy', 'Controlli di sicurezza, permessi minimi, audit e revisione delle modifiche.', 'planned', 'read_only'),
  ('finance', 'Finance & Cost Control', 'Analisi dei costi, budget e report; ogni operazione finanziaria richiede approvazione umana.', 'planned', 'approval_required'),
  ('growth', 'Growth & Partnerships', 'Ricerca opportunità, campagne e partnership; nessun contatto o accordo viene inviato senza approvazione.', 'planned', 'approval_required'),
  ('support', 'Customer Support', 'Preparazione di risposte e analisi delle richieste; nessuna comunicazione esterna automatica.', 'planned', 'approval_required'),
  ('operations', 'Operations', 'Procedure, checklist, monitoraggio e coordinamento operativo.', 'planned', 'read_only'),
  ('compliance', 'Legal & Compliance Monitor', 'Individua temi da sottoporre a professionisti; non fornisce pareri legali né assume decisioni.', 'planned', 'read_only')
on conflict (agent_key) do update set
  display_name = excluded.display_name,
  description = excluded.description,
  permission_level = excluded.permission_level,
  status = 'planned';

insert into public.brain_settings (setting_key, setting_value, description)
values
  ('autonomy_enabled', 'false'::jsonb, 'Interruttore generale: autonomia disattivata nella fase iniziale.'),
  ('require_human_approval_for_high_risk', 'true'::jsonb, 'Le azioni ad alto rischio richiedono approvazione umana.'),
  ('require_human_approval_for_financial_actions', 'true'::jsonb, 'Pagamenti, trasferimenti e rimborsi richiedono approvazione umana.'),
  ('max_automated_spend_eur', '0'::jsonb, 'Limite di spesa automatizzata iniziale in euro.'),
  ('emergency_stop', 'true'::jsonb, 'Arresto di emergenza attivo finché i test non sono completati.')
on conflict (setting_key) do nothing;

commit;
