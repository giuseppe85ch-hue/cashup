# CASHUP — piano di tutela della proprietà intellettuale, del marchio e del know-how

Data di redazione: 19 novembre 2026.

Questo documento è un piano operativo, non un parere legale e non certifica la titolarità di diritti che non siano stati documentati. Prima di usare il marchio in commercio, depositare domande o firmare contratti, far verificare titolarità, anteriorità e classi da un professionista IP.

## 1. Cosa è proteggibile e cosa no

- Il codice sorgente originale, la grafica, i testi, i documenti e altri contenuti creativi possono essere protetti dal diritto d'autore.
- Il diritto d'autore non monopolizza una semplice idea, un modello di business, una funzione o un metodo: protegge la forma espressiva concreta. Una funzione simile realizzata autonomamente con codice diverso può non violare il copyright.
- Il nome CASHUP, il logo e gli altri segni distintivi vanno valutati come marchi. La protezione dipende da ricerca di anteriorità, distintività, classi e territori; l'uso del nome o il possesso del dominio non equivalgono a una registrazione.
- Algoritmi interni, modelli antifrode, criteri di scoring, condizioni commerciali, prezzi riservati, liste partner non pubbliche, roadmap e procedure possono costituire segreti commerciali solo se hanno valore perché segreti e vengono protetti con misure ragionevoli.

## 2. Uso di output e strumenti AI

- Le condizioni europee OpenAI disponibili al 19 novembre 2026 prevedono, nei rapporti tra utente e OpenAI e nei limiti di legge, la titolarità dell'utente sull'Output e la cessione dei diritti eventualmente detenuti da OpenAI. Non comprendono contenuti di terzi e non garantiscono esclusività: output simili possono essere generati per altri utenti.
- Le condizioni consumer europee descrivono il servizio individuale per uso personale/non commerciale. Poiché CASHUP è un progetto destinato al commercio, verificare le condizioni applicabili all'uso commerciale e agli strumenti utilizzati prima del lancio; non assumere che la clausola di titolarità risolva da sola ogni questione.
- Ogni output va controllato per originalità, accuratezza, marchi, copyright e licenze di terzi. Conservare le decisioni umane, le modifiche originali e le fonti degli asset.

## 3. Stato attuale e rischio immediato

- Il repository GitHub `giuseppe85ch-hue/cashup` risulta PUBBLICO. Sorgente, branch e documentazione sono leggibili. Il branch di lavoro è 132 commit avanti rispetto a main al controllo iniziale di questo ciclo.
- Non è stato possibile cambiare la visibilità con gli strumenti disponibili. Non è stato eseguito alcun cambio.
- Rendere privato il repository riduce l'accesso futuro al sorgente, ma non recupera copie già scaricate, fork pubblici o archivi esterni. GitHub avverte che i fork pubblici già esistenti restano pubblici e vengono separati dalla rete del repository.
- Il sito CASHUP è ospitato separatamente su Cloudflare Pages. Prima di rendere privato il repository bisogna verificare che l'integrazione Cloudflare conservi l'accesso al repository privato e che il deploy non venga interrotto.
- Il file PNG referenziato come icona PWA (circa 1,6 MB, nome file generato) deve essere associato a una prova di provenienza/creazione o licenza prima del rilascio.
- Nessuna licenza open-source è stata individuata nella root del branch main. Non aggiungere una licenza permissiva senza una decisione esplicita del titolare dei diritti.
- Il codice contiene una chiave Supabase publishable: è una chiave pubblica prevista per il client, non una credenziale segreta. Non inserire mai chiavi secret/service_role, password, token personali, credenziali DNS o stringhe DB nel repository.

## 4. Azioni prioritarie sul codice e sul know-how

1. Verificare e, se confermato, rendere privato il repository GitHub; prima verificare Cloudflare Pages e l'accesso dei deploy.
2. Limitare i collaboratori al minimo indispensabile; MFA obbligatoria, account individuali, nessuna condivisione di account.
3. Tenere in repository privato soltanto il codice necessario; conservare piani commerciali, credenziali, contratti, liste partner, modelli antifrode e roadmap riservate in un archivio separato cifrato e con accesso limitato.
4. Attivare secret scanning e push protection, Dependabot e code scanning secondo le funzionalità disponibili; esaminare gli alert e lo storico.
5. Proteggere `main` con regole: blocco force-push e cancellazione, controlli obbligatori, review indipendente e release firmate.
6. Separare sviluppo, staging e produzione; usare chiavi e database distinti, privilegi minimi e rotazione immediata in caso di sospetta esposizione.
7. Conservare copie periodiche cifrate del codice, migrazioni, configurazioni e dati; almeno una copia off-site non modificabile dall'account operativo quotidiano.
8. Firmare tag/release e conservare manifest SHA-256, commit, data, autore effettivo, ricevute e versioni approvate.

## 5. Prova di titolarità e catena dei diritti

- Conservare bozze, wireframe, disegni, specifiche, versioni sorgenti, cronologia commit, export datati e ricevute in un archivio controllato.
- Per il software, valutare il deposito nel Pubblico Registro Software SIAE come elemento probatorio dell'esistenza, della data e dei dati di autore/titolare dichiarati; verificare requisiti e costi direttamente con SIAE.
- Identificare chi ha effettivamente creato ogni componente: codice, logo, icone, font, immagini, testi, video, audio, modelli e documentazione.
- Prima di coinvolgere sviluppatori, grafici, agenzie, consulenti o collaboratori, usare accordi scritti su riservatezza, titolarità e cessione/licenza dei diritti economici, consegna di sorgenti e materiali, componenti preesistenti, open-source e uso di strumenti AI.
- Per dipendenti e collaboratori si applicano regole diverse a seconda del rapporto e della legge; non presumere che il pagamento di una fattura trasferisca automaticamente tutti i diritti.
- Mantenere un inventario delle dipendenze con versione, licenza, provenienza e obblighi di attribuzione. Non copiare codice, immagini, loghi, testi o database di terzi senza titolo o licenza.

## 6. Protezione del marchio CASHUP

1. Eseguire una ricerca di anteriorità per CASHUP e segni simili nei database ufficiali (UIBM, EUIPO/eSearch plus, TMview e WIPO Global Brand Database).
2. Far valutare distintività, conflitti, titolare corretto e classi di Nizza per software/app, servizi digitali, marketplace, pubblicità, servizi finanziari o premi, secondo ciò che verrà realmente offerto.
3. Se la ricerca è favorevole, valutare il deposito separato del marchio denominativo CASHUP e del marchio figurativo/logo.
4. Per tutela UE valutare EUIPO; per l'Italia UIBM; per estensioni internazionali valutare il sistema di Madrid tramite WIPO con consulenza.
5. Registrare domini e profili social coerenti, con account intestati al titolare corretto, MFA e recupero indipendente.
6. Non usare il simbolo ® prima della registrazione effettiva; non dichiarare che il marchio è registrato se non lo è.

## 7. Segreti commerciali e accordi

- Classificare ogni documento: pubblico, interno, riservato o segreto commerciale.
- Applicare accesso need-to-know, cifratura, MFA, log accessi, divieto di condivisione non autorizzata e revoca immediata degli accessi non più necessari.
- NDA e clausole di riservatezza devono essere specifiche e ragionevoli; non sostituiscono la sicurezza tecnica e non rendono segreto ciò che è già pubblico.
- Non pubblicare in demo, repository, presentazioni o screenshot formule, soglie antifrode, condizioni partner riservate o dettagli operativi non necessari.
- Conservare prova di quali informazioni erano segrete, chi vi ha avuto accesso e quali misure concrete sono state adottate.

## 8. Difesa da imitazione, impersonificazione e falsificazione

- Proteggere domini e DNS con MFA, registrar lock, auto-renew e account recovery sicuro.
- Configurare SPF, DKIM e DMARC sul dominio email ufficiale prima di inviare comunicazioni commerciali; iniziare monitorando e poi valutare una policy di enforcement.
- Pubblicare una pagina ufficiale che elenchi domini, canali social e indirizzi di contatto autentici.
- Usare release firmate, changelog ufficiali e canali verificabili per consentire agli utenti di riconoscere comunicazioni autentiche.
- Monitorare periodicamente domini simili, profili social imitativi, app store e marketplace; conservare prove con URL, data/ora, screenshot, headers e copie originali.
- In caso di impersonificazione, frode o diffamazione: non rispondere con accuse non provate; conservare le prove, segnalare al provider/piattaforma e chiedere assistenza legale per diffide o azioni appropriate. Non è possibile impedire a priori che qualcuno pubblichi contenuti falsi.

## 9. Controlli tecnici anti-manomissione

- MFA resistente al phishing (passkey/hardware security key) per account principali, più TOTP di recupero protetto.
- Cloudflare Access davanti alla console BRAIN, non soltanto login applicativo.
- Database con RLS, grants minimi, RPC validate e audit generato lato database; il client non deve poter scrivere eventi audit arbitrari.
- Registro database append-only per il client non equivale a immutabilità contro proprietari DB, superuser o provider. Per prove resistenti a manomissione amministrativa, esportare periodicamente hash e audit in archivio separato con retention/WORM o firma digitale.
- Rate limit, CAPTCHA dove utile, monitoraggio login, alert di anomalie, rotazione/revoca sessioni e chiavi.
- Test indipendenti di sicurezza prima del rilascio e dopo cambiamenti significativi.

## 10. Reputazione e incident response

- Preparare un protocollo: confermare l'incidente, preservare prove, bloccare accessi compromessi, ruotare segreti, ripristinare da backup pulito, informare utenti/partner in modo accurato e documentare le decisioni.
- Per accuse false o campagne diffamatorie, conservare il contesto completo e chiedere valutazione legale; distinguere critica legittima, errore fattuale e condotta illecita.
- Mai pubblicare dati personali, credenziali o informazioni riservate come ritorsione.
- Predisporre un canale ufficiale per segnalazioni di sicurezza e frodi.

## 11. Decisioni ancora necessarie

- [ ] Confermare il titolare giuridico dei diritti (persona fisica o società futura) prima di depositi e contratti.
- [ ] Verificare che la visibilità privata GitHub sia compatibile con Cloudflare Pages; poi decidere il cambio.
- [ ] Ricerca anteriorità del marchio CASHUP e del logo.
- [ ] Valutare deposito marchio UIBM/EUIPO/WIPO e deposito software SIAE; comportano costi e non sono stati avviati.
- [ ] Verificare contratti/cessioni per ogni contributore e licenze di tutte le componenti di terzi.
- [ ] Attivare protezione dominio/email e monitoraggio anti-impersonificazione.
- [ ] Preparare backup off-site e registro prove con firme/hash.

## Riferimenti informativi

- Commissione Europea IP Helpdesk: copyright e limiti della protezione delle idee.
- Direttiva UE 2016/943: segreti commerciali e necessità di misure ragionevoli per mantenerli segreti.
- EUIPO: ricerca e registrazione del marchio UE.
- SIAE: Pubblico Registro Software.
- GitHub Docs: effetti del passaggio da repository pubblico a privato.

Questo piano non garantisce che nessuno possa copiare o attaccare CASHUP; costruisce invece controlli, prove e rimedi per ridurre il rischio e reagire in modo documentato.
