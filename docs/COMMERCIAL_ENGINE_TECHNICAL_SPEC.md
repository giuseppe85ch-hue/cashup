# CASHUP — Specifica tecnica del motore commerciale (Affiliate & Ads)

**Stato:** specifica per sviluppo; nessuna funzione descritta qui è dichiarata operativa.

## Obiettivo

Costruire un motore condiviso per catalogare offerte e partner, instradare gli utenti verso i merchant, attribuire correttamente gli eventi, riconciliare commissioni e cashback, e gestire gli spazi pubblicitari sponsorizzati.

## Principi non negoziabili

- Il checkout standard resta sul sito/app del merchant, salvo integrazioni contrattuali future.
- CASHUP non custodisce fondi merchant né promette cashback non finanziato.
- Nessun click o ordine client-side è sufficiente a generare un pagamento o un premio.
- Le conversioni arrivano da callback/postback o report ufficiali del network, con verifica firma/secret e idempotenza.
- Rispetto delle regole di ciascun merchant su cashback, coupon, app, paid traffic, incentivi e disclosure.
- Separare ledger commissioni CASHUP, cashback utente, punti promozionali e movimenti monetari.
- Nessuna dashboard deve mostrare ricavi stimati come incassi effettivi.

## Moduli funzionali

### 1. Partner registry
Dati: partner, network, merchant, Paesi, lingue, categorie, URL ufficiali, stato approvazione, referente, termini/versione, contatti e date di revisione.

### 2. Offer catalog
Dati: merchant, titolo, descrizione, immagini autorizzate, prezzo/valuta, prezzo di confronto se verificato, Paesi, date di validità, condizioni, link di destinazione, deeplink, network/program ID, commissione indicativa (mai garantita), regole cashback, disclosure, data ultimo aggiornamento e stato.

Gli aggiornamenti di prezzo/disponibilità devono provenire da feed/API o fonti autorizzate. Non raschiare dati dove vietato. Nascondere offerte scadute o non aggiornate.

### 3. Affiliate click routing
- Generare un click ID casuale e non contenente dati personali.
- Associare click a sessione/consenso e campagna con minimizzazione dei dati.
- Costruire tracking URL solo secondo specifiche network.
- Applicare redirect controllato e allowlist dei domini merchant per evitare open redirect.
- Registrare timestamp, offer ID, partner ID, market, placement, consent state e click ID secondo retention definita.
- Non inserire email, telefono, nome o dati salute nei subID.

### 4. Conversion ingestion
- Endpoint separato per ogni provider o adapter normalizzato.
- Verificare HMAC/firma/secret, timestamp, provider event ID e schema.
- Idempotenza con unique(provider, provider_event_id).
- Gestire stati pending, approved, rejected, reversed, paid.
- Conservare raw payload minimizzato/cifrato solo se necessario e con retention.
- Riconciliare click ID, commission amount, currency, order reference pseudonima e merchant.
- Eventi non verificabili vanno in quarantena, mai in cashback spendibile.

### 5. Cashback policy engine
- Il merchant/program deve autorizzare espressamente cashback e modalità di promozione.
- Regola versionata per Paese, merchant, categoria e campagna.
- Quota utente definita sulla commissione netta prevista, ma maturazione solo dopo approvazione effettiva.
- Riserva per storni, rimborsi, chargeback, fee e costi.
- Tetto per ordine, utente, giorno e periodo; regole anti-abuso.
- Stati: non maturato, pending, approved, available, paid/redeemed, reversed, expired.
- Il totale cashback disponibile non può superare le passività finanziate e riconciliate.
- Non presentare punti demo o punti promozionali come euro.

### 6. Advertising inventory
Inventario: banner, card sponsorizzate, offerte in evidenza, categorie sponsorizzate, newsletter, contenuti e sponsorship.
Ogni unità contiene: placement, formato, dimensioni, Paesi, lingua, audience criteria consentiti, date, cap frequenza, sponsor, creatività approvata, disclosure, URL, pricing model, budget, delivery metrics e stato.
Stati: draft, review, approved, scheduled, live, paused, ended, rejected.
Non vendere impression garantite senza dati e capacità di delivery.

### 7. Campaign reporting
Metriche separate:
- impression servite e viewable (quando misurabile);
- click validi e CTR;
- conversioni pending/approved/reversed;
- vendite/GMV del merchant (non ricavo CASHUP);
- commissioni stimate, approvate e incassate;
- fee pubblicitarie fatturate/incassate;
- cashback pending, approved e pagato;
- costi e margine netto.

### 8. Merchant self-service (fase successiva)
- Pagina pubblica "Collabora con CASHUP".
- Form lead con dati minimi, consenso e privacy notice.
- Dashboard merchant solo dopo verifica e accordo.
- Upload creatività e schede offerta con revisione CASHUP.
- Richiesta di preventivo e proposta di commissione.
- Nessuna pubblicazione automatica senza approvazione editoriale e commerciale.

## Schema dati concettuale

Tabelle da progettare solo dopo mappatura schema esistente e review RLS:
- commercial_partners
- affiliate_networks
- merchant_programs
- merchant_markets
- offers
- offer_terms_versions
- affiliate_clicks
- affiliate_conversions
- affiliate_commission_ledger
- cashback_rules
- cashback_ledger (separato dall'attuale points ledger)
- ad_placements
- ad_campaigns
- ad_creatives
- ad_delivery_events
- partner_leads
- commercial_reconciliation_runs
- commercial_audit_log

Non creare tabelle duplicate se esistono già entità equivalenti: prima ispezionare schema, RPC, edge functions, RLS e dipendenze client.

## Sicurezza e privacy

- RLS su ogni tabella esposta; privilegi minimi e policy testate con anon, authenticated e ruoli server.
- Service role esclusivamente server-side e mai nel client.
- Secrets in Supabase Vault/Edge Function secrets, non nel repository.
- Rate limit e protezione replay per postback.
- Audit trail append-only per approvazioni, cambi termini, accrediti e storni.
- Minimizzazione e retention dati; consenso cookie/marketing dove richiesto.
- Link sponsorizzati e affiliati dichiarati chiaramente.
- Moderazione e controlli per categorie vietate/regolamentate e claim ingannevoli.
- Nessuna modifica alle impostazioni Supabase o ai grant in questa fase documentale.

## Sequenza di sviluppo raccomandata

1. Inventario schema e codice attuale; identificare cosa esiste già.
2. Definire provider/network adapter e accordi iniziali.
3. Implementare partner registry e catalogo offerte.
4. Implementare redirect/click ID e consent handling.
5. Implementare conversion postback con test replay, firma e duplicati.
6. Implementare commission ledger e riconciliazione.
7. Implementare cashback solo dopo approvazione legale/commerciale e test di copertura finanziaria.
8. Implementare inventory ads, campagne e disclosure.
9. Implementare report merchant e listino solo con metriche reali.
10. Eseguire test di sicurezza, privacy, frodi, rimborsi e carico prima del rilascio.

## Criteri di accettazione

- Nessuna conversione non firmata o duplicata genera credito.
- Ogni conversione può essere tracciata a un programma e a termini validi alla data del click.
- Cashback spendibile solo su conversioni approvate e riconciliate.
- Storno successivo genera movimento compensativo, non cancellazione silenziosa.
- Merchant non può vedere dati di altri merchant né dati personali non necessari degli utenti.
- Utente vede chiaramente condizioni, disclosure, stato e scadenza del cashback.
- Report distingue GMV, commissioni, fee pubblicitarie, cashback e margine.
- Campagne non approvate non possono andare live.
- Ogni modifica è coperta da test e audit.

## Dipendenze da approvazione del titolare

Account di affiliazione, accettazione termini, contratti, prezzi, budget, pagamenti, dati fiscali, provider pubblicitari e abilitazione cashback richiedono approvazione esplicita. Questa specifica non autorizza tali azioni.
