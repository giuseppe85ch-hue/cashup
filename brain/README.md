# CASHUP BRAIN — fondazione tecnica

Questa cartella contiene la preparazione tecnica di CASHUP BRAIN. La dashboard è separata dal sito CASHUP e non viene pubblicata automaticamente.

## Stato verificato — 19 novembre 2026
- Progetto Supabase CASHUP `fzcricigqqpzcujrenkf`, stato ACTIVE_HEALTHY.
- Migrazioni 0001–0003 già eseguite; migrazioni 0004 (privilegio minimo), 0005 (ottimizzazione RLS/indici) e 0006 (MFA AAL2 obbligatoria anche nel database) applicate tramite collegamento Supabase.
- Sette tabelle BRAIN con RLS e FORCE RLS, otto policy previste e nessuna policy aggiuntiva.
- Funzione `private.brain_is_founder()` SECURITY DEFINER con `search_path` vuoto; esecuzione negata ad anon, consentita ad authenticated; richiede claim JWT `aal2`; vecchia funzione pubblica assente.
- Zero privilegi diretti per anon e service_role sulle tabelle BRAIN. `brain_founders` è sola lettura per authenticated; `brain_audit_log` è append-only (SELECT/INSERT).
- Test controllato: l'identità del fondatore vede agenti e impostazioni; un'identità authenticated non fondatrice non vede agenti, impostazioni o audit.
- Otto agenti in catalogo, nessuno attivo. Cinque impostazioni conservative: autonomia false, emergency stop true, spesa automatizzata zero, approvazione umana richiesta per azioni finanziarie e ad alto rischio.
- Default privileges del ruolo postgres nello schema public revocati per nuove tabelle, sequenze e funzioni; EXECUTE sulle nuove funzioni creato da postgres revocato anche a PUBLIC. I default ACL di supabase_admin sono gestiti da Supabase e non sono modificabili dal progetto.
- Migrazione 0005 ottimizza le policy che usano auth.uid() e aggiunge indici sulle nove chiavi esterne segnalate. Il Performance Advisor non segnala più FK non indicizzate o RLS initplan; rimangono solo avvisi informativi per indici non ancora utilizzati.
- Il Security Advisor segnala ancora Leaked Password Protection disattivata nelle impostazioni Auth.

## Dashboard
- `dashboard/index.html`, `dashboard/styles.css`, `dashboard/app.js`: console web iniziale per accesso fondatore, riepilogo, creazione attività, consultazione agenti, approvazioni, audit e impostazioni.
- Il client usa solo la chiave Supabase publishable; nessuna service_role key o password è inserita nel codice.
- La versione Supabase JS è fissata a `2.119.1` tramite esm.sh bundle; aggiornamenti deliberati e verificati.
- La dashboard richiede una sessione MFA AAL2 prima di mostrare dati BRAIN e include un flusso TOTP per registrazione/verifica del fattore. Il fondatore non ha ancora fattori MFA registrati: il flusso deve essere completato e collaudato nel browser. Il database è stato testato: sessione AAL1 negata, fondatore AAL2 autorizzato, non fondatore AAL2 negato.\n- `dashboard/_headers` prepara CSP, HSTS, anti-framing, nosniff, referrer e permissions policy. Gli header sono effettivi solo se il file viene servito dalla root di pubblicazione o replicato nella configurazione hosting.
- La dashboard non è stata ancora pubblicata né collaudata end-to-end nel browser.

## Sicurezza e limiti
1. RLS e grants sono la barriera effettiva ai dati; la chiave publishable è pubblica e non è un segreto.
2. L'accesso BRAIN richiede una riga attiva in `brain_founders` e viene ricontrollato da RLS.
3. Le normali registrazioni CASHUP non ottengono accesso BRAIN.
4. Il registro audit non permette update/delete al client.
5. Le approvazioni registrano solo una decisione; non attivano pagamenti o azioni esterne.
6. Nessun agente, autonomia o automazione è attivo.
7. Pagamenti, trasferimenti, contratti, decisioni legali, accessi sensibili e azioni irreversibili richiedono approvazione umana.
8. La sicurezza assoluta non esiste: restano controlli Auth, MFA, hosting, GitHub, backup e revisione indipendente.

## Da completare prima di pubblicare
- Attivare Leaked Password Protection e MFA per il fondatore nelle impostazioni Supabase Auth.
- Verificare redirect URL, rate limits, CAPTCHA e che `private` non sia tra gli schemi esposti dalla Data API.
- Verificare MFA/secret scanning/push protection e branch protection in GitHub.
- Verificare backup e retention, quindi provare il ripristino.
- Pubblicare la console su hosting privato/protetto e verificare gli header HTTP reali.
- Eseguire il test end-to-end della dashboard e una revisione indipendente.

Il piano aggiornato è in [VERIFICATION.md](./VERIFICATION.md), la checklist in [security/SECURITY_CHECKLIST.md](./security/SECURITY_CHECKLIST.md) e il modello delle minacce in [security/THREAT_MODEL.md](./security/THREAT_MODEL.md). La query di sola lettura completa è `supabase/verification/verify_brain_complete_read_only.sql` e controlla anche il requisito AAL2.