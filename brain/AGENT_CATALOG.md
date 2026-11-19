# CASHUP BRAIN — catalogo specialistico

## Stato verificato (19 novembre 2026)
Il database contiene **550 ruoli specialistici** e **550 schede di specifica private**. Tutti i 550 sono planned/designed; **0 sono attivi** e nessuno ha runtime o provider collegato. I ruoli comprendono 35 ruoli iniziali e 515 specializzazioni aggiuntive distribuite nelle aree governance, strategia, prodotto, ingegneria, sicurezza, dati, ricerca AI, DevOps, qualità, finanza, crescita, marketing, affiliazioni, partnership, advertising, premi, gaming, supporto, Trust & Safety e internazionalizzazione.

Ogni scheda privata definisce missione, confini, criteri di accettazione, contratto input/output, allowlist strumenti vuota, budget massimo pari a 0 € e stato del ciclo di vita. Le schede sono conservate nello schema non esposto private; le policy negano l'accesso ai ruoli client. Il catalogo è metadata progettuale, non un insieme di processi AI in esecuzione.

## Permessi e limiti
- read_only: analisi, ricerche, report, bozze e piani.
- approval_required: prepara proposte operative ma non esegue azioni esterne.
- Tutti i nuovi ruoli sono planned; nessun agente ha stato active.
- Tutti i budget agent sono 0 € e gli strumenti consentiti sono una lista vuota.
- Nessun agente può modificare saldi, attribuire punti, rimborsare, sospendere utenti, pubblicare contenuti, firmare contratti o spendere denaro.

## Attivazione futura
Un ruolo può avanzare soltanto dopo runtime server-side, provider verificato, identità tecnica separata, strumenti allowlist, limiti di costo approvati, test, audit, kill switch, MFA fondatore e approvazione esplicita per ogni servizio a pagamento. Nessun ruolo può attivarsi da solo, cambiare budget o rimuovere l'arresto di emergenza.

## Migrazione
La migrazione 0014_agent_specifications_catalog_550.sql definisce in modo riproducibile il catalogo e le specifiche private. Non distribuisce Edge Functions, non configura chiavi, non avvia automazioni e non genera costi.
