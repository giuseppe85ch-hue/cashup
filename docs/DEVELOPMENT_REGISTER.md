# CASHUP — Registro di sviluppo

**Aggiornamento:** 23 novembre 2026  
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
| APK Android release | Verificato | Build release CI riuscita; bundle incorporato verificato; artifact `cashup-android-release` disponibile fino al 21 febbraio 2027. Test fisico sullo Xiaomi ancora necessario |
| Workflow CI Android | Verificato | Run GitHub Actions 45089072157 superato: build release, verifica bundle, salvataggio artifact e installazione/avvio su emulatore. Il test emulatore non sostituisce quello su dispositivo fisico |
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

1. **Completare la verifica Android su dispositivo fisico**: CI, bundle e avvio su emulatore sono superati (run 45089072157); resta da provare l'APK su Xiaomi, inclusi avvio, login, stabilità, Health Connect e notifiche.
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


## 11. Blueprint e nuove aree da specificare

| Documento / area | Stato | Evidenza / lavoro residuo |
|---|---|---|
| CASHUP Ecosystem Blueprint | Verificato | Documento di progettazione creato; non significa che le app siano implementate |
| CASHUP Core condiviso | Pianificato | Definire servizi, confini dati, permessi, wallet ledger e audit |
| Marketplace affiliato — catalog ingestion | Pianificato | Selezionare partner/feed/API autorizzati e validare freschezza dati |
| Marketplace venditori terzi | Pianificato | Onboarding, trader verification, ordini, pagamenti, dispute e compliance |
| CASHUP LIVE streaming | Pianificato | Provider, moderazione, chat, schede prodotto e diritti |
| Motore aste server-authoritative | Pianificato | Offerte atomiche, timer, anti-sniping, pagamenti e contestazioni |
| Fitness oltre STEPS | Pianificato | Specifiche, privacy salute e integrazioni |
| Verticali aggiuntive accettate | Pianificato | Finance, music, photo, education, pets, real estate, beauty, tech, productivity, local, mobility, green |
| Social/creator/media | Pianificato | Canali, strumenti, policy, attribuzione e monetizzazione |
| CASHUP BRAIN e AI proprietaria | Pianificato | Prima integrazioni modulari; ricerca proprietaria di lungo periodo |
| Global compliance e localizzazione | Pianificato | Analisi paese per paese prima dell'attivazione commerciale |

## 12. Aggiornamento CI Android e multipiattaforma (22 novembre 2026)

| Area | Stato | Evidenza / lavoro residuo |
|---|---|---|
| Build APK Android release | Verificato in un run precedente | La compilazione Gradle era terminata con successo nel run #41; non equivale al test su dispositivo |
| Avvio emulatore Android in CI | In sviluppo | Il run #41 era fallito per timeout dell'emulatore (ADB non ha rilevato emulator-5554); il log non dimostra un crash dell'app |
| Ambiente runner Android | In sviluppo | Job spostato su ubuntu-24.04 per isolare il problema dell'ambiente |
| Nuovo test Android CI — run #42 | In sviluppo | https://github.com/giuseppe85ch-hue/cashup/actions/runs/45030107409 — Expo check superato; generazione progetto Android superata; compilazione APK ancora in corso all'ultimo controllo; test emulatore e artifact non ancora disponibili |
| Verifica Web/PWA — run #7 | Verificato | https://github.com/giuseppe85ch-hue/cashup/actions/runs/45030107441 — job Web/PWA completato con successo |
| Verifica iOS — run #7 | Verificato | https://github.com/giuseppe85ch-hue/cashup/actions/runs/45030107441 — generazione progetto iOS e bundle JavaScript completati con successo |
| Audit Supabase sicurezza | Verificato con interventi necessari | Tutte le 19 tabelle pubbliche controllate hanno RLS attiva; le policy limitano le righe per utente. Le funzioni SECURITY DEFINER e la protezione password compromesse richiedono revisione. Inoltre mancano i privilegi SQL INSERT/UPDATE per authenticated su profiles e cashup_notification_preferences, nonostante le policy RLS previste e gli upsert usati dal client: blocco funzionale da correggere con GRANT minimi dopo approvazione esplicita |
| Ottimizzazione database | Da monitorare | Gli advisor segnalano indici non ancora utilizzati; non rimuoverli prima di avere dati di traffico e test prestazionali |

**Vincolo di test:** non chiedere di disinstallare la vecchia app. Installare un APK nuovo sul dispositivo solo dopo un controllo automatico affidabile e conservare la vecchia versione finché login, profilo e funzioni principali non sono verificati sullo Xiaomi.

**Nota sicurezza:** le funzioni SECURITY DEFINER controllate verificano l'identità tramite `auth.uid()` e vincolano le operazioni ai dati dell'utente; non revocare permessi in modo indiscriminato perché si potrebbe interrompere il flusso applicativo. Prima del lancio verificare i grant, i test negativi e la necessità di ogni funzione. La protezione delle password compromesse va attivata dopo una valutazione delle impostazioni Auth e della relativa esperienza di accesso.


## 13. Correzione privilegi Supabase — 22 novembre 2026

| Area | Stato | Evidenza / lavoro residuo |
|---|---|---|
| Policy RLS su `public.profiles` | Verificato | Prima della modifica: SELECT, INSERT e UPDATE limitati a `auth.uid() = id`; UPDATE include USING e WITH CHECK |
| Policy RLS su `public.cashup_notification_preferences` | Verificato | Prima della modifica: SELECT, INSERT e UPDATE limitati a `auth.uid() = user_id`; UPDATE include USING e WITH CHECK |
| GRANT minimi a `authenticated` | Verificato | Con autorizzazione esplicita dell'utente, concessi solo INSERT e UPDATE sulle due tabelle indicate; nessun grant ad anon e nessuna modifica alle policy |
| Verifica successiva | Verificato | Query di controllo conferma RLS attiva su entrambe, SELECT/INSERT/UPDATE disponibili a authenticated e tre policy per authenticated su ciascuna tabella |
| Test funzionale end-to-end | Da eseguire | Verificare da sessione utente reale salvataggio profilo e preferenze notifiche; il controllo SQL dei privilegi non sostituisce il test applicativo |

**Perimetro della modifica:** nessuna altra tabella, policy RLS, impostazione Auth o funzione è stata modificata.


## 13. Moduli approvati il 22 novembre 2026

| Area | Stato | Evidenza / lavoro residuo |
|---|---|---|
| CASHUP CLUB — tessera digitale e vantaggi partner | Pianificato | Definire membership, QR/codici sicuri, benefit e partner |
| CASHUP PRICE — confronto e avvisi prezzo | Pianificato | Feed/API autorizzati, freschezza dati, comparabilità e disclosure affiliate |
| CASHUP MISSIONS — missioni multi-settore | Pianificato | Regole, prove server-side, budget, limiti e antifrode |
| CASHUP SOCIAL — community e sfide | Pianificato | Profili, gruppi, privacy, moderazione e protezione minori |
| CASHUP AI ASSISTANT | Pianificato | Ricerca offerte/prodotti, supporto e azioni con conferma esplicita |
| CASHUP VIP — membership premium | Pianificato | Benefici reali, prezzi trasparenti, cancellazione e policy store |
| Integrazione con CASHUP Core | Pianificato | Riutilizzare account, preferenze, notifiche, catalogo e analytics senza mescolare ledger |

## 14. Aggiornamento verifica Android — 22 novembre 2026

| Controllo | Stato | Evidenza / lavoro residuo |
|---|---|---|
| Compilazione APK Android release | Verificato nel run 45031496465 | Gradle ha completato con successo e generato l'APK |
| Test avvio su emulatore GitHub Actions | Bloccato da ambiente CI | L'emulatore non è comparso su ADB e il runner è andato in timeout; non è un errore di bundle dell'app |
| Conservazione APK quando l'emulatore non parte | In sviluppo | Workflow aggiornato per caricare l'artefatto subito dopo la compilazione e rendere non bloccante il test dipendente dall'emulatore |
| Verifica sul dispositivo Android fisico | Pianificato | Installare il nuovo APK verificato e controllare avvio, login, Health Connect e notifiche |
| Errore storico "Unable to load script" sul telefono | Non ancora verificato | Non attribuirlo al run CI; confrontare il pacchetto installato con il nuovo package com.cashup.mobile e raccogliere l'eventuale messaggio esatto |



## 15. CASHUP CONNECT — requisiti social e multiplayer approvati (22 novembre 2026)

| Area | Stato | Evidenza / lavoro residuo |
|---|---|---|
| CASHUP CONNECT come servizio sociale condiviso | Pianificato | Specifica aggiunta al Blueprint; non implementato |
| Nickname, profilo pubblico e presenza | Pianificato | Definire privacy, stato online/offline/invisibile e ricerca pubblica |
| Amici, ricerca e inviti | Pianificato | Richieste, link revocabili, email/SMS/social tramite condivisione esplicita e anti-spam |
| Matchmaking casuale | Pianificato | Code server-side, preferenze, lingua/regione/livello e modalità opt-in |
| Gruppi persistenti, clan e community | Pianificato | Ruoli, inviti, richieste, moderazione e ritrovo tra sessioni |
| Chat testuale | Pianificato | Conversazioni private, di gruppo e lobby; access control e retention |
| Chat vocale durante il gioco | Pianificato | Valutare WebRTC/provider; mute, controlli, moderazione e costo/minuti |
| CASHUP GAMES multiplayer | Pianificato | Sfide, lobby, squadre, rematch, tornei, classifiche, cloud progress e anti-cheat |
| Social layer nelle altre app | Pianificato | Abilitare gruppi/eventi/community solo dove pertinenti, riutilizzando CONNECT |
| Sicurezza e tutela minori | Pianificato | Blocco, segnalazioni, privacy granulare, limiti di contatto e moderazione |
| Costi realtime e voce | Da valutare | MVP testuale/inviti prima; stimare costo per utente e traffico prima della voce |
| Test cross-platform | Pianificato | Verificare ogni funzione su web, Android e iOS; non promettere cross-play universale |

**Ordine di realizzazione proposto:** (1) profilo pubblico/nickname e privacy; (2) amici e inviti; (3) gruppi e chat testuale; (4) presenza e matchmaking casuale; (5) voce in lobby/partita; (6) tornei, anti-cheat e integrazione progressiva nei giochi. Tutte le funzioni restano pianificate fino a sviluppo e test documentati.


## 16. CASHUP GAMES — giochi classici, carte e tornei (22 novembre 2026)

| Area | Stato | Evidenza / lavoro residuo |
|---|---|---|
| Scacchi e dama | Pianificato | Motori regole completi, partite online, rating, tornei e varianti regionali |
| Biliardo | Pianificato | 8-ball, 9-ball, 10-ball, snooker e carambola; fisica e regole da sviluppare/testare |
| Carte italiane | Pianificato | Scopa, Briscola, Tressette, Burraco, Scala 40, Ramino e varianti |
| Carte internazionali | Pianificato | Poker gratuito, Bridge, Hearts, Spades, Canasta, Whist, Euchre e solitari; regole/localizzazione |
| Altri classici | Pianificato | Backgammon, domino, mahjong, forza 4, battaglia navale, giochi di parole e puzzle |
| Tornei e campionati | Pianificato | Eliminazione, doppia eliminazione, gironi, round-robin, Swiss, stagioni e competizioni a squadre |
| CASHUP CONNECT nei giochi | Pianificato | Amici, inviti, nickname, gruppi, chat e voce; integrazione progressiva |
| Equità e sicurezza competitiva | Pianificato | Server autorevole, anti-cheat, anti-collusione, disconnessioni, contestazioni e audit |
| Premi di valore | Da valutare | Solo dopo revisione legale paese per paese, copertura finanziaria e approvazione esplicita; niente puntate in denaro come requisito |
| MVP giochi classici | Pianificato | Valutare scacchi, dama, biliardo 8-ball, Scopa, Briscola, Burraco, Scala 40 e solitario come prima selezione |

**Nota:** questa registrazione documenta requisiti approvati, non giochi già disponibili. La priorità è costruire pochi titoli completi e affidabili prima di ampliare il catalogo.


## 17. Audit tecnico e sicurezza Supabase — 22 novembre 2026

| Controllo | Stato | Risultato / azione |
|---|---|---|
| Tabelle esposte nello schema public | Verificato | 19 tabelle controllate; RLS attiva su tutte le 19 |
| Funzioni SECURITY DEFINER accessibili ad authenticated | Da mantenere sotto controllo | 3 RPC: `cashup_claim_verified_ad_reward`, `cashup_claim_verified_mission`, `cashup_record_app_visit`. La lettura delle definizioni conferma il controllo `auth.uid()`; le prime due bloccano la riga con `FOR UPDATE`, verificano lo stato e registrano il ledger in modo atomico. EXECUTE risulta negato ad anon e consentito ad authenticated. L'advisor le segnala perché SECURITY DEFINER: non revocare senza sostituire prima il flusso client che le usa |
| Protezione password compromesse | Da configurare con approvazione | Advisor Auth segnala la protezione leaked-password disattivata. Richiede una modifica alle impostazioni Auth; nessun cambiamento eseguito in questo audit |
| Indici non utilizzati | Da monitorare | Advisor segnala 13 indici mai usati; database con traffico ancora minimo. Non eliminare indici preventivamente: rivalutare dopo test e traffico reale |
| Evento pubblicitario duplicato | Verificato | Vincolo univoco su `(provider, provider_event_id)` presente; la Edge Function usa la chiave per riconoscere eventi duplicati |
| Segreto provider pubblicitario | Non configurato / da verificare | La funzione restituisce 503 se mancano `CASHUP_AD_PROVIDER_SECRET`, URL o service key. Nessun provider pubblicitario reale è quindi dichiarato attivo |
| AI esterna CASHUP BRAIN | Disattivata per controllo costi | La funzione di revisione richiede MFA AAL2 e fondatore attivo; chiamate esterne restano disattivate finché `CASHUP_BRAIN_AI_ENABLED` non viene autorizzato |
| CASHUP BRAIN planner gratuito | Verificato come dry-run | Planner deterministico: non usa un modello generativo, non modifica database e non chiama servizi esterni |
| Doppio caricamento preferenze notifiche | Corretto nel codice | Rimossa la seconda chiamata duplicata in `refreshSession()`; nuovi workflow automatici avviati sul commit `9cb29ec1334cd19aa22ebd850cf779a46f172e19` |

**Esito:** nessuna modifica a policy RLS, privilegi, funzioni privilegiate, impostazioni Auth, segreti o servizi a pagamento durante questo audit. Le segnalazioni residue richiedono approvazione e/o traffico di produzione per essere affrontate in sicurezza.

## 18. Verifica continua dopo la correzione notifiche

| Workflow | Stato | Evidenza |
|---|---|---|
| Web/PWA sul commit `9cb29ec` | Verificato | Catalogo, sintassi JavaScript e sito/manifest pubblicato superati; run https://github.com/giuseppe85ch-hue/cashup/actions/runs/45039792804 |
| Controllo Expo/Android sul commit `9cb29ec` | In corso all'ultimo controllo | Expo check superato; compilazione APK ed emulatore ancora in esecuzione; run https://github.com/giuseppe85ch-hue/cashup/actions/runs/45039792770 |
| iOS sul commit `9cb29ec` | In corso all'ultimo controllo | Installazione dipendenze in corso; run https://github.com/giuseppe85ch-hue/cashup/actions/runs/45039792804 |

