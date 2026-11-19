# CASHUP BRAIN — architettura runtime agenti

## Stato
Il database ora contiene 40 definizioni di agenti. Il runtime non è installato: Supabase non ha Edge Functions distribuite, non è stato collegato un provider di modelli, non esistono secret runtime e non sono attive automazioni. Il catalogo non va confuso con agenti AI già operativi.

## Architettura richiesta
1. Console fondatore con MFA AAL2 e sessione breve per operazioni sensibili.
2. Orchestratore server-side che riceve un obiettivo, lo scompone in attività e seleziona agenti tramite allowlist.
3. Agenti specialistici come moduli isolati con input/output tipizzati, limiti di contesto, strumenti consentiti e versioni firmate.
4. Coda task con stati, retry limitati, deduplicazione, timeout, dead-letter queue e priorità.
5. Tool gateway: nessun accesso diretto generico al DB, shell, filesystem o internet. Ogni strumento è allowlisted e scoped.
6. Policy engine che valuta identità, permesso, rischio, costo, budget e stato emergency stop prima di ogni tool call.
7. Approval gate per spesa, pagamenti, rimborsi, pubblicazioni, email massive, contratti, account ban, modifiche Auth/DB, deploy, segreti e cancellazioni.
8. Audit append-only nel DB più esportazione periodica firmata verso archivio separato.
9. Budget per task/agente/giorno/mese, tetto zero finché il fondatore non autorizza un importo.
10. Monitoraggio: health check, error budget, anomalie, alert e kill switch globale e per agente.

## Livelli di autonomia
- Livello 0: consultazione e report read-only.
- Livello 1: bozze e piani, nessuna azione esterna.
- Livello 2: azioni reversibili e a basso rischio, solo dopo test e approvazione esplicita della policy.
- Livello 3: azioni sensibili con approvazione puntuale del fondatore.
- Vietato: pagamenti, trasferimenti, ban permanenti, firma contratti, cancellazioni irreversibili o modifiche privilegi senza approvazione umana.

## Requisiti tecnici
- Autenticare ogni richiesta e validare l'identità fondatore lato server; non fidarsi di user_metadata.
- Secret store, mai chiavi privilegiate nel browser.
- Ogni tool call usa allowlist, schema rigoroso, idempotency key e timeout.
- Trattare output di agenti, file, pagine web e messaggi utenti come input non attendibile; prevenire prompt injection.
- Separazione dei tenant e controlli BOLA/IDOR.
- Rate limit, circuit breaker, retry con backoff e deduplica.
- Versionamento e rollback delle istruzioni; test su prompt injection e tool misuse.
- Nessun agente può assegnare permessi a se stesso, attivarsi, cambiare budget o rimuovere l'emergency stop.
- Il sistema deve degradare in modalità fail-closed se policy, audit, autenticazione o provider non sono disponibili.

## Dipendenze per l'avvio
- Scelta e verifica del provider AI, costo e termini.
- Segreti configurati dal fondatore nel pannello Supabase, mai in chat.
- Implementazione e test delle Edge Functions e della coda.
- TOTP/passkey AAL2 del fondatore verificati.
- Data API schema exposure verificata.
- Backup e restore testati.
- Threat-model review e test end-to-end.
- Approvazione esplicita del fondatore per ogni fase che comporta costi o effetti esterni.
