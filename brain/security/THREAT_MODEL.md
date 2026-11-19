# CASHUP BRAIN — modello delle minacce

## Obiettivo e confini

Proteggere la console privata del fondatore e i dati BRAIN da accessi non autorizzati, escalation di privilegi, abuso delle API, injection, furto di sessione, esposizione di segreti, errori operativi e compromissione della supply chain.

Questo documento descrive controlli e rischi noti; non è una certificazione e non garantisce immunità assoluta. La console resta non pubblicata e gli agenti restano inattivi.

## Dati e risorse da proteggere

- Identità del fondatore, sessioni e credenziali.
- Tabella di autorizzazione `brain_founders`.
- Attività, memoria, catalogo agenti, approvazioni, impostazioni e audit.
- Chiavi, token, configurazioni di deploy e futuri segreti di integrazione.
- Disponibilità del progetto e integrità del database.

## Attori e scenari di minaccia

| Minaccia | Impatto | Controllo richiesto |
|---|---|---|
| Utente CASHUP ordinario o account anonimo | Lettura/modifica dati BRAIN | RLS + FORCE RLS, grants minimi, test con account non fondatore |
| Account fondatore compromesso | Controllo della console | MFA, password unica, sessioni revocabili, avvisi di accesso |
| Furto token/sessione | Impersonificazione | HTTPS, CSP, XSS prevention, scadenza/revoca sessioni, niente token nei log |
| SQL injection / abuso PostgREST | Esfiltrazione o modifica | Query parametrizzate del client, RLS, grants minimi, niente SQL dinamico da input utente |
| XSS / HTML injection | Furto sessione o azioni a nome utente | Escape di ogni dato dinamico, evitare HTML dinamico non sanificato, CSP rigorosa |
| Clickjacking / framing | Azioni indotte | `frame-ancestors 'none'` via header HTTP |
| CSRF / richieste cross-site | Azioni indesiderate | Supabase JWT, SameSite/controlli browser, origini ristrette dove applicabile |
| Dipendenza CDN compromessa | Esecuzione codice ostile | Versioni bloccate, audit dipendenze, ridurre dipendenze esterne e SRI dove compatibile |
| Segreti committati | Accesso a servizi | Nessun service-role key o segreto nel client/repository; secret scanning e rotazione |
| Abuso approvazioni | Falsa autorizzazione | Decisioni tracciate; nessuna esecuzione automatica collegata allo stato approved |
| Ransomware / cancellazione / errore umano | Perdita dati | Backup automatici, PITR se disponibile, prove periodiche di restore |
| DDoS / abuso risorse | Indisponibilità/costi | Rate limits, limiti Supabase/Cloudflare, monitoraggio e kill switch |
| Compromissione GitHub/deploy | Modifica codice pubblicato | MFA GitHub, branch protection, review, deploy separato e approvazione |

## Architettura di sicurezza attuale

- Il browser usa solo la chiave Supabase publishable, che non è un segreto; la protezione dei dati dipende da RLS.
- HTML, CSS e JavaScript della console sono separati per consentire una Content Security Policy senza script/style inline.
- È stato aggiunto `dashboard/_headers` con CSP, HSTS, protezione anti-framing, nosniff, referrer policy e permissions policy. Gli header saranno effettivi solo se `brain/dashboard` è la directory radice di pubblicazione Cloudflare o se vengono replicati nella configurazione dell'hosting definitivo.
- La funzione `private.brain_is_founder()` è SECURITY DEFINER con search_path vuoto; deve restare non esposta tramite gli schemi API.
- Le tabelle BRAIN devono avere RLS e FORCE RLS attivi.
- `brain_founders` non deve consentire inserimenti o modifiche dal client.
- `brain_audit_log` è append-only per il client: SELECT/INSERT, senza UPDATE/DELETE.
- Le approvazioni registrano una decisione ma non devono attivare workflow o operazioni esterne.
- Autonomia disattivata, arresto di emergenza attivo, spesa automatizzata pari a zero.
- Nessun agente attivo.

## Requisiti prima di pubblicare

1. Eseguire le query di verifica e ottenere tutti i valori attesi.
2. Applicare e verificare la migrazione 0004 solo dopo aver confermato il database corretto.
3. Testare con account fondatore e account autenticato non fondatore.
4. Provare esplicitamente SELECT/INSERT/UPDATE/DELETE/TRUNCATE su ogni tabella con il non fondatore: tutte devono essere negate.
5. Testare che l'audit non consenta UPDATE/DELETE.
6. Abilitare MFA per l'account fondatore e verificare il recupero account.
7. Applicare header HTTP di sicurezza sul dominio effettivo; controllare CSP, HSTS, frame-ancestors e HTTPS.
8. Verificare secret scanning, dipendenze e protezione del branch.
9. Configurare backup e test di ripristino.
10. Definire logging, alert, contatti e procedura di risposta agli incidenti.

## Risposta agli incidenti

- Fermare immediatamente deploy e automazioni; mantenere l'arresto di emergenza attivo.
- Revocare le sessioni compromesse e cambiare le credenziali interessate.
- Ruotare le chiavi eventualmente esposte; non incollarle in chat o commit.
- Conservare log e timestamp, non cancellare prove.
- Verificare accessi, audit, policy, grants e modifiche recenti.
- Ripristinare da backup solo dopo aver identificato il punto di compromissione.
- Riprendere il servizio solo dopo nuova verifica indipendente.

## Limiti aperti

La configurazione del progetto Supabase, MFA, rate limits, backup/PITR, impostazioni GitHub, headers del dominio e log del provider non sono verificabili dal solo repository. Vanno controllati nelle rispettive console prima della pubblicazione.
