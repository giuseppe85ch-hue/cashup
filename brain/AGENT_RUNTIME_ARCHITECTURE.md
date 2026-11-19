# CASHUP BRAIN — architettura runtime agenti

## Stato verificato (19 novembre 2026)
Il database contiene **550 ruoli** e **550 schede private** con missione, confini, test di accettazione, contratti input/output, strumenti consentiti e limiti di spesa. Nel registro `public.brain_agents` tutti i 550 ruoli sono `planned`; nelle specifiche `private.brain_agent_specs` tutte le 550 schede sono `designed`; **0 agenti sono attivi**. È distribuita una sola Edge Function, `cashup-brain-status` (versione 1, JWT obbligatorio): legge lo stato in modalità read-only e richiede accesso fondatore. La chiamata autenticata end-to-end non è ancora stata collaudata. Non risultano provider/modelli collegati o segreti runtime configurati. Il catalogo non va confuso con 550 agenti AI già operativi.

## Obiettivo di scala
I 550 ruoli sono suddivisi in 20 aree specialistiche, con un orchestratore previsto al centro. Possono condividere un numero ridotto di modelli e infrastruttura; non richiedono 550 abbonamenti separati. L'effettiva capacità dipenderà da provider, limiti tecnici, costi, benchmark e qualità dei risultati. Non è possibile promettere prestazioni top illimitate a costo zero.

## Regole di sicurezza già fissate nel catalogo
- Ogni scheda ha missione, confini, test di accettazione e contratti input/output.
- Allowlist strumenti vuota; budget massimo per agente 0 €.
- Schede private in schema non esposto; anon, authenticated e service_role non hanno accesso.
- Tutti i ruoli restano pianificati; nessuna esecuzione automatica.
- Nessun agente può attivarsi, concedersi permessi, aumentare il budget o disabilitare l'emergency stop.
- Le azioni finanziarie, contrattuali, legali, irreversibili e ad alto rischio restano subordinate all'approvazione del fondatore.

Le migrazioni 0014 e 0015 registrano il catalogo, i dettagli dei 515 ruoli specialistici e una policy default-deny per l'accesso client alle schede private.

## Architettura runtime da completare
1. Console fondatore con MFA AAL2 e sessione breve per operazioni sensibili.
2. Orchestratore server-side che scompone gli obiettivi e seleziona agenti tramite allowlist.
3. Moduli specialistici isolati con versioni, input/output tipizzati e benchmark.
4. Coda task con deduplicazione, timeout, retry limitati e dead-letter queue.
5. Tool gateway con permessi minimi; niente accesso generico a DB, shell o filesystem.
6. Policy engine che verifica identità, permessi, rischio, budget e emergency stop.
7. Approvazione umana per spese, pagamenti, rimborsi, pubblicazioni, contratti, ban permanenti, accessi sensibili, deploy e cancellazioni.
8. Audit append-only e backup verificati.
9. Monitoraggio, alert, rate limit, circuit breaker e kill switch globale/per agente.
10. Test end-to-end, prompt injection, abuso strumenti, isolamento tenant e recupero.

## Dipendenze per l'avvio
- MFA AAL2 del fondatore: non ancora configurata/verificata.
- Verifica dashboard Data API schema exposure e impostazione di auto-exposure.
- Backup cifrato e prova di ripristino.
- Provider AI: non selezionato; nessun costo o segreto è autorizzato.
- Edge Functions: è distribuito soltanto `cashup-brain-status`, servizio read-only; orchestratore, coda e runtime degli agenti non sono distribuiti.
- Test end-to-end e revisione indipendente.
- Ogni eventuale costo richiede preventivo e consenso esplicito del fondatore.

## Regola economica
Budget automatico massimo = **0 €**. Nessun provider a pagamento, credito API, abbonamento, piano superiore o servizio con rinnovo sarà attivato senza autorizzazione esplicita.
