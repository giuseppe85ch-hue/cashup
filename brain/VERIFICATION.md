# CASHUP BRAIN — stato di verifica aggiornato

Ultimo controllo diretto sul progetto Supabase CASHUP: 19 novembre 2026.

## Completato e verificato
- [x] Progetto corretto `fzcricigqqpzcujrenkf`, stato ACTIVE_HEALTHY.
- [x] Migrazioni di hardening 0004–0012 applicate tramite connessione Supabase e presenti nella cronologia remota con versioni timestamp.
- [!] Le migrazioni iniziali 0001–0003 risultano applicate manualmente in precedenza (tabelle e funzione esistono), ma non compaiono nella cronologia remota restituita da Supabase. Prima di usare `db push`, `db reset`, creare branch DB o ricostruire il progetto, occorre riallineare il baseline senza rieseguire queste DDL sul database attivo.
- [x] 7 tabelle BRAIN presenti, tutte con RLS e FORCE RLS.
- [x] 9 policy BRAIN: SELECT e INSERT controllato su task, nessun INSERT client su audit.
- [x] 8 agenti registrati, nessuno attivo.
- [x] 5 impostazioni conservative presenti: autonomia false, emergency stop true, spesa automatizzata 0, approvazione finanziaria true, approvazione alto rischio true.
- [x] Funzione privata SECURITY DEFINER con search_path vuoto, EXECUTE negato ad anon e consentito ad authenticated, requisito AAL2 nel corpo funzione; funzione pubblica precedente assente.
- [x] Schema private: USAGE negato ad anon e consentito ad authenticated.
- [x] Grants BRAIN: zero privilegi diretti per anon e service_role; founder table sola lettura per authenticated; audit solo SELECT per il client, scrittura riservata ai trigger DB.
- [x] Tabelle CASHUP applicative: nessun privilegio anon, nessun TRUNCATE/REFERENCES/TRIGGER per anon/authenticated/service_role; grants authenticated limitati alle operazioni richieste dalle policy.
- [x] Default privileges del ruolo postgres in public revocati per nuovi oggetti tabella, sequenza e funzione; EXECUTE su nuove funzioni create da postgres revocato anche a PUBLIC.
- [x] Test RLS con identità fondatore: funzione true e visibili gli 8 agenti/5 impostazioni.
- [x] Test RLS non fondatore AAL1/AAL2: funzione false e zero righe BRAIN visibili.
- [x] Test RLS fondatore: AAL1 negato e zero agenti visibili; AAL2 autorizzato e 8 agenti visibili.
- [x] Policy utente ottimizzate con `(select auth.uid())`; indici aggiunti sulle 9 chiavi esterne segnalate.
- [x] Security Advisor dopo le modifiche: resta un avviso Auth per Leaked Password Protection disattivata.
- [x] Audit approfondito: nessuna vista/materialized view nello schema `public`; nessuna funzione SECURITY DEFINER in `public`; entrambe le RPC sono SECURITY INVOKER con search_path vuoto; nessun oggetto pubblico posseduto da `supabase_admin`; nessun bucket Storage o policy Storage applicativa.
- [x] Nessun oggetto pubblico posseduto da `supabase_admin` al momento; i default privileges interni di quel ruolo non sono modificabili dal progetto e diventano rilevanti se in futuro un'estensione crea oggetti in `public`. Evitare di installare estensioni in `public`; preferire lo schema `extensions` quando supportato.
- [x] Sequenza `brain_audit_log.id` usa IDENTITY ALWAYS; l'assenza di USAGE su sequence per `authenticated` è intenzionale e non blocca gli INSERT con ID omesso.
- [x] Performance Advisor: nessun avviso di foreign key non indicizzate e nessun avviso RLS initplan; restano solo avvisi informativi per indici nuovi/non ancora utilizzati.

## Controllo approfondito aggiuntivo — 19 novembre 2026
- [x] Nuova lettura diretta: tutte le 12 tabelle public hanno RLS e FORCE RLS; nessun grant diretto ad anon o service_role; nessuna vista public; due RPC in public entrambe SECURITY INVOKER con search_path vuoto, anon senza EXECUTE e authenticated con EXECUTE; nessun indice invalido.
- [x] Migrazione 0010 applicata: authenticated non può INSERT su audit; la policy INSERT audit è stata rimossa; trigger DB scrive audit.
- [x] Migrazione 0010: rimosso INSERT client su audit; audit scritto dai trigger protetti; nessun inserimento diretto client su audit.
- [x] Trigger audit task e approvazioni SECURITY DEFINER in schema private, search_path vuoto, proprietario postgres, EXECUTE negato ai ruoli client; il client non può più falsificare direttamente eventi audit.
- [x] Migrazione 0011 applicata: `brain_create_task` SECURITY INVOKER; grants INSERT solo su title/description/priority; status/sector/created_by non modificabili dal client; vincoli DB su titolo e descrizione; policy INSERT richiede fondatore+AAL2 e valori server-side.
- [x] Test AAL2 con ROLLBACK dopo 0011: RPC task e audit automatico riusciti; status/sector/created_by non scrivibili; AAL1 e non-fondatore AAL2 respinti; nessun dato test rimasto.
- [x] Migrazione 0012 applicata: browser senza INSERT su `daily_steps` e nessuna policy INSERT; `profiles` consente INSERT solo su id/display_name e UPDATE solo su display_name; id/created_at non modificabili.
- [x] Test transazionale profilo: upsert id/display_name riuscito con grants ristretti e ROLLBACK; nessun dato test conservato.
- [x] `points_ledger`, `affiliate_clicks`, `commissions` restano read-only per authenticated; il client non può creare punti, clic o commissioni.
- [!] Repository GitHub pubblico: sorgente e documentazione BRAIN sono visibili. Ricerca puntuale sul branch predefinito `main` senza risultati per `SUPABASE_SERVICE_ROLE_KEY`, `sb_secret_` e `BEGIN PRIVATE KEY`; non equivale a scansione completa dello storico o del branch di lavoro. Secret scanning GitHub non verificato.
- [x] Funzione privata `private.brain_is_founder()`: SECURITY DEFINER, `search_path` vuoto, EXECUTE negato ad anon e consentito ad authenticated; schema private senza USAGE ad anon.
- [x] Nessuna tabella applicativa iscritta alla publication `supabase_realtime`.
- [ ] La lista effettiva degli schemi esposti dalla Data API non è leggibile dai cataloghi SQL/ruolo disponibili (`current_setting('pgrst.db_schemas')` è NULL). Verificare in Project Settings → Data API → Exposed schemas che `private` sia escluso; lasciare solo gli schemi strettamente necessari e disattivare Automatically expose new tables and functions.
- [!] Un vincolo non validato appartiene a `realtime.messages` (schema gestito dal servizio), non alle tabelle public dell'applicazione; non modificarlo manualmente.
- [!] I default ACL di `supabase_admin` in `public` concedono privilegi predefiniti ad anon/authenticated/service_role. Il ruolo di progetto `postgres` non è membro di `supabase_admin` e non può modificarli. Non risultano oggetti `public` attualmente posseduti da `supabase_admin`; non installare estensioni in `public`.
- [x] Corretto il flusso approvazioni nella dashboard: ora usa la RPC atomica, segnala le richieste già gestite/non più disponibili e il database imposta identità/data e registra il cambio stato.

## Da completare fuori dal database
- [ ] Leaked Password Protection non attivabile sul piano Free: Supabase la rende disponibile dal piano Pro. Nessun upgrade è stato richiesto o eseguito; usare password lunga/unica e MFA finché il progetto resta Free.
- [ ] Configurare e testare MFA per l'account fondatore: il database mostra 0 fattori registrati. Il flusso TOTP/AAL2 è stato aggiunto alla dashboard e al database ma non ancora collaudato nel browser.
- [ ] Abilitare Passkeys nelle impostazioni Supabase Auth e configurare RP ID/origins sul dominio HTTPS definitivo; nessuna passkey è ancora registrata. La funzione Supabase è sperimentale. La console richiede comunque TOTP AAL2. TOTP è disponibile nel progetto senza richiedere un upgrade.

- [x] File `brain/supabase/verification/verify_extended_security_read_only.sql` disponibile per audit di sola lettura dopo modifiche a schema, estensioni o permessi.
- [ ] Rendere privato il repository dopo aver verificato l'integrazione Cloudflare Pages; il repo è pubblico e fork/copie già esistenti non diventano privati automaticamente. Attivare secret scanning, push protection, MFA GitHub e protezione branch. Il workflow statico è stato esteso anche a client root, CSP, service worker, SDK fissato e scan segreti client; run #73 completato con SUCCESS sul commit corrente; controlli sintassi JS, manifest, segreti nel client, HTML/CSP, service worker e RPC. Il controllo CI non sostituisce il secret scanning GitHub dell'intero storico.
- [ ] Piano Free senza backup automatici: predisporre esportazione manuale cifrata (database e dati Auth) e provare il ripristino in un progetto/ambiente separato; non creare progetti a pagamento senza consenso.
- [ ] Pubblicare la dashboard solo su hosting privato/protetto; applicare davvero gli header HTTP di `_headers` nella root del sito: CSP base su `/*`, con no-store/noindex aggiuntivi su `/brain/dashboard/*`.
- [x] Codice client predisposto per passkey WebAuthn (registrazione, accesso, elenco e revoca) senza trattare o memorizzare dati biometrici.
- [x] Corretto il caricamento elenco passkey: viene richiesto dopo che la sessione fondatore ha superato MFA AAL2.
- [ ] Test end-to-end nel browser con login reale, enrollment TOTP, challenge AAL2 e verifica della console; richiede intervento del fondatore.
- [ ] Testare header CSP/HSTS/anti-framing sul dominio effettivo.
- [ ] Eseguire una revisione indipendente prima di qualsiasi attivazione di agenti o automazioni.
- [ ] Completare il piano IP: ricerca marchio, verifica titolarità, accordi di cessione/riservatezza, inventario licenze e prove di paternità. Vedere `IP_PROTECTION_PLAN.md`.

## Vincoli attivi
- Nessun merge in `main` e nessun deploy Cloudflare eseguito.
- Console BRAIN non pubblicata.
- Nessun agente attivo e nessuna automazione.
- `autonomy_enabled=false`, `emergency_stop=true`, `max_automated_spend_eur=0`.
- Pagamenti, contratti, accessi sensibili e azioni irreversibili richiedono approvazione umana.

## Nota
Questi test dimostrano i controlli esaminati nel database, non una sicurezza assoluta né una certificazione di sicurezza. Le impostazioni Auth, GitHub, Cloudflare, backup e il test end-to-end restano separati e non vanno dichiarati completati finché non sono verificati con evidenza.