# CASHUP BRAIN — checklist di sicurezza

## Database
- [ ] Migrazioni 0001–0004 applicate nell'ordine corretto.
- [ ] RLS e FORCE RLS attivi su tutte le 7 tabelle.
- [ ] Nessun privilegio effettivo di anon/PUBLIC sulle tabelle BRAIN.
- [ ] `brain_founders`: authenticated può solo SELECT; nessun INSERT/UPDATE/DELETE.
- [ ] `brain_audit_log`: authenticated può solo SELECT/INSERT.
- [ ] Altre tabelle: accesso consentito solo al fondatore tramite funzione privata.
- [ ] Funzione privata: SECURITY DEFINER, search_path vuoto, EXECUTE solo authenticated; schema private non esposto alle API.
- [ ] Test negativo con account authenticated non fondatore.
- [ ] Nessuna policy permissiva aggiuntiva o grant inatteso.

## Identità e account
- [ ] MFA attivata e testata per il fondatore.
- [ ] Password unica, lunga, non riutilizzata e custodita in password manager.
- [ ] Email di recupero protetta con MFA.
- [ ] Sessioni e dispositivi non riconosciuti revocati.
- [ ] Rate limits e protezione brute-force configurati nel provider.

## Browser e hosting
- [ ] Solo HTTPS e HSTS sul dominio definitivo.
- [x] JS/CSS estratti in file esterni; nessuno script o foglio di stile inline nella pagina.
- [ ] Verificare sul dominio reale che la CSP fornita in `dashboard/_headers` sia effettivamente applicata e non generi errori; gli header valgono solo se il file si trova alla radice della directory pubblicata.
- [ ] Bloccare a una versione esatta la dipendenza Supabase JS da esm.sh o servirla da bundle controllato.
- [ ] CSP rigorosa senza `unsafe-eval` e senza `unsafe-inline`.
- [ ] `frame-ancestors 'none'`, X-Content-Type-Options nosniff, Referrer-Policy restrittiva.
- [ ] Permissions-Policy minima.
- [ ] Nessun dato sensibile in URL, console, analytics o errori.
- [ ] XSS test su titolo/descrizione/etichette e contenuti dal database.
- [ ] Nessun token o password stampato nei log.

## Codice e supply chain
- [ ] Nessuna service_role key o segreto in Git, HTML, JS, bundle o log.
- [ ] Secret scanning attivo e storico repository controllato.
- [ ] Dipendenze versionate e aggiornate; audit vulnerabilità prima di ogni release.
- [ ] Branch protection su main, MFA GitHub e revisione obbligatoria.
- [ ] Workflow CI con permessi minimi e pin delle GitHub Actions a SHA.
- [ ] Nessun deploy automatico dalla branch di lavoro.

## Operazioni e resilienza
- [ ] Backup automatici attivi e retention documentata.
- [ ] Test di restore eseguito.
- [ ] Monitoraggio accessi, errori e anomalie.
- [ ] Procedura di revoca sessioni/rotazione segreti/incident response pronta.
- [ ] Emergency stop testato e indipendente dall'autonomia.
- [ ] Nessun agente, pagamento o integrazione esterna attiva prima di test e approvazione.

## Criterio di rilascio

Non pubblicare la console finché ogni voce critica non è verificata con evidenza. Un controllo statico del repository non sostituisce un test reale sul progetto e sul dominio.
