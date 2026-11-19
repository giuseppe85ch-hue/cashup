# CASHUP BRAIN — checklist di sicurezza

## Database
- [x] Migrazioni BRAIN 0001–0005 presenti/applicate nel progetto CASHUP; 0004 e 0005 applicate il 19 novembre 2026.
- [x] RLS e FORCE RLS attivi su tutte le 7 tabelle BRAIN.
- [x] Nessun privilegio effettivo di anon o service_role sulle tabelle BRAIN; verificato anche TRUNCATE.
- [x] `brain_founders`: authenticated può solo SELECT; nessun INSERT/UPDATE/DELETE/TRUNCATE.
- [x] `brain_audit_log`: authenticated può solo SELECT/INSERT, senza UPDATE/DELETE/TRUNCATE.
- [x] Altre tabelle BRAIN: accesso RLS consentito solo al fondatore tramite funzione privata.
- [x] Funzione privata: SECURITY DEFINER, search_path vuoto, EXECUTE solo authenticated; anon senza USAGE su private.
- [x] Test negativo simulato con ruolo authenticated non fondatore: nessuna riga BRAIN visibile.
- [x] Esattamente 8 policy BRAIN previste; nessuna policy aggiuntiva. Default privileges postgres in public revocati.

## Identità e account
- [ ] MFA da attivare e testare per il fondatore.
- [ ] Password unica, lunga, non riutilizzata e custodita in password manager.
- [ ] Email di recupero protetta con MFA.
- [ ] Sessioni e dispositivi non riconosciuti revocati.
- [ ] Rate limits e protezione brute-force da verificare nelle impostazioni Auth.
- [ ] CAPTCHA / protezione anti-bot da valutare e configurare se supportata.
- [ ] URL del sito e redirect URL Supabase limitati ai soli domini CASHUP autorizzati.
- [ ] Verificare nelle impostazioni Data API che `private` sia escluso dagli schemi esposti; i privilegi SQL anon su private sono già negati.

## Browser e hosting
- [ ] Solo HTTPS e HSTS sul dominio definitivo.
- [x] JS/CSS estratti in file esterni; nessuno script o foglio di stile inline nella pagina.
- [ ] Console non pubblicata: prima del deploy verificare che `dashboard/_headers` sia effettivamente applicato nella root di pubblicazione.
- [x] Versione Supabase JS fissata a `2.119.1` tramite esm.sh con bundle; gli aggiornamenti devono essere deliberati e verificati.
- [x] CSP preparata senza `unsafe-eval` e senza `unsafe-inline`; resta da verificarla sul dominio dopo il deploy.
- [x] Header preparati: frame-ancestors 'none', nosniff, Referrer-Policy restrittiva; verifica HTTP reale ancora da fare.
- [x] Permissions-Policy minima preparata; verifica HTTP reale ancora da fare.
- [ ] Nessun dato sensibile in URL, console, analytics o errori.
- [ ] XSS test su titolo/descrizione/etichette e contenuti dal database.
- [ ] Nessun token o password stampato nei log.

## Codice e supply chain
- [ ] Nessuna service_role key o segreto in Git, HTML, JS, bundle o log.
- [ ] Secret scanning attivo e storico repository controllato.
- [ ] Dipendenze versionate e aggiornate; audit vulnerabilità prima di ogni release.
- [ ] Branch protection su main: blocco force-push/cancellazione, review obbligatoria e controlli CI prima del merge.
- [ ] MFA GitHub, secret scanning e push protection attivi, se disponibili nel piano.
- [ ] Workflow CI con permessi minimi e pin delle GitHub Actions a SHA.
- [ ] Nessun deploy automatico dalla branch di lavoro.

## Operazioni e resilienza
- [ ] Backup automatici e retention da verificare in base al piano Supabase.
- [ ] Test di restore da pianificare ed eseguire.
- [ ] Monitoraggio accessi, errori e anomalie.
- [ ] Procedura di revoca sessioni/rotazione segreti/incident response pronta.
- [ ] Emergency stop testato e indipendente dall'autonomia.
- [ ] Nessun agente, pagamento o integrazione esterna attiva prima di test e approvazione.

## Controlli automatici aggiuntivi
- [x] Privilegi predefiniti del ruolo postgres in public revocati per tabelle, sequenze e funzioni; EXECUTE rimosso da PUBLIC per nuove funzioni create da postgres. I default ACL di supabase_admin sono gestiti dalla piattaforma Supabase e non sono modificabili dal progetto.
- [x] Policy RLS ottimizzate con (select auth.uid()); indici aggiunti sulle 9 chiavi esterne segnalate.
- [ ] Security Advisor: abilitare Leaked Password Protection nelle impostazioni Auth.

## Criterio di rilascio

Non pubblicare la console finché ogni voce critica non è verificata con evidenza. Un controllo statico del repository non sostituisce un test reale sul progetto e sul dominio.
