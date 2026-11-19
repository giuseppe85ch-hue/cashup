# CASHUP BRAIN — piano di verifica con il fondatore

Questo piano è una checklist di collaudo. Non abilita agenti, non esegue automazioni e non modifica il database.

## Già riportato dall'utente
- [x] Migrazione iniziale 0001 eseguita in Supabase con esito Success.
- [x] Sette tabelle `brain_*` viste in Supabase.
- [x] Account fondatore inserito in `brain_founders`.
- [x] Migrazione catalogo 0002 eseguita in Supabase con esito Success.
- [x] Migrazione 0003 eseguita: funzione fondatore spostata nello schema `private` e policy aggiornate.
- [x] Il branch di lavoro resta separato da `main`.

## Da verificare insieme in Supabase

La migrazione 0004 `supabase/migrations/0004_least_privilege_hardening.sql` è stata preparata ma non eseguita. Dopo aver verificato il progetto corretto, applicarla e poi eseguire la query unica `supabase/verification/verify_brain_complete_read_only.sql`, che controlla agenti, impostazioni conservative, funzione privata, `search_path`, RLS, privilegi effettivi di `anon`, privilegi vietati su `brain_founders` e append-only dell'audit. È esclusivamente di lettura e non modifica il database.
- [ ] Query unica di sola lettura: presenza degli otto agenti previsti.
- [ ] Query di sola lettura: presenza delle cinque impostazioni iniziali e valori conservativi.
- [ ] Confermare che `emergency_stop` sia true, `autonomy_enabled` sia false e la spesa automatizzata sia zero.
- [ ] Confermare che nessun agente sia nello stato `active`.
- [x] Migrazione 0003 eseguita una sola volta (19 novembre 2026).
- [x] Verifica di sola lettura successiva alla migrazione: schema/funzione privata presenti, `SECURITY DEFINER` attivo, `anon` senza EXECUTE/USAGE, `authenticated` con EXECUTE/USAGE, vecchia funzione pubblica assente, 7 tabelle con RLS e FORCE RLS.
- [ ] Confermare che `anon_effective_privilege_tables` sia `0`: il controllo usa i privilegi effettivi del ruolo `anon`, includendo anche quelli ereditati da `PUBLIC`.
- [ ] Confermare che `founder_authenticated_required_select` sia `true` e tutti i privilegi di scrittura di `authenticated` su `brain_founders` siano `false`.
- [ ] Confermare che `core_authenticated_full_crud_tables` sia `5`; RLS deve comunque limitare questi privilegi al fondatore autorizzato.
- [ ] Confermare che UPDATE/DELETE/TRUNCATE su `brain_audit_log` siano `false` e SELECT/INSERT siano `true`.
- [x] Confermati `SECURITY DEFINER`, permessi EXECUTE (solo `authenticated`) e assenza della funzione nello schema `public`. Il controllo specifico del valore `search_path` resta da verificare tramite il file SQL di verifica aggiornato.
- [ ] Verificare policy RLS e accesso fondatore con test controllato.

## Da verificare insieme nella console, solo dopo i controlli database
- [ ] Login con account fondatore.
- [ ] Caricamento dei contatori, delle schede agente e delle impostazioni di sicurezza in sola lettura.
- [ ] Creazione di una attività di prova e presenza nel registro.
- [ ] Verificare che un account non autorizzato non possa leggere o modificare i dati BRAIN.
- [ ] Verificare che approvare/rifiutare una richiesta registri solo una decisione e non esegua azioni esterne.

## Vincoli fino al completamento dei test
- Nessun merge in `main`, nessun deploy Cloudflare e nessuna pubblicazione della console.
- Nessuna attivazione degli agenti o delle automazioni.
- Nessun pagamento, trasferimento, contratto o comunicazione esterna automatica.
- Non chiedere password, token o chiavi segrete in chat.
- Per test con account non autorizzato usare un account di prova controllato; non modificare o disattivare l'account principale.

## Limite operativo attuale
Non è disponibile in questa sessione una connessione diretta al database Supabase. Il fondatore ha fornito l'output di una query di sola lettura eseguita il 19 novembre 2026: i controlli principali della migrazione 0003 sono positivi e tutte le sette tabelle risultano protette da RLS e FORCE RLS. Il valore effettivo di `search_path`, i dati di catalogo/impostazioni e i test end-to-end della console restano da confermare.
