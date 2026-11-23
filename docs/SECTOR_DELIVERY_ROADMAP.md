# CASHUP — Roadmap operativo di completamento dei settori

**Versione:** 1.0  
**Data:** 23 novembre 2026  
**Stato:** piano operativo; non dichiara attivi prodotti non ancora implementati.

## Obiettivo

Portare progressivamente tutti i settori CASHUP a un livello verificabile, riutilizzando un nucleo comune e consegnando moduli indipendenti. La visione resta internazionale, ma la disponibilità commerciale deve essere attivata paese per paese in base a partner, norme, pagamenti, lingue e supporto.

## Regole di completamento

Un settore è **Operativo** solo quando:
1. flusso principale implementato e accessibile;
2. dati e contenuti reali, leciti e aggiornati;
3. backend e permessi testati, inclusi test negativi;
4. privacy, sicurezza, moderazione e accessibilità adeguate al rischio;
5. errori, casi limite e compatibilità dichiarata verificati;
6. supporto, costi, monetizzazione e responsabilità documentati;
7. partner, licenze e pagamenti effettivamente disponibili, se necessari.

Gli stati **Pianificato**, **In sviluppo**, **Verificato** e **Operativo** non sono intercambiabili. Una schermata, una voce di catalogo o un prototipo non equivalgono a un servizio completo.

## Stato iniziale verificato nel repository

- Web demo pubblicata; autenticazione email e profilo Supabase presenti.
- CASHUP STEPS: integrazione nativa Health Connect/HealthKit in sviluppo; test su dispositivi fisici ancora necessari.
- Wallet: saldo in euro dimostrativo; storico punti in lavorazione su branch separato; nessun prelievo reale.
- CASHUP GAMES: catalogo concettuale di 10.000 esperienze, 100 categorie popolate e 4 prototipi giocabili; non sono 10.000 giochi finiti.
- Ads, programmi affiliate, negozi partner, cashback, premi riscattabili, payout e marketplace venditori non sono attivi.
- Android: compilazione release e avvio emulatore in verifica CI; test fisico non ancora attestato.
- iOS: build simulatore in lavorazione; IPA firmata e test HealthKit su iPhone non attestati.
- CASHUP BRAIN: planner deterministico dry-run; provider AI esterno non configurato e agenti autonomi disattivati.
- Core: tabelle e servizi esistenti da consolidare; non introdurre nuove scritture finanziarie client-side.

## Sequenza di consegna

### Fase 0 — Stabilità e fondazioni (blocco di rilascio)
- Android: APK release, bundle incorporato, emulatore e dispositivo fisico.
- iOS: compilazione, firma, dispositivo fisico e HealthKit.
- Web/PWA: registrazione, accesso, profilo, sessione, installazione e test end-to-end.
- Core: audit RLS/GRANT, sessioni, recupero account, preferenze, notifiche, logging e gestione errori.
- Privacy: inventario dati, consensi, esportazione/cancellazione, policy e dichiarazioni store.
- Brand: finalizzare logo/icona, splash, store asset e accessibilità.
**Uscita fase:** test principali superati su web e almeno un dispositivo Android; percorso iOS documentato; nessuna vulnerabilità critica aperta.

### Fase 1 — Primo motore commerciale verificabile
1. CASHUP MARKET affiliato: scegliere un primo network/merchant realmente disponibile, importare feed/API autorizzati, ricerca, categorie, schede, disclosure, link tracciati e riconciliazione conversioni.
2. CASHUP DEALS: coupon/offerte con fonte, paese, validità, condizioni e verifica scadenza.
3. CASHUP MISSIONS: missioni finanziate, prove server-side, idempotenza, limiti e antifrode.
4. CASHUP STEPS: lettura reale Health Connect/HealthKit, deduplicazione, cap 100 punti/giorno e convalida server-side; premi solo dopo finanziamento e test.
5. Wallet/Rewards/Referral: ledger separati per punti, crediti, cashback pending/confirmed e denaro; riscatti solo con provider e copertura reale.
**Uscita fase:** almeno un flusso commerciale con partner verificato e rendicontazione; nessuna promessa di guadagno garantito.

### Fase 2 — Venditori, community e contenuti
- CASHUP SELLER: onboarding, verifica trader, catalogo, ordini, dashboard, campagne e assistenza.
- CASHUP MARKET marketplace terzi: inserzioni, messaggistica, pagamenti tramite provider, spedizioni, resi, dispute, reputazione e moderazione.
- CASHUP CLUB: membership, benefit partner, QR/codici e regole antifrode.
- CASHUP PRICE: comparazione, storico/alert prezzo e freschezza delle fonti.
- CASHUP CONNECT: nickname, privacy, profilo pubblico, amici/inviti, gruppi e chat testuale; presenza/matchmaking successivi; voce solo dopo stima costi e moderazione.
- CASHUP SOCIAL: feed, community, gruppi, blocco/segnalazioni e moderazione.
- CASHUP CREATOR: profili creator, pubblicazione, analytics, monetizzazione e diritti.
**Uscita fase:** ruoli e permessi distinti, moderazione funzionante, flussi di assistenza e contestazione verificati.

### Fase 3 — Live commerce e media
- CASHUP LIVE: programmazione dirette, host verificati, streaming, chat moderata, schede prodotto, disclosure sponsor e replay con diritti.
- Aste: motore server-authoritative, offerte atomiche/idempotenti, timer server, anti-sniping, pagamenti, cancellazioni e dispute; attivazione solo dopo verifica legale per paese e categoria.
- Prezzo fisso e offerte a tempo con checkout partner/provider.
- CASHUP MEDIA: video/audio/streaming con licenze, cataloghi, diritti e controlli territoriali.
- CASHUP MUSIC: discovery, strumenti creator e contenuti con licenze.
- CASHUP PHOTO e CASHUP STUDIO: editing, portfolio e strumenti creativi con gestione diritti.
**Uscita fase:** diritti e licenze dimostrati, moderazione e protezione minori, costi streaming sostenibili.

### Fase 4 — Arcade e intrattenimento
- CASHUP ARCADE: completare prima un piccolo portafoglio di giochi di qualità; poi ampliare per categorie.
- Priorità giochi classici: scacchi, dama, biliardo 8-ball, Scopa, Briscola, Burraco, Scala 40 e solitario.
- Altri generi: puzzle, strategia, azione, avventura, quiz, simulazione, survival, sport, corse, costruzione, città/economia, agricoltura, animali, aviazione, treni, navi, spazio, cucina, moda, musica, arte e viaggi.
- Sistema comune: tutorial, livelli, salvataggi cloud, progressione, accessibilità, QA, classifiche e multiplayer.
- CASHUP CONNECT: inviti, lobby, rematch, squadre, tornei e anti-cheat progressivi.
- Monetizzazione non pay-to-win; nessuna competizione con premi in denaro senza revisione legale, finanziamento e controlli.
**Uscita fase:** ogni titolo marcato chiaramente idea/catalogo/prototipo/completo/QA/live.

### Fase 5 — Verticali specializzate
- CASHUP MOTOR e MOTOR CLASSIC.
- CASHUP RALLY, 4X4, ELECTRIC, DAKAR, NASCAR.
- CASHUP MOTO GP, MOTOCROSS, ENDURO.
- CASHUP OFFSHORE e SAILING.
- CASHUP SPORTS e CASHUP SIM.
- CASHUP FISHING.
Per i giochi: iniziare con contenuti originali/generici; marchi, modelli, circuiti, campionati e immagini reali richiedono licenze. Sviluppare garage, setup, carriera, eventi, campionati e multiplayer solo per discipline selezionate e con QA adeguato.

### Fase 6 — Altri verticali di servizio e commercio
- CASHUP LUXURY: autenticità, provenienza, seller verification e anti-contraffazione.
- CASHUP TRAVEL: ricerca, comparazione, prenotazioni/lead via partner.
- CASHUP FOOD: ristoranti, consegne, prenotazioni e prodotti tramite partner autorizzati.
- CASHUP HOME: prodotti, manutenzione e servizi.
- CASHUP AUTO: ricambi, accessori, manutenzione e annunci.
- CASHUP JOBS: annunci, profili, matching e strumenti recruiter.
- CASHUP KIDS: contenuti per età, privacy by design e controlli genitori.
- CASHUP EDUCATION: corsi, tutor, progressi e certificazioni solo se riconosciute.
- CASHUP PETS: prodotti, servizi e adozioni tramite enti autorizzati.
- CASHUP REAL ESTATE: annunci e lead; intermediazione solo tramite soggetti abilitati.
- CASHUP BEAUTY: prodotti, saloni e servizi.
- CASHUP TECH: prodotti, software e servizi.
- CASHUP PRODUCTIVITY: strumenti, organizzazione e automazioni.
- CASHUP LOCAL: servizi locali, preventivi e prenotazioni.
- CASHUP MOBILITY: noleggio, micromobilità e partner.
- CASHUP GREEN: efficienza, riuso e sostenibilità con claim verificabili.
- CASHUP FINANCE: educazione e strumenti informativi; attività regolamentate solo tramite soggetti autorizzati.
**Uscita fase:** definizione del ruolo CASHUP (publisher, affiliato, intermediario o provider), partner e requisiti normativi per ciascun servizio.

### Fase 7 — AI e automazione
- CASHUP BRAIN: assistenza, ricerca, raccomandazioni, analytics e coordinamento.
- CASHUP LABS: valutazione modelli e prototipi.
- CASHUP TRANSLATE: localizzazione e traduzione con QA umano per contenuti critici.
- CASHUP AGENTS: automazioni a permessi minimi, log, budget e approvazioni.
- CASHUP STUDIO: strumenti creativi e flussi contenuto.
Strategia: integrare modelli/API esterni modulari, confrontare costo/qualità/privacy/latency; considerare modelli proprietari solo quando dati, competenze e budget lo giustificano. Pagamenti, contratti, accessi, sicurezza e azioni irreversibili restano soggetti ad approvazione umana.

### Fase 8 — Crescita internazionale e distribuzione
- Lingue, valute, formati, accessibilità, layout RTL e supporto.
- Disponibilità paese per paese per prodotti, pagamenti, advertising, affiliate e contenuti.
- Canali ufficiali: TikTok, YouTube, Instagram, Facebook, X, Pinterest, Snapchat, Twitch, LinkedIn e reti regionali, secondo programmi e policy disponibili.
- Analytics di acquisizione e attribuzione; disclosure commerciale e privacy.
- Localizzazione di cataloghi e partner senza promettere copertura globale non verificata.

## Ordine di priorità e dipendenze

1. Stabilità app e Core.
2. Privacy/sicurezza e wallet ledger.
3. MARKET affiliate + DEALS (primo ricavo con minore carico operativo).
4. STEPS + MISSIONS + rewards finanziati.
5. SELLER/marketplace, poi LIVE/aste.
6. CONNECT/SOCIAL e creator.
7. ARCADE: pochi giochi completi, poi scala.
8. Verticali specializzate in base a domanda, licenze e partner.
9. BRAIN/AI progressiva e automazioni controllate.
10. Espansione paese per paese.

Non sviluppare in parallelo tutti i settori come prodotti distinti: condividere account, preferenze, notifiche, analytics e componenti comuni, ma mantenere separati dati e regole di dominio. Ogni fase deve avere stima costi, ricavi potenziali, dipendenze e criterio di arresto.

## Registro sintetico per settore

| Settore | Stato iniziale | Primo risultato verificabile |
|---|---|---|
| Core/account/profilo | In sviluppo | Test end-to-end web e sicurezza |
| Steps | In sviluppo | Lettura reale su Android/iOS e validazione |
| Wallet/rewards/referral | Demo/in sviluppo | Ledger e riscatti finanziati |
| Market affiliate | Pianificato | Primo merchant/feed e conversione tracciata |
| Deals/missions | Pianificato/in sviluppo | Offerta valida e missione verificata |
| Seller/marketplace | Pianificato | Onboarding e ordine test |
| Club/Price | Pianificato | Benefit partner e alert prezzo |
| Live/aste | Pianificato | Diretta moderata; asta test server-side |
| Connect/Social/Creator | Pianificato | Amici/chat e moderazione |
| Arcade/Games | Prototipi | Primo gruppo di giochi completi |
| Motor e sport motoristici | Pianificato | Verticale prototipo con asset originali |
| Sports/Sim/Fishing | Pianificato | MVP singolo con contenuti verificati |
| Kids/Education/Media/Music/Photo | Pianificato | MVP con policy età e diritti |
| Travel/Food/Home/Auto/Jobs/Local/Mobility | Pianificato | Primo partner/servizio per verticale |
| Finance/Real Estate/Beauty/Tech/Productivity/Pets/Green | Pianificato | MVP con confini regolamentari e partner |
| Luxury | Pianificato | Merchant verificato e autenticità controllata |
| BRAIN/LABS/STUDIO/TRANSLATE/AGENTS | Dry-run/parziale | Primo assistente esterno con costi e permessi controllati |
| Social distribution | Pianificato | Canali ufficiali e attribuzione verificata |
| iOS/Android/Web | In sviluppo | Test su dispositivi fisici e store readiness |

## Regole di costo e autorizzazione

- Preferire strumenti gratuiti e costi variabili; nessun acquisto, abbonamento, contratto o spesa senza approvazione esplicita.
- Non abilitare provider AI, ads, pagamenti o streaming a pagamento senza preventivo e consenso.
- Nessuna modifica a permessi Supabase, RLS, segreti o impostazioni di sicurezza senza revisione e approvazione.
- Nessuna promessa di guadagni, cashback, premi, copertura geografica o disponibilità senza prova.
- Ogni modifica di codice va su branch separato, con controlli automatici e revisione prima del merge in main.
