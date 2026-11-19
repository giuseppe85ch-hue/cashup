# CASHUP — anti-pirateria, anti-bypass, antifrode e protezione account

## Stato attuale
CASHUP è ancora un prototipo: i pacchetti a pagamento, i pagamenti reali e gli entitlement commerciali non sono ancora implementati. Non esiste quindi un sistema di licenze da verificare o un bypass di pacchetti già attivi da bloccare. Il client non è una fonte attendibile per punti, commissioni o passi: le scritture dirette del browser sono state revocate per le tabelle interessate.

Questo documento definisce i requisiti obbligatori prima di introdurre pacchetti premium, abbonamenti, giochi a pagamento o premi monetari.

## Modello anti-pirateria richiesto
1. **Server decides, client displays.** Il client non decide mai se un pacchetto è premium, pagato, sbloccato o scaduto. Non fidarsi di flag in JavaScript, localStorage, parametri URL, file APK modificati o risposte client.
2. **Entitlement server-side.** Tabella privata con user, prodotto, stato, inizio/fine, origine, identificativo acquisto, revoca, versione termini e timestamp. Nessun INSERT/UPDATE/DELETE dal browser.
3. **Verifica provider.** Verificare acquisti con API ufficiali del negozio/piattaforma (Google Play, Apple App Store o provider scelto) oppure webhook firmati del processore. Mai fidarsi di screenshot, ricevute inviate senza verifica, prezzi client o callback non firmati.
4. **Firma e replay protection.** Verificare firma, issuer, audience, timestamp, scadenza, ambiente, prodotto e destinatario; usare idempotency key uniche e registrare eventi già elaborati. Rifiutare replay, token scaduti, prodotti sconosciuti, ambiente di test in produzione e account non corrispondenti.
5. **Ciclo di vita.** Gestire acquisto, rinnovo, scadenza, rimborso, chargeback, revoca, cambio account e ripristino acquisti. Le notifiche sono almeno-una-volta: deduplicare e non assumere ordine cronologico.
6. **Nessun segreto nel client.** Chiavi provider, segreti webhook, service-role/secret key e chiavi di firma solo in secret store server-side; mai in HTML, JS, APK o repository.
7. **Integrità app.** Distribuzione da canali ufficiali, firma dei pacchetti, controllo versione minima e segnali di integrità dispositivo/app. I segnali di integrità sono indicatori di rischio, non prova unica per bannare.
8. **API enforcement.** Ogni endpoint che consegna contenuti premium o esegue operazioni a pagamento verifica entitlement lato server ad ogni richiesta rilevante. Non basta nascondere un pulsante.
9. **Watermark e tracciabilità.** Per contenuti digitali di valore valutare watermark individuali e log di download; raccogliere solo dati proporzionati e dichiarati.
10. **Test anti-bypass.** Testare manomissione JS, chiamate REST dirette, replay webhook, acquisti rimborsati, account diversi, downgrade, token scaduti, clock alterato, device non integro e concorrenza.

## Anti-frode e protezione account
- Rate limiting per IP, account, sessione e azione; soglie adattive e backoff.
- Rilevamento credential stuffing, password spraying, bot, referral farming, multi-account abuse, spoofing passi, manipolazione punti, coupon abuse, chargeback e account takeover.
- Sessioni sensibili con MFA, revoca sessioni e re-authentication.
- Protezioni su password reset, signup, OTP e cambio email; CAPTCHA/attestation dove opportuno.
- Log append-only con identificativi evento, data, azione, esito, motivo e riferimento alle prove. Non registrare password, OTP, token o dati di pagamento completi.
- Alert al fondatore e coda di revisione con gravità, confidenza, impatto, prove e azione proposta.
- Non basare una sanzione su IP condiviso, VPN, device fingerprint o singolo punteggio automatico.

## Sospensione, ban e lista di blocco
La terminologia è **sospensione temporanea**, **ban permanente** o **denylist/lista di blocco**. Il sistema deve distinguere:
1. Rate limit o step-up MFA per rischio basso/moderato.
2. Limitazione temporanea della singola funzione sospetta.
3. Quarantena temporanea dell'account quando esistono segnali multipli forti.
4. Revisione umana con prove e motivazione.
5. Ban permanente soltanto per violazioni gravi confermate, con possibilità di ricorso e revisione.

L'AI può segnalare e raccomandare, non emettere ban permanenti da sola. Non bloccare automaticamente account legittimi per un falso positivo. Conservare audit, durata, motivazione, operatore, data di riesame e canale di ricorso. Le misure devono essere coerenti con termini, privacy, tutela del consumatore e legge applicabile.

## Cosa non è ancora implementato
- Nessun prodotto/pacchetto premium attivo.
- Nessun provider di pagamento collegato.
- Nessun webhook acquisti, verifica ricevute, entitlement API o revocation worker.
- Nessuna tabella account-ban, case management o appeal.
- Nessun sistema automatico di rischio, rate limiting applicativo o notifica antifrode.
- Nessun ban o sospensione è stato applicato ad account reali.

## Gate prima della vendita
Non vendere pacchetti finché non sono completati provider e webhook verificati, ledger entitlement server-side, enforcement su ogni endpoint, refund/revocation, test anti-replay, audit, supporto e ricorso. Prima di allora, qualsiasi schermata premium è solo dimostrativa e non deve promettere sblocchi reali.
