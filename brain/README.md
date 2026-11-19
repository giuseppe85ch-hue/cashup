# CASHUP BRAIN — fondazione tecnica

Questa cartella contiene la preparazione tecnica di CASHUP BRAIN. La dashboard è separata dal sito CASHUP e non viene pubblicata automaticamente. Il repository GitHub è attualmente pubblico: anche codice e documentazione sono leggibili da chiunque.

## Stato verificato — 19 novembre 2026
- Progetto Supabase CASHUP `fzcricigqqpzcujrenkf`, stato ACTIVE_HEALTHY.
- Migrazioni 0001–0003 già eseguite; migrazioni 0004–0013 applicate. Le RPC pubbliche sono entrambe SECURITY INVOKER; i trigger audit interni sono SECURITY DEFINER in `private`.
- Sette tabelle BRAIN con RLS e FORCE RLS, nove policy BRAIN dopo aver aggiunto l'inserimento controllato delle attività.
- Funzione `private.brain_is_founder()` SECURITY DEFINER con `search_path` vuoto; esecuzione negata ad anon, consentita ad authenticated; richiede claim JWT `aal2`; vecchia funzione pubblica assente.
- Zero privilegi diretti per anon e service_role sulle tabelle BRAIN. `brain_founders` è sola lettura; `brain_agents`, `brain_memory` e `brain_settings` sono read-only; `brain_tasks` consente SELECT e INSERT solo delle colonne title/description/priority con RLS; il client non può impostare status/sector/created_by. `daily_steps` è read-only per il browser finché non esiste un flusso server verificato; `profiles` consente solo insert id/display_name e update display_name. `brain_audit_log` consente solo SELECT; audit viene scritto soltanto dai trigger DB. `brain_approvals` consente SELECT e UPDATE solo della colonna status.
- Test controllato: l'identità del fondatore vede agenti e impostazioni; un'identità authenticated non fondatrice non vede agenti, impostazioni o audit.
- 550 ruoli registrati in `public.brain_agents` (tutti `planned`) e 550 specifiche private in `private.brain_agent_specs` (tutte `designed`); zero agenti attivi e nessun runtime AI distribuito. Cinque impostazioni conservative: autonomia false, emergency stop true, spesa automatizzata zero, approvazione umana richiesta per azioni finanziarie e ad alto rischio.
- Default privileges del ruolo postgres nello schema public revocati per nuove tabelle, sequenze e funzioni; EXECUTE sulle nuove funzioni creato da postgres revocato anche a PUBLIC. I default ACL di `supabase_admin` in `public` concedono privilegi predefiniti ai ruoli API; sono gestiti da Supabase e non sono modificabili dal ruolo `postgres` del progetto. Nessun oggetto public è attualmente posseduto da quel ruolo; non installare estensioni in `public` e disattivare l'esposizione automatica di nuove tabelle.
- Migrazione 0005 ottimizza le policy che usano auth.uid() e aggiunge indici sulle nove chiavi esterne segnalate. Il Performance Advisor non segnala più FK non indicizzate o RLS initplan; rimangono solo avvisi informativi per indici non ancora utilizzati.
- Il Security Advisor segnala ancora Leaked Password Protection disattivata nelle impostazioni Auth.

## Dashboard
- `dashboard/index.html`, `dashboard/styles.css`, `dashboard/app.js`: console web iniziale per accesso fondatore, riepilogo, creazione attività, consultazione agenti, approvazioni, audit e impostazioni.
- Il client usa solo la chiave Supabase publishable; nessuna service_role key o password è inserita nel codice.
- La versione Supabase JS è fissata a `2.119.1` tramite esm.sh bundle; aggiornamenti deliberati e verificati.
- La dashboard richiede una sessione MFA AAL2 prima di mostrare dati BRAIN e include un flusso TOTP per registrazione/verifica del fattore. Il fondatore non ha ancora fattori MFA registrati: il flusso deve essere completato e collaudato nel browser. Il database è stato testato: sessione AAL1 negata, fondatore AAL2 autorizzato, non fondatore AAL2 negato.
- Il file `_headers` si trova nella root del repository: CSP e header base si applicano a `/*`, mentre `/brain/dashboard` e `/brain/dashboard/*` aggiungono no-store e noindex. Gli header saranno effettivi solo quando il sito sarà pubblicato da una root che include quel file; la risposta HTTP reale non è ancora stata verificata.
- La dashboard non è stata ancora pubblicata né collaudata end-to-end nel browser. Trigger database registrano automaticamente ogni creazione attività e ogni decisione di approvazione nella stessa transazione; la RPC di creazione attività è SECURITY INVOKER con controlli espliciti su identità, fondatore, AAL2 e input; anche la RPC approvazioni è SECURITY INVOKER. Nessuna funzione SECURITY DEFINER è presente nello schema public.

## Sicurezza e limiti
1. RLS e grants sono la barriera effettiva ai dati; la chiave publishable è pubblica e non è un segreto.
2. L'accesso BRAIN richiede una riga attiva in `brain_founders` e viene ricontrollato da RLS.
3. Le normali registrazioni CASHUP non ottengono accesso BRAIN.
4. Il registro audit non permette update/delete al client.
5. Le approvazioni registrano solo una decisione; non attivano pagamenti o azioni esterne.
6. Nessun agente, autonomia o automazione è attivo.
7. Pagamenti, trasferimenti, contratti, decisioni legali, accessi sensibili e azioni irreversibili richiedono approvazione umana.
8. La sicurezza assoluta non esiste: restano controlli Auth, MFA, hosting, GitHub, backup e revisione indipendente.

## CASHUP — protezione dati applicativi
- La migrazione 0012 ha disabilitato gli inserimenti diretti client in `daily_steps`: non è possibile simulare passi via API browser. La registrazione reale dovrà essere implementata con una fonte verificata lato server.
- `points_ledger`, `affiliate_clicks` e `commissions` sono read-only per authenticated; il client non può attribuire punti, clic o commissioni.
- Il profilo può essere creato/aggiornato solo nei campi consentiti; `id` e `created_at` non sono aggiornabili dal client.

## Web client hardening
- `index.html` non contiene più script, stili o handler inline; usa `app.js` e `styles.css` separati.
- La CSP strict e gli header anti-framing/HSTS sono preparati in `_headers`; diventano effettivi solo dopo deploy Pages e verifica HTTP reale.
- SDK Supabase web fissato a una versione esatta; il service worker limita il fallback offline alle navigazioni same-origin e non intercetta le API esterne.
- La registrazione dall'interfaccia richiede 12 caratteri; va impostato lo stesso minimo lato Supabase Auth per impedire bypass via API diretta.

## Da completare prima di pubblicare
- MFA TOTP del fondatore: il flusso è pronto, ma il fondatore deve registrare il proprio autenticatore e verificare il codice.
- Leaked Password Protection non risulta attiva; l'organizzazione è sul piano Free e non è stato richiesto alcun upgrade. Mantenere una password lunga, unica e custodita in un password manager.
- Verificare redirect URL, rate limits, CAPTCHA e verificare nella Dashboard che `private` NON sia tra gli schemi esposti dalla Data API; il catalogo SQL non permette di confermare la lista effettiva.
- Verificare MFA/secret scanning/push protection e branch protection in GitHub. Il workflow statico a permessi minimi ha completato con SUCCESS il run #92 sul commit `d6e1e31c09681371681bb5b105a4c68e51b002dc` (19 novembre 2026). Il controllo copre sintassi JS, manifest, assenza di segreti server nel codice browser, assenza di script/eventi inline e postura delle RPC critiche; non sostituisce secret scanning completo, test runtime o revisione indipendente.
- Il piano Free non include backup automatici: esportare manualmente database e dati Auth e conservare copie cifrate fuori dal progetto; provare il ripristino in ambiente separato prima del rilascio.
- Pubblicare la console su hosting privato/protetto e verificare gli header HTTP reali.
- Eseguire il test end-to-end della dashboard e una revisione indipendente.

Il piano per marchio, copyright, segreti commerciali e anti-impersonificazione è in [IP_PROTECTION_PLAN.md](./IP_PROTECTION_PLAN.md). Le verifiche manuali residue sono elencate in [RELEASE_GATES.md](./RELEASE_GATES.md). Il piano aggiornato è in [VERIFICATION.md](./VERIFICATION.md), la checklist in [security/SECURITY_CHECKLIST.md](./security/SECURITY_CHECKLIST.md) e il modello delle minacce in [security/THREAT_MODEL.md](./security/THREAT_MODEL.md). Il catalogo agenti è descritto in `AGENT_CATALOG.md`; anti-pirateria e gestione abusi in `ANTI_PIRACY_AND_ABUSE.md`; runtime e orchestrazione in `AGENT_RUNTIME_ARCHITECTURE.md`. I 35 agenti sono soltanto registrati, non eseguono ancora compiti AI.

La query di sola lettura completa è `supabase/verification/verify_brain_complete_read_only.sql` e controlla anche il requisito AAL2.