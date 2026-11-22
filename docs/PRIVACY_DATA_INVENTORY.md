# CASHUP — Inventario interno dei dati e preparazione privacy

**Stato:** documento interno di lavoro, non informativa privacy pubblicabile.  
**Data:** 23 novembre 2026

Questo inventario fotografa soltanto i flussi visibili nel codice attuale. Non sostituisce una verifica tecnica completa, una valutazione legale o l'informativa destinata agli utenti. Le voci indicate come "da confermare" devono essere verificate prima del lancio.

## 1. Dati e flussi individuati nel codice

| Categoria | Dati/operazioni individuati | Dove/come | Stato e verifica necessaria |
|---|---|---|---|
| Account | Indirizzo email, credenziali gestite dal provider di autenticazione, identificativo utente | Supabase Auth | Verificare impostazioni, log, recupero account e cancellazione |
| Profilo | Nome visualizzato e identificativo utente | Tabella `profiles` | Confermare tutti i campi effettivi e i tempi di conservazione |
| Passi | Totale giornaliero, data, identificativo utente e data aggiornamento | Health Connect/Apple HealthKit tramite app nativa; sincronizzazione in `cashup_daily_steps` | Dato relativo alla salute/attività: verificare base giuridica, consenso esplicito ove richiesto, minimizzazione, accessi e cancellazione |
| Preferenze notifiche | Attivazione, numero giornaliero, orari locali, fuso orario e data aggiornamento | `cashup_notification_preferences`; notifiche locali native | Verificare retention e comportamento dopo logout/cancellazione account |
| Wallet punti | Importo punti, causale e data movimento | Lettura della tabella `points_ledger` nella modifica proposta per il Wallet | Confermare schema completo, policy RLS e finalità; punti non equivalgono a denaro |
| Progressi giochi | Stato/progresso per gioco associato all'account | Modulo `games/cloud-progress.js`, tabella `player_game_progress` | Verificare colonne effettive, regole RLS e cancellazione |
| Conteggio visite | Chiamata RPC autenticata per registrare/contare visite giornaliere | Funzione `cashup_record_app_visit` | Verificare esattamente quali metadati vengono registrati e per quanto tempo |
| Dati sul dispositivo | Nome/email inseriti, totale passi giornaliero e preferenze/promemoria locali | `localStorage` e AsyncStorage | Verificare durata, pulizia al logout e cancellazione account |
| Notifiche | Identificativi delle notifiche programmate sul dispositivo | AsyncStorage e sistema notifiche del dispositivo | Verificare revoca permessi e cancellazione completa |

## 2. Permessi del dispositivo

- Android: lettura dei passi tramite Health Connect; notifiche locali.
- iOS: lettura dei passi tramite Apple HealthKit; notifiche locali.
- Il codice dichiara una lettura dei passi e non una scrittura di dati sanitari.
- Il browser/PWA non dispone del bridge nativo per leggere direttamente Health Connect o HealthKit.
- Prima del rilascio verificare i testi di autorizzazione, il comportamento se il permesso viene negato e l'effettiva assenza di accessi non necessari.

## 3. Servizi e trasferimenti da verificare

- Supabase è il servizio attualmente usato per autenticazione e database.
- Cloudflare Pages ospita il sito web.
- Verificare contratti, ruoli privacy, localizzazione dei dati, sub-responsabili, trasferimenti internazionali, misure di sicurezza e termini aggiornati di ciascun fornitore.
- Verificare eventuali servizi aggiuntivi introdotti prima del lancio: analytics, pubblicità, attribuzione affiliati, email transazionali, pagamenti, assistenza e crash reporting. Non risultano configurati nel codice esaminato come provider operativi.

## 4. Informazioni mancanti prima di redigere l'informativa pubblica

1. Identità e contatti del titolare del trattamento e, se applicabile, del referente privacy.
2. Finalità e base giuridica per ciascuna categoria di dati.
3. Consenso specifico e separato per i dati relativi ai passi/salute, ove richiesto.
4. Tempi di conservazione per account, profilo, passi, progressi, punti, notifiche e log.
5. Procedura verificata per accesso, rettifica, esportazione, cancellazione e revoca dei consensi.
6. Elenco aggiornato di fornitori, sub-responsabili e trasferimenti.
7. Gestione cookie, storage locale, sessioni e strumenti di misurazione.
8. Contatto per richieste privacy e procedura per incidenti/data breach.
9. Informazioni specifiche per minori e fasce d'età ammesse.
10. Versioni tradotte e localizzate dell'informativa per i paesi effettivamente serviti.

## 5. Controlli tecnici pre-lancio

- Verificare RLS su tutte le tabelle e le funzioni esposte.
- Testare che un utente non possa leggere o modificare dati di un altro utente.
- Verificare cancellazione coerente dei dati collegati all'account, inclusi backup e log secondo le policy applicabili.
- Non attivare premi monetari o cashback finché i flussi di valore, antifrode, audit e responsabilità non sono verificati.
- Evitare di raccogliere dati non necessari; non introdurre analytics o advertising senza aggiornare l'inventario e la documentazione.

## 6. Regola di pubblicazione

Questo documento è soltanto una base di lavoro interna. Non copiarlo o presentarlo agli utenti come informativa legale definitiva. L'informativa pubblica e gli eventuali consensi devono essere completati e verificati da un professionista competente prima del lancio, in base ai servizi realmente attivati e ai paesi serviti.
