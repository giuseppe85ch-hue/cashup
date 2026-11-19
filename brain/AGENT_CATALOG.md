# CASHUP BRAIN — catalogo specialistico

## Stato effettivo
Il catalogo contiene 40 ruoli (8 iniziali + 32 specialistici). Tutti hanno stato `planned`: sono definizioni registrate nel database, non processi AI in esecuzione. La dashboard esistente legge dinamicamente il catalogo e può mostrarli quando la console viene pubblicata e collaudata.

La migrazione `0013_expand_specialist_agent_catalog.sql` aggiunge 32 ruoli in modo idempotente (`ON CONFLICT DO NOTHING`). Non attiva agenti, non crea credenziali, non effettua chiamate a modelli e non avvia spese.

## Ruoli specialistici aggiunti
| Area | Ruoli |
|---|---|
| Direzione e prodotto | Strategia prodotto, Product Management |
| Tecnologia | Engineering, QA/Release, Infrastructure/DevOps |
| Sicurezza e difesa | Security, Fraud Detection, Anti-Piracy, Trust & Safety, Incident Response |
| Fiducia e regole | Privacy/Data, Legal & Compliance, IP & Brand |
| Economia | Finance, Cost Optimizer, Payments/Reconciliation |
| Crescita | Growth, Partnerships, Affiliate Operations, Ads Monetization, Marketing & Content |
| Utenti e community | Customer Support, Community Moderation |
| Espansione | International Expansion, Research Intelligence |
| Prodotto interattivo | Game Economy, Rewards & Loyalty |
| Governance | Analytics, Data Governance, Procurement/Vendor, Operations |
| Supporto fondatore | Founder Assistant |

## Permessi iniziali
- `read_only`: analisi, ricerche, report, bozze e piani.
- `approval_required`: anche quando un agente prepara una proposta operativa, nessuna azione esterna è autorizzata senza approvazione.
- Nessun agente ha permesso `limited` o stato `active` in questa fase.
- Nessun agente può modificare direttamente i saldi, attribuire punti, rimborsare, sospendere utenti, pubblicare contenuti, firmare contratti o spendere denaro.

## Regola di attivazione futura
Un ruolo diventa operativo soltanto dopo: runtime server-side, identità tecnica separata, strumenti allowlist, limiti di costo, test, log immutabili/esterni, approvazioni e kill switch. Attivare prima un agente e poi progettare i suoi limiti è vietato.
