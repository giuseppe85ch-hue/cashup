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
- `dashboard/index.html` contiene una prima console web per accesso fondatore, riepilogo, creazione attività, consultazione agenti, approvazioni e registro.
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
La checklist dettagliata dei controlli da svolgere insieme è in [VERIFICATION.md](./VERIFICATION.md). Le query SQL di verifica, entrambe di sola lettura, sono in `supabase/verification/`: `verify_brain_read_only.sql` per catalogo/impostazioni/RLS e `verify_brain_security_read_only.sql` per policy/privilegi/funzione fondatore nello schema privato (dopo 0003). I controlli principali della migrazione 0003 sono stati confermati dall'output Supabase fornito dal fondatore. Restano da completare la verifica del catalogo/impostazioni, i test reali della console e il test con account non autorizzato.

## Prossimi passaggi
1. Migrazione 0003 eseguita e controlli principali confermati il 19 novembre 2026.
2. Verificare direttamente nel database la presenza degli otto agenti e delle cinque impostazioni iniziali.
3. Revisionare il codice della dashboard e collaudare login fondatore e controlli RLS.
4. Testare con un account non autorizzato che non possa leggere o modificare dati BRAIN.
5. Integrare eventuali funzioni server-side con permessi minimi, limiti di costo, audit, test e approvazioni.
6. Pubblicare la console solo dopo revisione e collaudo, su percorso o sottodominio protetto e senza collegarla al deploy pubblico per errore.

## Non fare
- Non inserire UUID del fondatore, password, chiavi segrete o chiavi `service_role` nel codice client.
- Non collegare questa cartella al deploy Cloudflare finché il controllo di accesso e la separazione della console non sono stati testati.
- Non attivare pagamenti o automazioni esterne in questa fase.
