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
| Dipendenza CDN compromessa | Esecuzione codice ostile | Versioni bloccate, workflow statico, ridurre dipendenze esterne e SRI dove compatibile |
| Segreti committati | Accesso a servizi | Nessun service-role key o segreto nel client/repository; secret scanning e rotazione |
| Abuso approvazioni | Falsa autorizzazione | Decisioni tracciate; nessuna esecuzione automatica collegata allo stato approved |
| Ransomware / cancellazione / errore umano | Perdita dati | Piano Free senza backup automatici: esportazioni manuali cifrate, copia off-site e prove di restore |
| DDoS / abuso risorse | Indisponibilità/costi | Rate limits, limiti Supabase/Cloudflare, monitoraggio e kill switch |
| Compromissione GitHub/deploy | Modifica codice pubblicato | MFA GitHub, branch protection, review, deploy separato e approvazione |

## Architettura di sicurezza attuale

- Il browser usa solo la chiave Supabase publishable, che non è un segreto; la protezione dei dati dipende da RLS.
- La dashboard richiede AAL2 prima di mostrare i dati e include enrollment/challenge TOTP. Il fondatore non ha ancora fattori registrati nel progetto: il flusso deve essere completato e collaudato nel browser.
- HTML, CSS e JavaScript della console sono separati per consentire una Content Security Policy senza script/style inline.
- È stato aggiunto `_headers` nella root del repository con CSP, HSTS, protezione anti-framing, nosniff, referrer policy e permissions policy, limitati al percorso `/brain/dashboard`. Gli header saranno effettivi solo se la root di pubblicazione Cloudflare include questo file; la risposta HTTP reale resta da verificare.
- La funzione `private.brain_is_founder()` è SECURITY DEFINER con search_path vuoto e richiede `auth.jwt()->>'aal' = 'aal2'`; il controllo MFA è applicato nel database, non soltanto nell'interfaccia. La funzione deve restare non esposta tramite gli schemi API.
- Le sette tabelle BRAIN hanno RLS e FORCE RLS attivi; grants minimi, zero privilegi anon/service_role sulle tabelle BRAIN e 9 policy verificate.
- I default ACL di `supabase_admin` nello schema `public` sono gestiti da Supabase e concedono privilegi predefiniti ad alcuni ruoli API; il ruolo `postgres` del progetto non è membro di `supabase_admin` e non può modificarli. Non risultano oggetti public attualmente posseduti da quel ruolo; evitare estensioni in `public` e disabilitare l'esposizione automatica di nuove tabelle nella Data API.
- `brain_founders` consente ad authenticated solo SELECT sulla propria riga attiva; gli altri privilegi sono revocati.
- `brain_audit_log` è append-only per il client: SELECT/INSERT, senza UPDATE/DELETE/TRUNCATE; la policy INSERT vincola autore, tipo e outcome.
- Le RPC `brain_create_task` e `brain_decide_approval` sono SECURITY INVOKER e rendono atomici aggiornamento e audit; test AAL2 transazionale con ROLLBACK completato.
- Le approvazioni registrano una decisione ma non devono attivare workflow o operazioni esterne.
- Autonomia disattivata, arresto di emergenza attivo, spesa automatizzata pari a zero; valori verificati nel database.
- Nessun agente attivo.

## Requisiti prima di pubblicare

1. [x] Applicare migrazioni 0004–0009; verificare tutti i valori con query completa.
2. [x] Testare funzione e lettura BRAIN come fondatore.
3. [x] Testare identità authenticated non fondatore: zero righe visibili su agenti, impostazioni e audit.
4. [x] Verificare grants, RLS/FORCE RLS, funzione privata, search_path, policy e default ACL.
5. [ ] Attivare MFA TOTP del fondatore e collaudare l'accesso; Leaked Password Protection resta disattivata sul piano Free.
6. [ ] Verificare schema esposto, redirect URL, rate limits e CAPTCHA nella console Supabase.
7. [ ] Applicare e verificare header HTTP sul dominio effettivo prima di pubblicare la console.
8. [ ] Verificare secret scanning, dipendenze e protezione del branch GitHub.
9. [ ] Esportare manualmente database/dati Auth, cifrare e conservare off-site; provare il ripristino in un ambiente separato (piano Free senza backup automatici).
10. [ ] Definire logging, alert, contatti e procedura di risposta agli incidenti.

## Risposta agli incidenti

- Fermare immediatamente deploy e automazioni; mantenere l'arresto di emergenza attivo.
- Revocare le sessioni compromesse e cambiare le credenziali interessate.
- Ruotare le chiavi eventualmente esposte; non incollarle in chat o commit.
- Conservare log e timestamp, non cancellare prove.
- Verificare accessi, audit, policy, grants e modifiche recenti.
- Ripristinare da backup solo dopo aver identificato il punto di compromissione.
- Riprendere il servizio solo dopo nuova verifica indipendente.

## Limiti aperti

Il Security Advisor Supabase segnala ancora `Leaked Password Protection Disabled`. È una configurazione Auth esterna al database e non è modificabile tramite gli strumenti Supabase disponibili in questa sessione. Anche MFA, rate limits, CAPTCHA, redirect URL, backup e configurazione GitHub/Cloudflare richiedono verifica nelle rispettive console.

La configurazione del progetto Supabase, MFA, rate limits, backup/PITR, impostazioni GitHub, headers del dominio e log del provider non sono verificabili dal solo repository. Vanno controllati nelle rispettive console prima della pubblicazione.
