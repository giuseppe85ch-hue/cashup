# CASHUP — ritorno giornaliero, notifiche e monetizzazione pubblicitaria

## Obiettivo prodotto
Creare motivi utili e volontari per aprire CASHUP più volte al giorno: missioni giornaliere, giochi disponibili, passi, offerte reali, novità e campagne sponsorizzate. L'apertura da sola non produce ricavi pubblicitari: i ricavi dipendono da impression effettivamente erogate, clic validi, conversioni affiliate e accordi sponsor.

## Esperienza già preparata nel codice
- Pannello Home con indicatore dimostrativo delle visite giornaliere (fino a tre sessioni separate da almeno 20 minuti).
- Collegamento alla sezione Games e alla schermata Steps.
- Impostazioni di promemoria locali: 1, 2 o 3 notifiche giornaliere (18:00; 12:00 e 18:00; 10:00, 15:00 e 20:00).
- Richiesta del consenso notifiche solo dopo pressione esplicita dell'utente.
- Disattivazione dei promemoria dall'app.
- Promemoria nativi programmati sul dispositivo; non sono campagne push remote.
- Nessun credito economico o punti riscattabili assegnati dal contatore locale.

## Regole di frequenza e qualità
- Mai notifiche ogni 10 o 20 minuti.
- Massimo 3 promemoria programmati al giorno, con opt-out immediato.
- Orari rispettosi del riposo e del fuso locale del dispositivo.
- Notifiche di novità/offerte solo quando la novità o l'offerta esiste davvero.
- Niente countdown falsi, premi fittizi, schermate ingannevoli o aperture forzate.

## Monetizzazione da collegare prima di attivare i premi pubblicitari
1. Scegliere e approvare i fornitori per web e app native (non sono lo stesso SDK).
2. Creare gli account publisher e le app nel network; ottenere App ID e Ad Unit ID reali.
3. Integrare banner e native ad in spazi dichiarati, interstitial solo in pause naturali con cap di frequenza, video rewarded sempre facoltativi.
4. Integrare la piattaforma di consenso e privacy per i mercati interessati, incluse le regole GDPR/EEA e le policy dei negozi.
5. Verificare lato server gli eventi di rewarded ads tramite callback/Server-Side Verification del network; il client non può assegnare premi autonomamente.
6. Registrare ogni evento provider con ID univoco, impedire replay e doppie ricompense, applicare limiti giornalieri e audit.
7. Testare fill rate, impression, eCPM, invalid traffic, frequenza e comportamento in assenza di rete prima del rilascio.

## Regole per le ricompense
- Un'apertura o una visita può avanzare una missione, ma non accredita denaro automaticamente.
- Un video rewarded accredita il premio solo dopo conferma server verificata del provider.
- Clic, impression o visualizzazioni non devono essere artificialmente generate o forzate.
- Nessun pagamento per clic sugli annunci e nessuna richiesta agli utenti di interagire con annunci per manipolare le metriche.
- I premi reali devono essere finanziati da budget pubblicitari/partner verificati, con limiti sostenibili e condizioni chiare.

## Notifiche remote per novità in tempo reale
La build nativa può programmare promemoria locali. Per inviare una notifica quando viene pubblicata una nuova missione, un'offerta o una campagna servono anche: progetto EAS collegato, credenziali push Android/iOS, registrazione sicura dei token, backend per inviare push, preferenze/consensi utente e test su dispositivi reali. Questi passaggi non sono completati.

## Stato prima del lancio pubblico
- [x] UI missioni giornaliere e indicatore visite dimostrativo.
- [x] Preferenze per 1–3 promemoria al giorno.
- [x] Bridge nativo Expo per pianificare e annullare notifiche locali.
- [x] Dipendenza e plugin Expo Notifications aggiunti alla configurazione.
- [ ] Build Android/iOS nuova e testata: la build va rigenerata perché è cambiato il codice nativo.
- [ ] Push remote e campagne automatiche.
- [ ] Network pubblicitario e unità reali approvati/collegati.
- [ ] Server-Side Verification e ledger ricompense anti-frode.
- [ ] CMP/consensi, privacy, termini e policy negozi verificati.
- [ ] Test end-to-end e pubblicazione sugli store.

## Principio di lancio
Non dichiarare attivi gli annunci, i premi monetari o le notifiche di novità finché non sono stati collegati e verificati i relativi servizi. Il pannello attuale è una base di prodotto e non simula ricavi o denaro.
