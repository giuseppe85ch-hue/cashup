# CASHUP BRAIN — fondazione tecnica

Questa cartella contiene la preparazione tecnica di CASHUP BRAIN. La dashboard è un prototipo separato e non viene pubblicato automaticamente dal sito CASHUP.

## Stato verificato
- Il repository contiene il prototipo web CASHUP, autenticazione Supabase e PWA.
- Il lavoro BRAIN è sul ramo `cashup-brain-setup`; il ramo principale `main` non viene modificato.
- La migrazione `supabase/migrations/0001_brain_private_schema.sql` è stata eseguita manualmente nel progetto Supabase CASHUP.
- La migrazione `supabase/migrations/0002_brain_initial_catalog.sql` è stata eseguita dall'utente in Supabase e ha restituito `Success` il 19 novembre 2026. L'esito non è stato verificato direttamente tramite una connessione database.
- La migrazione `supabase/migrations/0003_private_founder_function.sql` è stata eseguita in Supabase. La verifica di sola lettura del 19 novembre 2026 ha confermato: schema e funzione `private` presenti, `SECURITY DEFINER` attivo, esecuzione negata ad `anon` e consentita ad `authenticated`, uso dello schema negato ad `anon` e consentito ad `authenticated`, vecchia funzione `public` assente e RLS + FORCE RLS attivi su tutte e sette le tabelle.
- La seconda migrazione inserisce otto schede di agenti in stato `planned` e impostazioni iniziali conservative: autonomia disattivata, spesa automatizzata zero, approvazione umana per azioni ad alto rischio e finanziarie, arresto di emergenza attivo.
- Le sette tabelle `brain_*` risultavano presenti dopo la prima migrazione.
- L'account del fondatore è stato inserito in `brain_founders`.
- `dashboard/index.html` contiene una console web iniziale per accesso fondatore, riepilogo, creazione attività, consultazione agenti, approvazioni, registro e visualizzazione in sola lettura delle impostazioni di sicurezza. Le impostazioni mancanti vengono indicate come non confermate, senza presentarle come sicure. Segnala anche eventuali errori di scrittura nel registro audit.
- La migrazione 0004 `least_privilege_hardening.sql` è stata preparata ma NON è stata eseguita: rende espliciti i privilegi minimi su tutte le tabelle BRAIN, limita `brain_founders` alla sola lettura e mantiene l'audit append-only. Prima di eseguirla, controllare che il progetto Supabase selezionato sia quello CASHUP.
- Sono stati aggiunti modello delle minacce e checklist in `security/`.
- La query completa è stata aggiornata per verificare i privilegi di scrittura di `authenticated` su `brain_founders` e i privilegi vietati su `brain_audit_log`.
- La dashboard non è ancora pubblicata né collaudata end-to-end. Non esistono ancora agenti autonomi attivi.

## Sicurezza e limiti
1. Nessuna chiave `service_role`, password o segreto AI nel browser o nel repository. La chiave publishable Supabase nel client è pubblica per progetto e l'accesso ai dati è demandato a RLS.
2. L'accesso alla console richiede login Supabase e verifica della riga attiva in `brain_founders`; le policy RLS devono continuare a essere la barriera effettiva.
3. Le normali registrazioni CASHUP non ottengono automaticamente accesso a BRAIN.
4. Il registro attività è append-only per il fondatore.
5. Le decisioni sulle approvazioni registrano solo approvato/rifiutato: non eseguono pagamenti né azioni esterne.
6. La console non avvia agenti e non esegue automazioni.
7. Pagamenti, trasferimenti, contratti, decisioni legali, accessi sensibili e azioni irreversibili richiedono approvazione umana.

## Piano di verifica
La checklist dettagliata dei controlli da svolgere insieme è in [VERIFICATION.md](./VERIFICATION.md). La query `supabase/verification/verify_brain_complete_read_only.sql` riunisce in un solo controllo catalogo agenti, impostazioni, RLS, privilegi effettivi di `anon`, privilegi minimi su `brain_founders` e audit append-only, e configurazione della funzione fondatore. È di sola lettura. I controlli principali della migrazione 0003 sono stati confermati dall'output Supabase fornito dal fondatore. Restano da completare la verifica del catalogo/impostazioni, i test reali della console e il test con account non autorizzato.

## Prossimi passaggi
1. Migrazioni 0001–0003 eseguite e controlli principali della 0003 confermati il 19 novembre 2026.
2. Esaminare ed eseguire la migrazione 0004 di privilegio minimo; poi rieseguire la query completa aggiornata.
3. Verificare direttamente nel database la presenza degli otto agenti e delle cinque impostazioni iniziali.
4. Revisionare il codice della dashboard e collaudare login fondatore e controlli RLS.
5. Testare con un account non autorizzato che non possa leggere o modificare dati BRAIN.
6. Integrare eventuali funzioni server-side con permessi minimi, limiti di costo, audit, test e approvazioni.
7. Pubblicare la console solo dopo revisione e collaudo, su percorso o sottodominio protetto e senza collegarla al deploy pubblico per errore.

## Non fare
- Non inserire UUID del fondatore, password, chiavi segrete o chiavi `service_role` nel codice client.
- Non collegare questa cartella al deploy Cloudflare finché il controllo di accesso e la separazione della console non sono stati testati.
- Non attivare pagamenti o automazioni esterne in questa fase.
