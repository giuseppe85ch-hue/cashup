# CASHUP — Blueprint operativo dell'ecosistema
**Versione:** 1.0  
**Data:** 20 novembre 2026  
**Stato:** documento di progettazione; non equivale a funzionalità implementate.

> Questo documento approfondisce il Master Plan e separa le richieste esplicite dell'utente dalle espansioni progettuali accettate. Ogni funzione resta Pianificata finché non esiste evidenza di implementazione e test.

## 1. Origine e perimetro

### 1.1 Nucleo iniziale
La prima versione CASHUP era concepita intorno a:
- CASHUP STEPS / attività e passi;
- Ricompense: gift card, sconti e cashback;
- Negozi e offerte;
- Invita amici;
- Wallet;
- Profilo.

L'interfaccia demo esistente non significa che passi reali, pagamenti, premi o cashback siano già attivi.

### 1.2 Espansione della visione
La visione si è estesa a un portafoglio internazionale di app e attività: marketplace affiliato generalista, luxury, aste e live commerce, deals, seller, giochi, corse e simulazioni, fishing, kids, sports, social, creator, media, travel, food, home, auto, jobs e AI. Sono state inoltre accettate proposte di estensione in finanza, fitness, musica, fotografia, istruzione, animali, immobiliare, bellezza, tecnologia, produttività, servizi locali, mobilità e sostenibilità.

Queste estensioni sono parte del perimetro pianificato, ma non tutte hanno ancora specifiche definitive né priorità di lancio.

## 2. Architettura del gruppo CASHUP

### 2.1 CASHUP Core
Servizi condivisi:
- identità e account, login, recupero, sicurezza e sessioni;
- profilo, lingua, paese, valuta, preferenze e consensi;
- wallet e ledger contabile;
- punti, crediti promozionali, cashback e premi monetari separati;
- notifiche, email transazionali, preferiti e liste;
- referral, reputazione e livelli;
- supporto, segnalazioni, reclami e centro privacy;
- analytics, attribuzione, audit log e antifrode;
- feature flags, configurazione regionale e gestione contenuti.

### 2.2 Regola dei confini
Ogni app specializzata può avere UX e backend di dominio propri, ma usa il Core per identità, preferenze, notifiche e servizi comuni. Evitare un unico database monolitico senza confini; definire moduli e ownership dei dati.

### 2.3 Account e wallet
Un utente può essere acquirente, venditore, creator, giocatore o partecipante a competizioni. I ruoli devono essere distinti e i permessi minimi. Il wallet non è un semplice numero modificabile: ogni movimento deve avere causale, fonte, stato, timestamp, idempotenza, riferimento esterno e registro non alterabile. Saldi separati per:
- punti non monetari;
- crediti promozionali;
- cashback maturato ma non ancora confermato;
- cashback confermato;
- premi monetari o vincite, solo se legalmente e operativamente supportati;
- pagamenti e rimborsi.

Non chiamare denaro un punto. Non promettere prelievi o premi finché partner, fondi, provider e regole non sono attivi.

## 3. CASHUP MARKET — modello affiliato e-commerce

### 3.1 Posizionamento
Una destinazione shopping ampia come un marketplace generalista, ma il modello iniziale prioritario è l'aggregazione di prodotti di terzi tramite affiliazione. CASHUP non acquista stock, non possiede magazzini e non spedisce nel modello standard.

### 3.2 Percorso cliente
1. L'utente apre MARKET e cerca un bisogno o un prodotto.
2. Il motore ricerca nel catalogo autorizzato e mostra prodotti/negozi.
3. L'utente applica filtri, confronta alternative e consulta la scheda.
4. CASHUP mostra chiaramente venditore, prezzo rilevato, data/ora di aggiornamento, disponibilità se nota, costi/tempi di spedizione se forniti e disclosure affiliate.
5. Il click genera un deep link tracciato conforme alle regole del partner.
6. Il checkout e il contratto di vendita avvengono normalmente sul sito/app del partner.
7. Il partner gestisce incasso, ordine, stock, consegna, reso, garanzia e servizio clienti.
8. Il network comunica click, ordine e commissione; la commissione può essere pending, approved, rejected o reversed.
9. CASHUP riconcilia report, storni, resi e pagamenti del network.

### 3.3 Architettura catalogo
Ogni prodotto deve avere:
- ID interno stabile e identificatore partner;
- titolo, brand, categoria e attributi;
- immagini con diritti/URL consentiti;
- descrizione e lingua;
- merchant e paese;
- prezzo e valuta, timestamp e origine;
- disponibilità e relativo timestamp;
- spedizione e condizioni quando fornite;
- URL canonico e deep link affiliato;
- commissione o regole di remunerazione non esposte se riservate;
- stato feed, qualità e ultima sincronizzazione;
- classificazione prodotti vietati/restrizioni territoriali.

Fonti ammesse: API ufficiali, feed forniti dai programmi, strumenti affiliate autorizzati e accordi diretti. Non copiare sistematicamente cataloghi o immagini senza permesso, non aggirare limiti API e non fabbricare recensioni.

### 3.4 Tassonomia iniziale
Elettronica; informatica; telefoni e accessori; gaming; TV e audio; fotografia; elettrodomestici; casa e cucina; arredamento; bricolage; giardino; moda uomo/donna/bambino; scarpe; borse; orologi e gioielli; bellezza e cura personale; sport; outdoor; pesca; giocattoli; libri e media; auto; moto; ricambi; animali; viaggi e tempo libero. Estendere in base a fonti autorizzate, domanda e regole locali.

### 3.5 Ricerca e conversione
- ricerca testuale, sinonimi, correzione refusi e ricerca per immagine in fase successiva;
- categorie, filtri, ordinamento e suggerimenti;
- confronto omogeneo tra prodotti equivalenti;
- preferiti, liste, cronologia e alert prezzo;
- pagine brand e negozio;
- schede con alternative e prodotti correlati;
- ranking che combina pertinenza, qualità dati, freschezza, valore per cliente e performance; separare chiaramente posizionamenti sponsorizzati;
- segnalazione prezzi scaduti e link non validi.

### 3.6 Ricavi e KPI
Ricavi: commissione per ordine, lead o azione approvata; campagne sponsorizzate; placement dichiarato; campagne brand; servizi analytics B2B.
KPI: impression prodotto, CTR, click out, conversion rate, AOV se disponibile, commissione per click, EPC, tasso approvazione, storni, ricavo per paese/categoria/merchant, freschezza feed, link rot e margine dopo costi.

### 3.7 Limiti e trasparenza
Disclosure vicino al link/prodotto: CASHUP può ricevere una commissione se l'utente acquista. Non affermare che il prezzo sia il più basso o che la disponibilità sia certa senza confronto e dati. Prezzi e stock possono cambiare sul sito del venditore.

## 4. CASHUP MARKET — marketplace venditori terzi

È un prodotto distinto dall'affiliazione. I venditori pubblicano inserzioni e, in futuro, possono concludere ordini attraverso flussi integrati.

Moduli:
- onboarding e verifica venditore;
- profilo negozio, documenti, contatti e coordinate dove richieste;
- catalogo, varianti, immagini, quantità e prezzi;
- gestione inserzioni e moderazione;
- messaggistica e domande;
- ordini, pagamento e payout tramite provider approvati;
- spedizione gestita dal venditore/partner logistico;
- tracking, resi, rimborsi e dispute;
- recensioni verificate e reputazione;
- commissioni, abbonamenti e promozione;
- dashboard venditore, report e assistenza.

Distinguere venditore professionale, consumatore e merchant affiliato. In UE le piattaforme che permettono ai consumatori di concludere contratti a distanza con trader possono avere obblighi di tracciabilità dei trader (DSA, art. 30); l'applicabilità concreta dipende dal modello e dal ruolo di CASHUP. Progettare verifica e compliance prima di aprire le inserzioni.

## 5. CASHUP LIVE — streaming, social commerce e aste

### 5.1 Tipi di evento
- live shopping con prodotto dimostrato;
- asta al rialzo;
- prezzo fisso;
- offerta a tempo;
- lancio prodotto;
- evento sponsor;
- presentazione collezionismo e oggetti speciali;
- eventi creator e community.

### 5.2 Motore aste
Ogni asta ha: ID, venditore, bene, condizioni, prezzo iniziale, incremento minimo, valuta, orario di apertura/chiusura, regole anti-sniping, requisiti partecipante, eventuale deposito se legalmente e tecnicamente supportato, stato, storico offerte e vincitore.
Ogni offerta deve essere server-authoritative, timestampata, atomica e idempotente. Non affidarsi al timer del telefono. Gestire parità, latenza, riconnessione, offerte simultanee, annullamento, venditore inadempiente, vincitore che non paga, frodi e contestazioni.
Il regolamento deve chiarire quando l'offerta è vincolante e quando nasce il contratto. Non avviare aste a pagamento senza revisione legale per paese/categoria.

### 5.3 Live streaming
- profili host e venditori verificati;
- scheduling, reminder e notifiche;
- chat, domande, moderazione e segnalazioni;
- schede prodotto ancorate al live;
- disclosure sponsor/affiliate ripetuta durante la trasmissione quando necessaria;
- replay/clip solo con diritti e consenso;
- strumenti host e statistiche;
- protezione minori e categorie vietate.

### 5.4 Ricavi
Commissioni, promozione live, sponsorship, advertising, strumenti premium e abbonamenti seller. KPI: spettatori simultanei, watch time, interazioni, click prodotto, conversioni, vendite, chargeback, reclami e ricavo netto per evento.

## 6. CASHUP LUXURY e vertical commerce

CASHUP LUXURY: selezione premium, orologi, gioielli, borse, moda, auto di lusso e collezionismo. Richiede autenticità, provenienza, policy anti-contraffazione, seller verification e procedure di contestazione. Le offerte affiliate devono provenire da rivenditori autorizzati o partner affidabili. Non dichiarare autenticità senza verifica.

CASHUP DEALS: coupon, flash sale, codici, cashback, promozioni stagionali, offerte locali e missioni sponsor. Ogni offerta ha paese, validità, condizioni, esclusioni, merchant, fonte, ultimo controllo e stato.

CASHUP SELLER: SaaS/strumenti per merchant, gestione catalogo, campagne, analytics, lead, live, promozioni e assistenza. Piani gratuiti e premium da valutare con unit economics.

## 7. CASHUP STEPS, fitness e ricompense

### 7.1 STEPS
Contapassi autentico con Health Connect Android e HealthKit Apple, permessi trasparenti, sincronizzazione, deduplicazione e controlli. Cap concordato: 100 punti al giorno; scala illustrativa 1.000=10, 3.000=30, 5.000=50, 8.000=80, 10.000+=100. La scala va convalidata in base a sostenibilità e antifrode.
Non assegnare punti all'apertura app. Rilevare anomalie, replay, sensori manipolati, dispositivi multipli e dati non verificabili. Premi solo se finanziati o coperti da partner.

### 7.2 Fitness esteso
Programmi di attività, obiettivi, sfide, progressi, routine e contenuti. Non presentare diagnosi o terapia; trattare dati salute come altamente sensibili, minimizzare raccolta e chiedere consenso esplicito. Non mescolare dati salute a profilazione pubblicitaria senza base legale adeguata.

## 8. CASHUP ARCADE e giochi

### 8.1 Catalogo e produzione
Obiettivo di visione: 10.000 esperienze, 100 categorie iniziali; ambizioni successive 350 categorie e 7 milioni di esperienze. Sono target di catalogo, non titoli completati.
Prototipi presenti: Reflexes, Memory, Math Challenge, Quick Quiz. Distinguere idea, scheda catalogo, prototipo, gioco completo, QA e gioco live.

### 8.2 Generi
Azione, avventura, arcade, puzzle, strategia, quiz, memoria, sport, corse, simulazione, survival, horror, sci-fi, fantasy, detective, escape, building, city/economy, farming, animali, aviazione, treni, navi, spazio, cucina, fashion, home, gardening, musica, arte, collezionismo e viaggi.

### 8.3 Sistema comune giochi
- account giocatore e profilo;
- progressione, livelli, obiettivi, missioni;
- salvataggio cloud e locale;
- matchmaking e multiplayer dove previsto;
- classifiche, tornei e sfide amici;
- stagioni, eventi e ricompense;
- anti-cheat, replay/telemetria e moderazione;
- accessibilità e compatibilità dispositivi;
- strumenti di pubblicazione e QA.

### 8.4 Monetizzazione
Pacchetti contenuto, mondi, livelli, stagioni, cosmetici, bundle, VIP, booster non competitivi e sponsorizzazioni. Free-to-play deve restare valido. Nessun vantaggio pay-to-win nelle gare con premi monetari; niente acquisti casuali a pagamento o meccaniche ingannevoli.

## 9. CASHUP MOTOR e app motoristiche

### 9.1 CASHUP MOTOR
Ispirazione di profondità da giochi di corse come CSR, con auto storiche e moderne, ma contenuti e modalità più ampi: carriera, garage, livelli, eventi, drag, time trial, eliminazione, circuiti, salita, strada e rally.
Personalizzazione: motore, turbo, aspirazione, scarico, cambio, trazione, differenziale, freni, sospensioni, pneumatici, aerodinamica, peso, carrozzeria, livree e interni.
Campionati: locali, nazionali, regionali/continentali e mondiali; inviti, amici, tornei e matchmaking live.

### 9.2 Verticali dedicate
- MOTOR CLASSIC: auto storiche, ricerca, restauro, ricostruzione, preparazione e gare.
- RALLY: asfalto, sterrato, neve, ghiaccio, prove speciali, navigazione e assistenza.
- 4X4: fuoristrada, SUV, pickup, trial, raid e terreni estremi.
- ELECTRIC: solo auto elettriche, autonomia/ricarica come parametri di gioco, prestazioni, modelli e campionati.
- DAKAR: auto, moto, furgoni, camion, quad, buggy, SSV, tappe, navigazione, bivacchi e squadre.
- NASCAR: stock car, ovali, superspeedway, circuiti misti, qualifiche, pit stop e carriera.
- MOTO GP: velocità su circuito, classi e campionati.
- MOTOCROSS: motocross, supercross, freestyle.
- ENDURO: enduro, hard enduro, trial e raid.
- OFFSHORE: motoscafi, circuiti marini e campionati.
- SAILING: vela, foiling, catamarani, regate, tattica ed equipaggi; ispirazione alle competizioni internazionali senza usare marchi/eventi senza licenza.

### 9.3 Licenze e realismo
Marchi, modelli, loghi, livree, circuiti, campionati, nomi di eventi e immagini richiedono licenze quando protetti. Fino ad accordi, usare veicoli e contenuti originali/generici. Realismo fisico, danni, meteo, setup e telemetria sono priorità da bilanciare con costi e prestazioni.

## 10. Ulteriori verticali accettati nel portafoglio

Queste aree derivano dall'espansione proposta e accettata; sono da specificare prima di essere considerate prodotti approvati in ogni dettaglio.

| Area | Ambito possibile |
|---|---|
| CASHUP SPORTS | Sport, eventi, community, sfide e contenuti |
| CASHUP SIM | Simulazioni, professioni, mezzi, mondi e gestione |
| CASHUP FISHING | Pesca sportiva, attrezzatura, guide, eventi e giochi |
| CASHUP KIDS | Contenuti educativi e intrattenimento adatto all'età, controlli genitori |
| CASHUP SOCIAL | Profili, feed, gruppi, chat, community, moderazione |
| CASHUP CREATOR | Pubblicazione, editing, analytics e monetizzazione creator |
| CASHUP MEDIA | Video, audio, streaming e contenuti con diritti |
| CASHUP TRAVEL | Ricerca e affiliazione di viaggi, soggiorni, attività e prenotazioni |
| CASHUP FOOD | Ristoranti, consegne o prenotazioni via partner, offerte e prodotti |
| CASHUP HOME | Casa, arredamento, manutenzione, servizi e prodotti |
| CASHUP AUTO | Ricambi, manutenzione, accessori, annunci e servizi |
| CASHUP JOBS | Annunci, matching, profili e strumenti recruiter |
| CASHUP FINANCE | Educazione finanziaria e strumenti informativi; servizi regolamentati solo tramite soggetti autorizzati |
| CASHUP MUSIC | Scoperta, creator, contenuti e strumenti con licenze |
| CASHUP PHOTO | Fotografia, editing, portfolio, creator e marketplace servizi |
| CASHUP EDUCATION | Corsi, apprendimento, tutor e contenuti |
| CASHUP PETS | Prodotti, servizi, adozione tramite enti autorizzati e community |
| CASHUP REAL ESTATE | Annunci, ricerca immobili e lead generation; intermediazione solo con soggetti abilitati |
| CASHUP BEAUTY | Prodotti, saloni, servizi e creator |
| CASHUP TECH | Prodotti, software, servizi e community tecnologica |
| CASHUP PRODUCTIVITY | Organizzazione, strumenti, automazioni e servizi |
| CASHUP LOCAL | Scoperta servizi locali, preventivi, prenotazioni e lead |
| CASHUP MOBILITY | Mobilità, noleggio, micromobilità e servizi partner |
| CASHUP GREEN | Sostenibilità, efficienza, riuso e prodotti/servizi verificati |

## 11. CASHUP BRAIN, AI e automazioni

- BRAIN: orchestrazione, ricerca interna, assistenza, analytics e coordinamento.
- LABS: esperimenti, valutazione e prototipi.
- STUDIO: strumenti creativi.
- TRANSLATE: traduzione e localizzazione.
- AGENTS: flussi autorizzati, con permessi minimi, log e approvazione umana.
- Strategia iniziale: integrare servizi AI esterni e/o modelli open-weight in modo modulare; misurare costo, qualità, latenza e privacy.
- Obiettivo lungo termine: valutare modelli proprietari. Richiede dati leciti, ricerca, compute, competenze, valutazioni e investimenti; non è un risultato immediato.
- Nessun agente può autonomamente spendere, stipulare contratti, cambiare sicurezza o eseguire azioni irreversibili senza approvazione.

## 12. Social, distribuzione e creator economy

Canali da valutare: TikTok, YouTube, Instagram, Facebook, X, Pinterest, Snapchat, Twitch, LinkedIn e reti regionali. Contenuti: prodotti, offerte verificate, tutorial, giochi, gare, aste live, creator, community, eventi e campagne.
Ricavi: programmi creator disponibili, sponsor, affiliate, campagne, lead e traffico verso CASHUP. Disclosure chiara e contestuale; i programmi e le soglie cambiano per paese e piattaforma. Dashboard per attribuire impression, visite, click, lead e conversioni.

## 13. Motori di ricavo e unit economics

Canali:
1. affiliate commission;
2. commissioni marketplace;
3. commissioni aste/live;
4. ads e rewarded video;
5. sponsor e campagne;
6. acquisti digitali e game packs;
7. abbonamenti consumer;
8. SaaS e abbonamenti seller;
9. servizi creator e B2B;
10. AI tools e API;
11. lead generation e prenotazioni partner;
12. licensing e partnership.

Per ogni canale stimare: ricavo lordo, costi provider, commissioni terze, rimborsi/storni, frodi, customer support, acquisizione utenti, infrastruttura, imposte e utile netto. Scenari conservativo/base/ambizioso. Obiettivi dichiarati: precedente traguardo 25–30 mila euro netti mensili e ambizione successiva 300 mila euro nel primo mese dopo il lancio; sono obiettivi, non previsioni garantite. Non sommare GMV dei venditori al fatturato CASHUP.

## 14. Pubblicità e rispetto dell'utente

Formati pianificati: banner, native chiaramente etichettate, video premiati, interstitial solo in pause naturali, offerwall e missioni sponsorizzate. Limiti di frequenza, controlli per minori, consenso e personalizzazione conforme. La pubblicità non deve essere camuffata da contenuto organico. Non assegnare ricompense senza verifica del completamento.

## 15. Referral e crescita

Inviti bilaterali solo dopo attività autentica e verificata; reward caps, periodo di attesa, rilevamento account duplicati, device abuse e self-referral. No struttura multilivello piramidale. Referral deve essere un canale di acquisizione misurabile, non una promessa di guadagno.

## 16. Internazionalizzazione

- Architettura i18n, traduzioni professionali per pagine critiche, valute e formati locali.
- Catalogo, disponibilità, programmi affiliate e pagamenti per paese.
- Supporto, resi e condizioni nel paese del merchant.
- Privacy, cookie/consenso, advertising, consumer law, fiscalità, minori e regole specifiche per settore.
- Lancio globale come obiettivo di progettazione, ma attivazione commerciale progressiva per paesi effettivamente supportati.

## 17. Fiducia, sicurezza e conformità trasversale

- Privacy by design, minimizzazione e retention controllata.
- Autenticazione robusta, MFA dove opportuno, session management e recupero account.
- RLS, least privilege, audit log e segreti solo lato server.
- Moderazione, segnalazioni, blocco utenti e gestione abusi.
- Antifrode per punti, cashback, referral, aste, pagamenti e tornei.
- Disclosure affiliate e sponsor chiara vicino al contenuto.
- Verifica venditori e prodotti, policy anti-contraffazione e categorie vietate.
- DSA/consumer protection e obblighi locali quando il modello di piattaforma li attiva.
- Licenze IP per giochi, veicoli, marchi, musica, video e contenuti.

## 18. UX e qualità

- Interfaccia semplice, veloce, accessibile e coerente.
- Navigazione globale con ricerca e personalizzazione.
- Stati chiari: disponibile, non disponibile, in attesa, demo, sponsorizzato, esterno.
- Nessun pulsante che promette un'azione non funzionante.
- Prestazioni su telefoni Android di fascia media, reti lente e dispositivi meno recenti.
- Test con utenti reali e localizzazione, evitando procedure tecniche inutili per l'utente finale.

## 19. Roadmap proposta per dipendenze

### Fase 0 — Stabilità e fondamenta
Build web/PWA/native, account, sicurezza, profilo, logging, analytics, design system e test.
### Fase 1 — Primo motore commerciale
MARKET affiliato con una o poche integrazioni partner autorizzate; feed, link, disclosure, tracciamento e riconciliazione.
### Fase 2 — Conversione e retention
DEALS, preferiti, notifiche, referral controllato, campagne e dashboard.
### Fase 3 — STEPS e rewards
Health Connect/HealthKit, antifrode, punti e premi finanziati.
### Fase 4 — Seller e marketplace
Onboarding, cataloghi, pagamenti provider, ordini, dispute e compliance.
### Fase 5 — LIVE
Streaming e poi aste, una volta verificate regole, pagamenti, sicurezza e moderazione.
### Fase 6 — ARCADE
Produzione titoli, cloud saves, QA, anti-cheat, tornei e monetizzazione.
### Fase 7 — Verticali
MOTOR e verticali, quindi altre app con business case e licenze.
### Fase 8 — Social, creator e media
Canali proprietari, creator tools, moderazione e monetizzazione.
### Fase 9 — AI
BRAIN, strumenti integrati, agents e ricerca proprietaria progressiva.
### Fase 10 — Espansione globale
Apertura paese per paese con partner, lingue, pagamenti, assistenza e compliance.

Le fasi possono sovrapporsi solo quando le dipendenze e le risorse lo consentono. Non significa che l'intero ecosistema sia completabile in un unico rilascio.

## 20. Definition of Done per ogni app

Una app può passare a Verificato/Operativo solo quando:
- requisito e proprietario funzionale definiti;
- flussi utente completi e testati;
- dati e contenuti reali autorizzati;
- backend e sicurezza testati;
- privacy e disclosure verificate;
- errori, casi limite e accessibilità controllati;
- monetizzazione realmente configurata e misurabile;
- supporto e procedure operative definite;
- test dispositivi e paesi dichiarati completati;
- dashboard e monitoraggio attivi.

## 21. Registro delle decisioni e delle lacune storiche

Etichette:
- **U — richiesta utente recuperata:** dichiarazione esplicita rintracciata nelle conversazioni.
- **A — proposta accettata:** proposta dell'assistente successivamente approvata dall'utente.
- **P — approfondimento progettuale:** dettaglio tecnico o operativo introdotto per rendere realizzabile il requisito.
- **D — da decidere:** richiede scelta futura dell'utente.

L'archivio recuperabile non equivale a una trascrizione completa di ogni conversazione storica. Nuove idee recuperate vanno aggiunte senza cancellare le precedenti e con la loro provenienza.


## 18. Nuovi moduli approvati: CLUB, PRICE, MISSIONS, SOCIAL, AI ASSISTANT e VIP

Stato di tutte le funzioni qui sotto: **Pianificato**. L'approvazione della direzione non equivale a sviluppo o disponibilità operativa.

### 18.1 CASHUP CLUB — membership e vantaggi
- Tessera digitale/account unico per identificazione presso partner, raccolta punti e consultazione vantaggi.
- Coupon, offerte e benefit collegati a condizioni, paese, periodo e partner verificato.
- QR o codice membership solo con validazione server-side e protezione da riutilizzo.
- Livelli e vantaggi fedeltà sostenibili; niente valore monetario implicito per punti non convertibili.
- KPI: membri attivi, utilizzo benefit, redemption, retention e ricavo/margine per membro.

### 18.2 CASHUP PRICE — ricerca e monitoraggio prezzi
- Ricerca prodotti e confronto tra offerte omogenee provenienti da feed/API autorizzati.
- Liste preferiti, cronologia prezzo e avvisi di variazione quando la fonte supporta aggiornamenti affidabili.
- Ogni prezzo mostra valuta, venditore, fonte e momento dell'ultimo aggiornamento; disponibilità e spedizione solo se fornite.
- Disclosure affiliate e sponsorizzazioni ben visibili; ranking sponsorizzato distinto da quello organico.
- KPI: ricerche, click-out, CTR, conversioni convalidate, EPC, freschezza feed e link non validi.

### 18.3 CASHUP MISSIONS — motore di attività
- Missioni giornaliere, settimanali, stagionali e sponsorizzate: passi, giochi, scoperta offerte e attività partner.
- Ogni missione definisce requisiti, finestra temporale, paese, limiti, prova richiesta, stato e fonte di finanziamento.
- Verifica lato server, idempotenza, limiti per account/dispositivo e controlli antifrode; nessun premio per semplice apertura o click non qualificato.
- Il tetto STEPS resta massimo 100 punti al giorno; le altre missioni hanno budget e limiti separati e sostenibili.
- KPI: completamento, costo per completamento verificato, ritorno, frodi e margine sponsor.

### 18.4 CASHUP SOCIAL — community
- Profili, gruppi, sfide tra amici, classifiche e condivisione volontaria dei risultati.
- Privacy granulare, blocco/segnalazione, moderazione, protezione minori e strumenti anti-abuso.
- Nessuna pubblicazione automatica di dati salute, posizione o informazioni personali.
- KPI: utenti attivi, interazioni significative, retention, segnalazioni e tempi di moderazione.

### 18.5 CASHUP AI ASSISTANT — assistente per l'ecosistema
- Aiuto nella ricerca di offerte, confronto prodotti, navigazione dei servizi e supporto account.
- Risposte ancorate a cataloghi e condizioni correnti; indicare chiaramente quando una fonte non è aggiornata o non disponibile.
- Consenso e minimizzazione dei dati; niente uso dei dati salute per targeting pubblicitario.
- Azioni sensibili (acquisti, pagamenti, modifiche account, riscatti) richiedono conferma esplicita dell'utente.
- Iniziare con servizi AI modulari e costi misurabili; non dichiarare esistente un modello proprietario finché non è stato sviluppato.

### 18.6 CASHUP VIP — abbonamento facoltativo
- Benefici premium concreti: funzioni avanzate, strumenti, contenuti, personalizzazione e vantaggi partner effettivamente disponibili.
- Prezzo, rinnovo, prova, cancellazione e benefici sempre trasparenti prima dell'acquisto.
- Il piano gratuito deve restare utile; nessuna promessa di guadagni o vantaggi economici non finanziati.
- Verificare policy Apple/Google per beni e servizi digitali e per eventuali benefit reali.
- KPI: conversione, churn, ricavo netto, costo benefit, rimborsi e soddisfazione.

### 18.7 CASHUP CORE e integrazione tra moduli
Club, Price, Missions, Social, AI Assistant e VIP riutilizzano identità, preferenze, notifiche, catalogo, analytics e controlli del CASHUP Core. Wallet/ledger e sistemi premio restano separati per tipologia di valore e non devono essere aggirati dai moduli verticali.


## 22. CASHUP CONNECT — identità sociale e multiplayer trasversale

**Stato: Pianificato e approvato come requisito di piattaforma il 22 novembre 2026.** La direzione è condivisa; le funzioni non sono ancora implementate.

CASHUP CONNECT è il livello sociale comune dell'ecosistema. Deve consentire agli utenti, in base alle funzioni offerte dalla singola app, di incontrarsi, comunicare, invitarsi e ritrovarsi senza creare account separati per ogni verticale.

### 22.1 Identità, amici e presenza
- Account CASHUP unico con nickname scelto dall'utente, avatar, profilo e preferenze sociali.
- Richieste e lista amici, preferiti, blocco, rimozione e segnalazione.
- Presenza configurabile: online, offline, occupato/non disturbare o invisibile.
- Ricerca utenti tramite nickname/ID pubblico; nessuna esposizione di email o telefono.
- Inviti tramite link CASHUP e canali esterni (email, SMS e social) usando le funzioni di condivisione disponibili; non presumere accesso automatico ai contatti o alle API dei social.
- Inviti revocabili, con scadenza e controlli anti-spam.

### 22.2 Incontri casuali e matchmaking
- Ricerca casuale opt-in, con preferenze, lingua, regione, modalità e livello quando pertinenti.
- Code e lobby con disponibilità, regole, posti, stato e riconnessione.
- Matchmaking server-authoritative; evitare che il client possa falsificare risultati, punteggi o assegnazioni.
- Opzioni per giocare con amici, con utenti casuali o in modalità privata.
- Nessuna condivisione precisa della posizione geografica per impostazione predefinita.

### 22.3 Gruppi, clan e comunità
- Gruppi persistenti e temporanei, nome, descrizione, immagine, proprietari, moderatori e membri.
- Ruoli e permessi: proprietario, amministratore, moderatore, membro e ospite.
- Inviti, richieste di accesso, ricerca gruppi, calendario, chat e attività condivise.
- Possibilità di ritrovare un gruppo e i suoi membri in sessioni successive.
- Strumenti per espellere, silenziare, bloccare, segnalare e moderare.

### 22.4 Comunicazione in tempo reale
- Chat testuale privata, di gruppo e di lobby.
- Voce in lobby e durante la partita, con mute individuale, mute globale, volume e uscita rapida.
- Push-to-talk e controlli per ridurre rumore e consumo dati dove supportati.
- Valutare provider WebRTC/voice gestiti o infrastruttura dedicata in base a costo, latenza, qualità e copertura regionale.
- La voce non è registrata per impostazione predefinita; eventuale registrazione/moderazione audio richiede base giuridica, informativa e controlli adeguati.

### 22.5 Requisiti specifici per CASHUP GAMES
- Inviti diretti, sfide, matchmaking casuale, lobby private e pubbliche.
- Partite individuali e a squadre, rematch e possibilità di ritrovare gli avversari.
- Clan, tornei, eventi, classifiche e statistiche verificate.
- Sincronizzazione cloud di nickname, progressi e risultati; gestione disconnessioni e riconnessione.
- Anti-cheat, server autorevole per modalità competitive e audit dei risultati.
- Chat/voce integrate durante il gioco, se tecnicamente supportate dal titolo e dalla piattaforma.
- Non promettere cross-play universale: verificare per ogni gioco rete, piattaforme, input, versione e compatibilità.

### 22.6 Riutilizzo in tutte le app CASHUP
CONNECT è un servizio condiviso, ma ogni verticale abilita solo le funzioni pertinenti. Esempi: gruppi di viaggio, community musicali, sessioni creator, eventi LIVE, gruppi di acquisto, squadre sportive e sfide STEPS. Le funzioni sociali non devono essere forzate in contesti dove non aggiungono valore.

### 22.7 Privacy, sicurezza e protezione degli utenti
- Impostazioni granulari per visibilità, inviti, messaggi, voce e ricerca; impostazioni conservative per i nuovi account.
- Blocco e segnalazione sempre accessibili; rate limit, rilevamento spam e anti-harassment.
- Moderazione umana e automatizzata con procedure di escalation e appello.
- Protezioni specifiche per minori: limiti di contatto, chat/voce e discoverability conformi a età, paese e legge; niente contatti casuali non protetti.
- Non mostrare email, numero di telefono, posizione precisa o altri dati privati nei profili pubblici.
- Consenso e controlli per notifiche; niente invio di inviti ai contatti senza azione esplicita.
- Conservazione limitata dei dati di chat e log, accessi controllati e procedure per richieste privacy.

### 22.8 Architettura e costi
- Servizi condivisi: profilo pubblico separato dai dati privati, social graph, presence, invitations, groups, matchmaking, chat, voice signaling, moderation e notifications.
- Autenticazione e autorizzazione lato server; RLS e controlli di accesso per gruppi/conversazioni; rate limit e audit.
- Presenza e matchmaking richiedono componenti realtime; chat e voce possono avere costi variabili per utenti attivi, traffico, minuti e regioni.
- Iniziare con MVP testuale e inviti; introdurre presenza/matchmaking, quindi voce e tornei quando la domanda giustifica i costi.
- Non attivare servizi a pagamento o contratti senza approvazione esplicita e stima dei costi.

### 22.9 KPI e criteri di rilascio
- Inviti inviati/accettati, amici attivi, gruppi attivi, match completati, tempo di matchmaking, riconnessioni, minuti vocali, latenza, crash, segnalazioni e tempi di moderazione.
- Rilascio per verticale solo dopo test funzionali, carico, sicurezza, privacy, moderazione, accessibilità e costi per utente.
- La presenza di un requisito in questo blueprint non significa che la funzione sia già disponibile o implementata.
