# CASHUP — Registro di sviluppo

**Aggiornamento:** 20 novembre 2026  
**Repository:** https://github.com/giuseppe85ch-hue/cashup  
**Sito pubblico:** https://cashup-859.pages.dev/

Gli stati sono rigorosi: **Pianificato**, **In sviluppo**, **Verificato**, **Operativo**. La presenza di codice non equivale a una funzione collaudata o pronta per gli utenti.

## 1. Piattaforma web e account

| Area | Stato | Evidenza / lavoro residuo |
|---|---|---|
| Sito CASHUP pubblicato | Operativo | Build web disponibile su Cloudflare Pages; verificare a ogni release |
| Registrazione/accesso email Supabase | Verificato | Test utente già riuscito; ripetere test end-to-end pre-release |
| Tabella profili e policy RLS | Verificato | Salvataggio profilo riuscito; audit sicurezza prima del lancio |
| Home, Passi, Premi, Wallet, Profilo | In sviluppo | Interfaccia prototipo; saldo e premi dimostrativi |
| Wallet con movimenti reali | Pianificato | Ledger, riconciliazione, controlli, provider e verifiche |
| Referral e pagamenti referral | Pianificato | Regole antifrode, limiti, termini e pagamenti reali |
| Negozi, affiliate e offerte | Pianificato | Servono account partner, accordi e feed/offerte verificati |

## 2. CASHUP STEPS e salute/attività

| Area | Stato | Evidenza / lavoro residuo |
|---|---|---|
| Progetto integrazione Health Connect / HealthKit | In sviluppo | Bridge Expo presente; permessi e compatibilità da provare su dispositivi fisici |
| Conteggio passi reale end-to-end | Pianificato | Non dichiararlo operativo prima dei test Android e iOS |
| Limite 100 punti giornalieri | In sviluppo | Regole backend presenti; verificare flusso completo e antifrode |
| Premi realmente riscattabili | Pianificato | Mancano finanziamento partner, catalogo verificato e redemption |
| Notifiche locali native | In sviluppo | Codice presente; test installazione, permessi e pianificazione su device |

## 3. Giochi e cataloghi

| Area | Stato | Evidenza / lavoro residuo |
|---|---|---|
| Catalogo concettuale giochi | Verificato | README registra 10.000 concetti in nove file JSON |
| Categorie giochi | In sviluppo | README registra 100 categorie con voci e 500 pianificate, per 600 previste |
| Quattro prototipi giocabili | Verificato | Reflexes, Memory, Math Challenge, Quick Quiz |
| Salvataggio locale punteggi/partite | Verificato | Prototipi con persistenza locale |
| Sincronizzazione cloud progressi | In sviluppo | Modulo Supabase presente; test end-to-end, RLS e integrità da completare |
| Anticheat e premi monetari nei giochi | Pianificato | Non attribuire premi in denaro a punteggi non verificati |
| Catalogo ampio di giochi realmente giocabili al lancio | Pianificato | I 10.000 concetti non sono 10.000 giochi finiti; serve piano di produzione e QA |

## 4. Backend, sicurezza e monetizzazione

| Area | Stato | Evidenza / lavoro residuo |
|---|---|---|
| Supabase Auth e profili | Verificato | Accesso email e profilo già provati |
| RLS sulle tabelle utente | In sviluppo | Policy presenti; audit completo di tutte le tabelle e funzioni |
| Ledger punti e missioni verificate | In sviluppo | Oggetti backend presenti; test di sicurezza, duplicati e riconciliazione |
| Verifica ricompense pubblicitarie | In sviluppo | Edge Function presente, ma provider/ID/secret non configurati; endpoint non operativo |
| Rete pubblicitaria reale | Pianificato | Selezione partner, account, privacy, callback e test |
| Affiliazioni e sponsor | Pianificato | Nessun partner va presentato come attivo senza accordo |
| Pagamenti, cashback e prelievi | Pianificato | Provider, verifiche, compliance, antifrode e test necessari |

## 5. Android, iOS e PWA

| Area | Stato | Evidenza / lavoro residuo |
|---|---|---|
| Manifest e service worker PWA | Verificato | PWABuilder aveva segnalato manifest pronto per packaging |
| Esperienza PWA standalone | In sviluppo | Verificare installazione e apertura autonoma su browser/device |
| Wrapper Expo WebView | In sviluppo | App.js presente; non equivale a release stabile |
| APK Android release | In sviluppo | In passato APK ha mostrato errore di caricamento bundle; non distribuire |
| Workflow CI Android | In sviluppo | Workflow configura build release e avvio su emulatore; controllare un run riuscito e log prima di dichiarare superato |
| Test Android su dispositivo fisico | Pianificato | Health Connect, notifiche, avvio, login, stabilità e consumi |
| Build e test iOS | Pianificato | Richiede ambiente Apple idoneo, build nativa e test HealthKit |
| Pubblicazione store | Pianificato | Firma, asset, privacy, dichiarazioni e approvazioni store |

## 6. Completezza cataloghi e portafoglio

| Area | Stato | Evidenza / lavoro residuo |
|---|---|---|
| Master Plan ecosistema | Verificato | Questo documento raccoglie il perimetro e le decisioni note |
| Cataloghi ampi per ogni sezione al lancio | Pianificato | Definire copertura, fonti, licenze, qualità e soglie per ciascun prodotto |
| App specializzate e giochi motoristici | Pianificato | Specifiche in Master Plan; richiedono design, sviluppo, contenuti, licenze e QA |
| Internazionalizzazione completa | Pianificato | Traduzioni, valute, pagamenti, supporto e compliance paese per paese |
| Fonti di ricavo diversificate | Pianificato | Costruire e validare ogni canale, con unit economics e partner reali |

## 7. Prossime priorità operative

1. **Stabilizzare la build nativa Android**: controllare CI, bundle, avvio su emulatore e successivamente dispositivo fisico. Nessun nuovo APK da installare finché il controllo automatico non è superato.
2. **Eseguire test end-to-end della piattaforma web**: registrazione, accesso, profilo, sessione, errori e sicurezza.
3. **Verificare backend e RLS**: punti, missioni, progressi e protezione da richieste duplicate o manipolate.
4. **Attivare CASHUP STEPS realmente**: Health Connect e HealthKit su dispositivi supportati, permessi, limiti e antifrode.
5. **Definire il primo perimetro commerciale operativo**: partner, pubblicità, offerte e redemption con condizioni confermate.
6. **Piano cataloghi di lancio**: quantità e copertura per categoria, fonti dati lecite, contenuti realmente disponibili e aggiornamento.
7. **Piano economico 300.000 €**: modello per fatturato, margine e utile netto; ipotesi e scenari espliciti, senza promesse.
8. **Preparazione internazionale**: lingue, valute, pagamenti, privacy, termini, assistenza e requisiti locali.

## 8. Regole di controllo

- Aggiornare questo registro dopo ogni modifica rilevante al repository.
- Non trasformare Pianificato in Operativo senza prove.
- Conservare le decisioni precedenti; aggiungere nuove specifiche invece di sovrascriverle.
- Non spendere, sottoscrivere servizi o accettare accordi senza approvazione esplicita.
- Prima di chiedere all'utente operazioni sul telefono, esaurire i controlli che si possono svolgere in autonomia.


## 9. Nuovi requisiti commerciali emersi e da portare in sviluppo

| Area | Stato | Evidenza / lavoro residuo |
|---|---|---|
| CASHUP MARKET come grande vetrina internazionale affiliata | Pianificato | Requisito aggiunto: assortimento generalista molto ampio, ricerca e schede prodotto |
| Acquisti indirizzati ai negozi/marketplace partner | Pianificato | Link affiliati o integrazioni ufficiali; checkout e ordine gestiti dal partner nel modello standard |
| Esclusione di magazzino e logistica CASHUP nel modello affiliato | Pianificato | Nessuno stock/spedizione propri; verificare responsabilità e termini di ogni partner |
| Feed/API catalogo, aggiornamento prezzi e disponibilità | Pianificato | Selezionare programmi, fonti autorizzate e gestione dati obsoleti |
| Attribuzione click e conversioni affiliate | Pianificato | Implementare tracking conforme a privacy, consenso e policy partner |
| CASHUP LIVE — dirette venditori | Pianificato | Streaming, profili verificati, moderazione, calendario e schede articolo |
| CASHUP LIVE — aste online | Pianificato | Prezzo iniziale, durata, incrementi, timer, estensione finale e registro offerte |
| CASHUP LIVE — vendita a prezzo fisso | Pianificato | Flusso alternativo all'asta, checkout tramite modello/partner autorizzato |
| Sicurezza aste e tutela acquirenti | Pianificato | Prevenire offerte false, collusione, mancati pagamenti; definire contestazioni e rimborsi |
| Monetizzazione LIVE | Pianificato | Commissioni, promozione dirette, sponsor, abbonamenti venditori, analytics e ads |


## 10. Requisiti recuperati e consolidati (20 novembre 2026)

| Area | Stato | Evidenza / lavoro residuo |
|---|---|---|
| Vetrina affiliata generalista CASHUP MARKET | Pianificato | Tassonomia ampia, ricerca, filtri, confronto, preferiti, schede e link affiliati |
| Marketplace con venditori terzi tipo eBay | Pianificato | Onboarding, inserzioni, reputazione, ordini, pagamenti provider, dispute e moderazione |
| Checkout integrato partner | Pianificato | Solo con API/accordi; chiarire venditore legale, incasso, rimborsi e responsabilità |
| CASHUP LIVE social commerce | Pianificato | Dirette, schede collegate, Q&A, calendario, notifiche e moderazione |
| Aste live | Pianificato | Regole, offerte cronologiche, timer, anti-manipolazione, pagamenti e dispute |
| CASHUP social network presence | Pianificato | Canali ufficiali globali, calendario contenuti, monetizzazione e dashboard attribuzione |
| CASHUP BRAIN coordinamento AI | Pianificato | Integrazioni AI per supporto, ricerca, raccomandazioni e automazioni con controlli |
| AI proprietaria CASHUP | Pianificato | Ricerca e valutazione fattibilità; non esiste ancora un modello proprietario |
| CASHUP LABS/STUDIO/TRANSLATE/AGENTS | Pianificato | Definire prodotti, strumenti, permessi, costi e valutazione qualità |
| Catalogo ARCADE esteso | In sviluppo | Visione 10.000 giochi/esperienze; prototipi e categorie non equivalgono a giochi finiti |
| Esperienza multipiattaforma | In sviluppo | Web/PWA, Android e iOS da verificare separatamente su dispositivi e browser |
| Identità visiva e icona | In sviluppo | Brand CASHUP, claim “IL MOVIMENTO PREMIA”; finalizzare asset coerenti |
| Account e servizi condivisi | In sviluppo | Consolidare wallet, notifiche, preferiti, referral, supporto e audit tra app |
| Completezza globale e cataloghi reali | Pianificato | Partner e fonti autorizzate per paese, traduzioni, valute e conformità |
