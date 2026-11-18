# CASHUP BRAIN — fondazione tecnica

Questa cartella contiene la preparazione di CASHUP BRAIN. Non è collegata alla pubblicazione del sito e non deve essere distribuita automaticamente.

## Stato
- Il repository contiene il prototipo web CASHUP, autenticazione Supabase e PWA.
- Il ramo di lavoro è `cashup-brain-setup`; il ramo principale `main` non viene modificato.
- Questa prima fase prepara lo schema SQL con accesso negato per impostazione predefinita.
- La migrazione SQL è soltanto un file: **non è stata eseguita su Supabase**.
- Non esiste ancora una dashboard BRAIN funzionante né agenti autonomi attivi.

## Regole di sicurezza
1. Nessuna chiave `service_role`, password o segreto AI nel browser o nel repository.
2. L'accesso alle tabelle BRAIN è consentito soltanto agli utenti inseriti manualmente nella tabella `brain_founders` da un amministratore Supabase.
3. Le normali registrazioni CASHUP non ottengono automaticamente accesso a BRAIN.
4. Il log attività è append-only per gli utenti autenticati.
5. Pagamenti, trasferimenti, contratti, decisioni legali, accessi sensibili e modifiche irreversibili richiedono approvazione umana.
6. Prima di una dashboard reale: verificare l'UUID dell'account fondatore, eseguire la migrazione in Supabase, testare RLS con un account autorizzato e uno non autorizzato.

## Prossimi passaggi
1. Verificare l'UUID dell'account fondatore in Supabase Auth.
2. Eseguire la migrazione SQL dopo aver controllato il progetto corretto.
3. Inserire manualmente l'UUID autorizzato in `brain_founders`.
4. Testare che un account CASHUP normale non possa leggere o modificare dati BRAIN.
5. Solo dopo i test, costruire una dashboard privata in una cartella separata e proteggerla con la verifica server-side.
6. Integrare agenti uno alla volta, con permessi minimi, limiti di costo, log e approvazioni.

## Non fare
- Non aggiungere una password segreta o un UUID fondatore nel codice client.
- Non collegare questa cartella al deploy Cloudflare finché non è stato progettato e testato il controllo di accesso.
- Non attivare pagamenti o automazioni esterne in questa fase.
