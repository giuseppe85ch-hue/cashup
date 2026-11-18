# CASHUP BRAIN — piano di verifica con il fondatore

Questo piano è una checklist di collaudo. Non abilita agenti, non esegue automazioni e non modifica il database.

## Già riportato dall'utente
- [x] Migrazione iniziale 0001 eseguita in Supabase con esito Success.
- [x] Sette tabelle `brain_*` viste in Supabase.
- [x] Account fondatore inserito in `brain_founders`.
- [x] Migrazione catalogo 0002 eseguita in Supabase con esito Success.
- [x] Il branch di lavoro resta separato da `main`.

## Da verificare insieme in Supabase

La query di sola lettura è stata preparata in `supabase/verification/verify_brain_read_only.sql`. Restituisce in un unico risultato gli agenti mancanti, eventuali agenti attivi, le impostazioni e lo stato RLS delle sette tabelle. Non modifica il database.
- [ ] Query di sola lettura: presenza degli otto agenti previsti.
- [ ] Query di sola lettura: presenza delle cinque impostazioni iniziali e valori conservativi.
- [ ] Confermare che `emergency_stop` sia true e `autonomy_enabled` sia false.
- [ ] Confermare che nessun agente sia nello stato `active`.
- [ ] Verificare policy RLS e accesso fondatore con test controllato.

## Da verificare insieme nella console, solo dopo i controlli database
- [ ] Login con account fondatore.
- [ ] Caricamento dei contatori e delle schede agente.
- [ ] Creazione di una attività di prova e presenza nel registro.
- [ ] Verificare che un account non autorizzato non possa leggere o modificare i dati BRAIN.
- [ ] Verificare che approvare/rifiutare una richiesta registri solo una decisione e non esegua azioni esterne.

## Vincoli fino al completamento dei test
- Nessun merge in `main`, nessun deploy Cloudflare e nessuna pubblicazione della console.
- Nessuna attivazione degli agenti o delle automazioni.
- Nessun pagamento, trasferimento, contratto o comunicazione esterna automatica.
- Non chiedere password, token o chiavi segrete in chat.
- Per test con account non autorizzato usare un account di prova controllato; non modificare o disattivare l'account principale.

## Limite operativo attuale
Non è disponibile in questa sessione una connessione diretta al database Supabase. Il risultato `Success` della migrazione 0002 è stato riferito dall'utente, ma i dati effettivi e le policy non sono ancora stati letti direttamente. Le verifiche che richiedono il pannello Supabase dovranno essere confermate insieme.
