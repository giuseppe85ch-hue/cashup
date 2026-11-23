# CASHUP — Piano operativo di lancio internazionale

**Versione:** 1.0  
**Data:** 23 novembre 2026  
**Stato:** piano preparatorio; non attesta account, partner, campagne o funzioni non ancora attivati.

## 1. Obiettivo

Preparare CASHUP a un lancio credibile, misurabile e monetizzabile fin dall'inizio, senza confondere presenza del marchio, pubblicità a pagamento, annunci in-app, commissioni commerciali e premi destinati agli utenti.

Il lancio è progettato con ambizione internazionale, ma offerte, pagamenti, lingue, assistenza e disponibilità commerciale vanno abilitati mercato per mercato.

## 2. Stato di partenza accertato

- Sito web pubblicato su Cloudflare Pages.
- Registrazione email e profilo Supabase già provati in precedenza.
- APK Android release compilato in CI, bundle incorporato verificato e avvio su emulatore superato nel workflow GitHub Actions run 45089072157.
- Artifact cashup-android-release presente (27.439.145 byte), con scadenza 21 febbraio 2027. Non è ancora attestato il test sullo Xiaomi fisico.
- Quattro prototipi di gioco presenti: Reflexes, Memory, Math Challenge, Quick Quiz. Il catalogo di 10.000 elementi è concettuale, non un catalogo di 10.000 giochi completi.
- Steps, punti, premi, wallet, offerte, referral e pagamenti non sono ancora verificati come flussi reali completi.
- Nessun network pubblicitario, account affiliato o partner commerciale risulta configurato.
- La Edge Function di verifica ricompense pubblicitarie esiste, ma senza segreto del provider e account/placement non è operativa.

## 3. Sequenza di lancio e criteri di uscita

### Gate A — Stabilità e fiducia
1. Testare APK su dispositivo Android fisico: installazione, apertura autonoma, login/logout, ripresa sessione, consumo batteria, comportamento offline e gestione errori.
2. Testare il sito web su browser mobile e desktop.
3. Verificare registrazione, conferma email, recupero password, sessione e salvataggio profilo.
4. Completare audit Supabase: RLS, grants, funzioni SECURITY DEFINER, limiti e idempotenza del ledger, protezione credenziali e backup.
5. Preparare privacy policy, termini, informativa cookie/consensi, contatti assistenza, esportazione e cancellazione dati con revisione professionale prima della pubblicazione.
6. Testare Health Connect su Android; test HealthKit richiede un iPhone e build iOS idonea.
**Uscita:** nessun problema critico aperto; funzioni dichiarate pubblicamente corrispondono ai test.

### Gate B — Primo ricavo commerciale
Ordine consigliato:
1. Affiliate/merchant program con accesso approvato e condizioni compatibili.
2. Primo catalogo limitato di offerte realmente disponibili, con prezzo/fonte/validità/Paese/condizioni e disclosure commerciale.
3. Tracciamento click e conversioni, riconciliazione delle commissioni e gestione dei resi/storni.
4. In parallelo valutare un network pubblicitario adatto al traffico e alle aree geografiche, senza integrarlo prima di privacy/consensi e approvazione dell'account.
5. Solo dopo verifica provider, collegare rewarded ads alla verifica server-side; non assegnare punti sulla sola base di callback client.
**Uscita:** almeno un partner approvato, un flusso commerciale testato e report di commissioni verificabili. Non presentare ricavi stimati come incassi.

### Gate C — Esperienza utente e giochi
- Base attuale: 4 prototipi.
- Obiettivo proposto: 20 giochi giocabili al lancio, ma solo dopo completamento, test, accessibilità, controlli di contenuto, salvataggio e comportamento su dispositivi mobili.
- Non promuovere come giocabili le schede concept del catalogo.
- Classifiche iniziali solo se punteggi e regole sono verificabili; niente premi monetari basati su punteggi client non protetti.
- La pubblicità nei giochi deve rispettare pause naturali, limiti di frequenza e scelta dell'utente; evitare interstitial invasivi e ricompense ingannevoli.

### Gate D — Comunicazione e acquisizione utenti
Preparare prima contenuti organici e profili ufficiali; attivare campagne a pagamento solo dopo approvazione di budget e verifica del prodotto.
Canali da valutare in base al pubblico e al Paese: Instagram, Facebook, TikTok, YouTube e Google. Non è necessario investire in tutti simultaneamente.
Misurare installazioni/registrazioni, utenti attivi, costo per registrazione, retention, conversione commerciale, commissione netta e costo di supporto.

## 4. Piano social pronto per la produzione

### Identità e messaggio
**CASHUP — IL MOVIMENTO PREMIA**  
Messaggio di lancio: “Muoviti. Gioca. Scopri. Approfitta.”  
Descrizione prudente: “CASHUP riunisce attività, intrattenimento e opportunità commerciali in un'unica piattaforma. Funzioni e offerte disponibili variano in base al Paese e alla fase di lancio.”

Non promettere guadagni, premi in denaro, cashback o partnership prima che siano effettivamente attivi e finanziati.

### Contenuti iniziali
1. Teaser brand: logo, promessa e visione.
2. Presentazione dell'app: schermate reali delle sole funzioni verificate.
3. CASHUP Games: mostrare soltanto giochi realmente completati e disponibili.
4. CASHUP Steps: pubblicare solo dopo test dispositivo e autorizzazioni.
5. CASHUP Market/Deals: pubblicare soltanto offerte e partner approvati, con disclosure.
6. Dietro le quinte: sviluppo, sicurezza e miglioramenti.
7. Lancio: link ufficiali, Paesi effettivamente serviti e supporto.

### Bozze copy social
**Teaser (IT):** “Sta arrivando CASHUP. Un nuovo modo di unire movimento, gioco e opportunità. CASHUP — IL MOVIMENTO PREMIA.”
**Launch (IT):** “CASHUP è online. Scopri le funzioni disponibili, esplora i giochi e resta aggiornato sulle nuove opportunità. Le funzioni variano in base alla disponibilità nel tuo Paese.”
**Teaser (EN):** “Meet CASHUP. Bringing movement, play and opportunities together. CASHUP — EVERY MOVE MATTERS.”
**Launch (EN):** “CASHUP is here. Explore the features currently available and follow us for new experiences and offers. Availability may vary by country.”

Questi testi sono bozze; non pubblicarli come annuncio di lancio finché il Gate A e la disponibilità effettiva non sono confermati.

## 5. Pubblicità dentro CASHUP

Possibili formati, da abilitare gradualmente:
- Banner solo in aree non critiche e senza ostacolare funzioni essenziali.
- Native ads chiaramente etichettate come sponsorizzate.
- Video rewarded facoltativi con accredito soltanto dopo verifica server-side del provider.
- Sponsorizzazioni e missioni finanziate da partner con termini chiari.

Prerequisiti: account approvato, identificativi app/placement, SDK o integrazione autorizzata, CMP/consensi ove richiesti, policy aggiornate, callback firmate, test, limiti di frequenza, report e supporto. Nessun click o impression artificiale; non chiedere agli utenti di cliccare annunci per aiutare CASHUP.

## 6. Modello di ricavo e controllo economico

Canali prioritari:
1. Commissioni affiliate su vendite confermate.
2. Offerte e campagne sponsorizzate con compensi contrattuali.
3. Pubblicità in-app quando account e consensi sono approvati.
4. In seguito, servizi B2B per venditori/partner e altre funzioni premium realmente utili.

Per ogni canale registrare: ricavo lordo, commissioni trattenute dal network, storni/resi, costi variabili, costi fissi, costo acquisizione, imposte e utile netto. Separare ricavi CASHUP da punti, crediti promozionali, cashback dovuto e denaro degli utenti.

### Budget: metodo di spesa
- Prima scelta: strumenti già disponibili e piani gratuiti adeguati.
- Ogni spesa ricorrente deve avere proprietario, motivo, costo mensile/annuale, alternativa e criterio di cancellazione.
- Nessuna campagna a pagamento senza budget massimo scritto e approvato.
- Testare un canale alla volta; aumentare il budget solo se il margine netto e la qualità degli utenti giustificano la spesa.
- Non acquistare traffico prima di avere onboarding, analitiche, assistenza e un flusso prodotto funzionante.

## 7. Materiali e attività da preparare

### Lavoro preparabile dal team di sviluppo
- QA e correzioni web/Android.
- Documentazione tecnica, inventario dati e flussi di sicurezza.
- Specifiche e QA dei giochi.
- Schermate e testi promozionali basati su funzioni effettive.
- Landing page e pagine informative, previa revisione legale.
- Modello di misurazione e report economico.
- Lista di potenziali network/merchant da valutare, senza dichiararli partner.

### Azioni che richiedono il titolare
- Verifica fisica dell'APK sul proprio telefono e test con il proprio account.
- Creazione/verifica di account commerciali e social quando richiedono identità, telefono o documenti.
- Accettazione di termini, contratti e condizioni dei partner.
- Approvazione esplicita di spese, campagne e abbonamenti.
- Scelta della forma societaria e approvazione di policy/contratti dopo consulenza qualificata.

## 8. Checklist finale pubblica

Un elemento può essere dichiarato “Disponibile” soltanto se:
- funziona nell'ambiente pubblico;
- è stato testato su dispositivi/browser supportati;
- ha testi, prezzi e condizioni corretti;
- ha permessi e privacy adeguati;
- ha un percorso di assistenza e gestione errori;
- se commerciale, ha partner, autorizzazioni e rendicontazione effettivi.

## 9. Registro delle decisioni aperte
- Primo Paese commerciale: da definire sulla base di partner e requisiti; la progettazione resta internazionale.
- Network affiliate: da selezionare e approvare.
- Network pubblicitario: da selezionare e approvare.
- Budget di test: da proporre dopo preventivi e analisi, poi approvare dal titolare.
- 20 giochi: obiettivo di lancio subordinato a completamento e QA.
- iOS: test e pubblicazione richiedono build firmata e dispositivo Apple idoneo.
- Documenti legali e fiscali: revisione da professionista competente prima dell'attività commerciale.
