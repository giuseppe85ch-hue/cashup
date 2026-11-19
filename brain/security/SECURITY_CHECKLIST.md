# CASHUP BRAIN — checklist di sicurezza

## Database
- [x] Migrazioni BRAIN/CASHUP 0001–0013 e hardening CASHUP applicati il 19 novembre 2026.
- [x] RLS e FORCE RLS attivi su tutte le 12 tabelle pubbliche (7 BRAIN + 5 CASHUP).
- [x] Nessun privilegio effettivo di anon o service_role su tutte le 12 tabelle public; verificato anche TRUNCATE.
- [x] `brain_founders`: authenticated può solo SELECT; nessun INSERT/UPDATE/DELETE/TRUNCATE.
- [x] `brain_audit_log`: authenticated può solo SELECT; nessuna policy INSERT; scrittura esclusivamente dai trigger SECURITY DEFINER protetti.
- [x] Altre tabelle BRAIN: accesso RLS consentito solo al fondatore tramite funzione privata.
- [x] Funzione privata: SECURITY DEFINER, search_path vuoto, EXECUTE solo authenticated; anon senza USAGE su private; la funzione richiede anche claim JWT AAL2.
- [x] Test negativo simulato con ruolo authenticated non fondatore: nessuna riga BRAIN visibile.
- [x] 9 policy BRAIN verificate: task SELECT e INSERT limitato; audit solo SELECT. Default privileges del ruolo postgres in public revocati.
- [x] RPC `brain_create_task`: SECURITY INVOKER con search_path vuoto, EXECUTE solo authenticated e controllo fondatore+AAL2; `brain_decide_approval`: SECURITY INVOKER, search_path vuoto, EXECUTE solo authenticated.
- [x] Grants minimi: task SELECT più INSERT limitato a title/description/priority, audit solo SELECT per client, agenti/memoria/impostazioni read-only, approvazioni UPDATE solo status e senza INSERT/DELETE.
- [x] Trigger database SECURITY DEFINER in private, search_path vuoto, registra automaticamente task e decisioni approvazioni, imposta decided_by/decided_at e aggiorna updated_at; audit atomico e non falsificabile con INSERT client.
- [x] Test transazionale con ruolo authenticated/AAL2 e ROLLBACK: creazione attività e approvazione scrivono i rispettivi eventi audit nella stessa transazione.
- [!] Nessun oggetto public attualmente posseduto da `supabase_admin`, ma i suoi default ACL in public concedono privilegi a anon/authenticated/service_role. Il ruolo postgres del progetto non è membro di supabase_admin e non può modificarli. Evitare estensioni in public.

## Identità e account
- [ ] MFA TOTP da attivare e testare per il fondatore: il database al 19 novembre 2026 mostra 0 fattori registrati.
- [x] La dashboard richiede AAL2 e include flusso TOTP di enrollment/verifica; anche RLS richiede AAL2. Test DB: fondatore AAL1 negato, fondatore AAL2 autorizzato, non fondatore AAL2 negato. Collaudo browser ancora da eseguire.
- [ ] Password unica, lunga, non riutilizzata e custodita in password manager.
- [ ] Email di recupero protetta con MFA.
- [ ] Sessioni e dispositivi non riconosciuti revocati.
- [ ] Rate limits e protezione brute-force da verificare nelle impostazioni Auth.
- [ ] CAPTCHA / protezione anti-bot da valutare e configurare se supportata.
- [ ] URL del sito e redirect URL Supabase limitati ai soli domini CASHUP autorizzati.
- [ ] Verificare in Project Settings → Data API → Exposed schemas che `private` sia escluso; la lista effettiva non è leggibile via SQL in questo progetto. Disattivare Automatically expose new tables and functions.

## Browser e hosting
- [ ] Solo HTTPS e HSTS sul dominio definitivo.
- [x] JS/CSS estratti in file esterni; nessuno script o foglio di stile inline nella pagina.
- [ ] Console non pubblicata: prima del deploy verificare che `_headers` nella root del sito, con regole limitate a `/brain/dashboard/*` sia effettivamente applicato nella root di pubblicazione.
- [x] WebAuthn/passkey predisposta nel client con opt-in sperimentale, accesso, registrazione e rimozione dopo AAL2.
- [ ] Abilitare Passkeys in Supabase Auth e configurare RP ID/origins sul dominio HTTPS definitivo; test Android biometria/PIN ancora da fare.
- [ ] Passkeys Supabase è sperimentale: mantenere TOTP AAL2 come requisito separato e metodo di recupero.
- [x] Versione Supabase JS fissata a `2.119.1` tramite esm.sh con bundle; gli aggiornamenti devono essere deliberati e verificati.
- [x] CSP preparata senza `unsafe-eval` e senza `unsafe-inline`; resta da verificarla sul dominio dopo il deploy.
- [x] Header preparati nel file `_headers` alla root Pages: CSP/HSTS/anti-framing base su `/*`, con no-store/noindex aggiuntivi su `/brain/dashboard/*`: CSP, HSTS, anti-framing, nosniff, Referrer-Policy, Permissions-Policy, no-store e noindex; verifica HTTP reale ancora da fare.
- [x] Permissions-Policy minima preparata; verifica HTTP reale ancora da fare.
- [ ] Nessun dato sensibile in URL, console, analytics o errori.
- [x] Privilegi `anon` rimossi dalle cinque tabelle applicative; `TRUNCATE`, `REFERENCES` e `TRIGGER` rimossi dai ruoli browser e dal ruolo service per queste tabelle.
- [x] RLS e FORCE RLS attivi sulle 12 tabelle pubbliche.
- [x] Grants `authenticated` limitati alle operazioni coperte dalle policy esistenti.
- [x] Migrazione 0011: nessuna funzione SECURITY DEFINER nello schema public; entrambe le RPC pubbliche SECURITY INVOKER.
- [x] Migrazione 0012: `daily_steps` read-only per browser, nessuna policy INSERT; profili con grants solo `id/display_name` in insert e `display_name` in update; upsert testato con ROLLBACK.
- [x] `points_ledger`, `affiliate_clicks` e `commissions` non consentono scritture dal client.
- [x] `daily_steps` nessun INSERT dal browser e nessuna policy INSERT fino a integrazione server-verificata.
- [x] `profiles` INSERT solo id/display_name, UPDATE solo display_name; id e created_at non modificabili; upsert testato con ROLLBACK.
- [x] Migrazione 0011: colonne task `status`, `sector`, `created_by` non scrivibili dal client; title/description/priority soggetti a vincoli DB e RLS founder+AAL2.
- [ ] XSS test su titolo/descrizione/etichette e contenuti dal database.
- [ ] Nessun token o password stampato nei log.

## Web client e supply chain
- [x] HTML principale senza script, style o handler inline; CSS/JS esterni.
- [x] CSP strict senza `unsafe-inline` preparata per root e dashboard; verifica HTTP reale dopo deploy ancora necessaria.
- [x] SDK Supabase fissato a versione esatta; service worker non intercetta richieste cross-origin e fa fallback solo sulle navigazioni.
- [x] Password minima 12 caratteri richiesta dall'interfaccia; [ ] allineare impostazione Auth server-side a 12 caratteri e leaked password protection.

## Codice e supply chain
- [!] Repository GitHub attualmente pubblico: sorgente e documentazione sono leggibili da chiunque. Verificare Cloudflare Pages e poi rendere privato il repository; fork pubblici/copie già scaricate non diventano privati.
- [ ] Nessuna service_role key o segreto in Git, HTML, JS, bundle o log.
- [ ] Secret scanning attivo e storico repository controllato.
- [ ] Dipendenze versionate e aggiornate; audit vulnerabilità prima di ogni release.
- [ ] Branch protection su main: blocco force-push/cancellazione, review obbligatoria e controlli CI prima del merge.
- [ ] MFA GitHub, secret scanning e push protection attivi, se disponibili nel piano.
- [x] Workflow CI statico aggiunto con `contents: read` e action checkout fissata a SHA; il run #92 è completato con SUCCESS sul commit `d6e1e31c09681371681bb5b105a4c68e51b002dc` (19 novembre 2026). I controlli statici non equivalgono a secret scanning completo dello storico, test end-to-end, scansione dipendenze o revisione indipendente.
- [ ] Nessun deploy automatico dalla branch di lavoro.

## Proprietà intellettuale e anti-impersonificazione
- [ ] Ricerca anteriorità e deposito marchio CASHUP/logo (UIBM/EUIPO/WIPO secondo territori e budget).
- [ ] Verifica titolarità di codice, design, testi e asset; accordi scritti con collaboratori/fornitori e inventario licenze.
- [ ] Conservare prove datate, hash e release firmate; valutare deposito software SIAE.
- [ ] Classificare e mantenere segreti commerciali con accessi limitati, cifratura e NDA.
- [ ] Proteggere domini/DNS/email; configurare SPF, DKIM, DMARC e monitorare imitazioni.
- [ ] Procedura per preservare prove e segnalare impersonificazione, frodi e contenuti diffamatori.

## Operazioni e resilienza
- [!] Piano Free: nessun backup automatico. [ ] Esportazione manuale cifrata e test restore ancora da eseguire.
- [ ] Test di restore da pianificare ed eseguire.
- [ ] Monitoraggio accessi, errori e anomalie.
- [ ] Procedura di revoca sessioni/rotazione segreti/incident response pronta.
- [ ] Emergency stop testato e indipendente dall'autonomia.
- [x] Catalogo BRAIN esteso a 550 ruoli: `public.brain_agents` tutti `planned`; `private.brain_agent_specs` tutte `designed`; zero agenti attivi.
- [ ] Runtime agenti, tool gateway, policy engine, coda, budget e audit esterno da implementare prima di attivare agenti.
- [ ] Entitlement premium server-side, webhook firmati/idempotenti, revoca e ricorsi da implementare prima di vendere pacchetti.
- [ ] Nessun agente, pagamento o integrazione esterna attiva prima di test e approvazione.

## Controlli automatici aggiuntivi
- [x] Privilegi predefiniti del ruolo postgres in public revocati per tabelle, sequenze e funzioni; EXECUTE rimosso da PUBLIC per nuove funzioni create da postgres. I default ACL di supabase_admin sono gestiti dalla piattaforma Supabase e non sono modificabili dal progetto.
- [x] Policy RLS ottimizzate con (select auth.uid()); indici aggiunti sulle 9 chiavi esterne segnalate.
- [!] Leaked Password Protection non attiva; il progetto resta Free e non è stato autorizzato alcun upgrade. Usare password lunga/unica e MFA.

## Criterio di rilascio

Non pubblicare la console finché ogni voce critica non è verificata con evidenza. Un controllo statico del repository non sostituisce un test reale sul progetto e sul dominio.
