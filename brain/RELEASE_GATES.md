# CASHUP BRAIN — verifiche manuali prima del rilascio

Questa lista contiene solo attività che richiedono l'accesso del fondatore alle console o a un dispositivo reale. Non condividere password, chiavi, codici MFA, QR o stringhe di connessione in chat.

## 1. Supabase — Data API (priorità massima)
1. Aprire il progetto CASHUP nella Dashboard Supabase.
2. Aprire **Integrations → Data API** (in alcune versioni la voce può essere sotto **Settings → API**).
3. Verificare che `private` NON sia tra gli schemi esposti. Lasciare `public` e solo eventuali schemi strettamente necessari; `graphql_public` soltanto se GraphQL è effettivamente utilizzato.
4. Disattivare **Automatically expose new tables and functions** (o le voci equivalenti).
5. Salvare e ricontrollare la configurazione.

Motivo: la funzione fondatore è nello schema `private`; inoltre i default ACL gestiti da Supabase per il ruolo `supabase_admin` in `public` non sono modificabili dal ruolo del progetto. Evitare di installare estensioni nello schema `public`.

## 2. Supabase — autenticazione
1. Aprire **Authentication → URL Configuration**.
2. Impostare il Site URL sul dominio CASHUP definitivo e rimuovere redirect URL non utilizzati o di test.
3. Impostare la lunghezza minima password a 12 caratteri (il client la richiede già; il controllo server Auth deve essere allineato). Leaked Password Protection è deliberatamente esclusa sul piano Free perché richiede un upgrade a pagamento: nessun upgrade è autorizzato.
4. Aprire le impostazioni di **Rate Limits** e verificare i limiti per login, OTP e invio email.
5. Configurare CAPTCHA se disponibile e compatibile con il flusso.
6. Non cambiare dominio/RP ID dopo aver registrato passkey.

## 3. MFA del fondatore
1. Prima di pubblicare la console, predisporre l'accesso privato all'URL `/brain/dashboard` con Cloudflare Access.
2. Accedere alla console protetta con l'account fondatore.
3. Completare l'iscrizione TOTP con un'app autenticatrice e verificare il primo codice.
4. Uscire, rientrare e verificare che AAL2 sia richiesto prima di mostrare dati.
5. Conservare un metodo di recupero sicuro. Non rimuovere l'unico fattore funzionante.
6. Solo dopo aver scelto il dominio definitivo, abilitare Passkeys in Supabase Auth e configurare RP ID/origins esatti; testare su Android. Le passkey Supabase sono sperimentali e non sostituiscono il requisito TOTP attuale.

## 4. Cloudflare — protezione hosting
1. Creare un'applicazione Cloudflare Access self-hosted per il solo percorso `/brain/dashboard*`.
2. Consentire esclusivamente l'identità del fondatore; richiedere MFA.
3. Verificare da una finestra anonima che senza autenticazione la console non sia raggiungibile.
4. Pubblicare il branch solo dopo approvazione esplicita.
5. Verificare gli header HTTP effettivi: CSP strict senza unsafe-inline, HSTS, X-Frame-Options, nosniff, Referrer-Policy, Permissions-Policy, Cache-Control no-store e X-Robots-Tag. La CSP root richiede che `app.js` e `styles.css` restino esterni e che l'SDK esm.sh resti fissato alla versione approvata.
6. Testare che il login TOTP/passkey funzioni con la CSP attiva.

## 5. GitHub — repository
1. Il repository risulta attualmente **pubblico**: tutti i file e i branch, inclusi codice e documentazione BRAIN, sono leggibili da chiunque. Verificare prima che Cloudflare Pages possa continuare a leggere il repository privato; poi cambiare la visibilità in **Settings → General → Danger Zone → Change repository visibility**. Non ho modificato questa impostazione.
2. Attivare MFA per l'account GitHub.
3. In **Settings → Code security and analysis**, attivare secret scanning, push protection, Dependabot alerts e security updates se disponibili.
4. In **Settings → Branches / Rulesets**, proteggere `main`: bloccare force-push e cancellazione; richiedere controlli CI superati prima del merge.
5. Verificare il workflow **CASHUP BRAIN static security checks** e mantenere i permessi minimi.
6. Non aggiungere segreti al repository. La chiave publishable Supabase è pubblica; una service-role key non deve mai stare nel browser.

## 6. Backup e ripristino
Il piano Supabase Free non offre backup automatici giornalieri.
1. Eseguire un'esportazione manuale del database e dei dati necessari all'autenticazione usando gli strumenti ufficiali Supabase.
2. Cifrare il backup e conservarlo fuori dal progetto e fuori dal repository GitHub.
3. Non incollare stringhe di connessione o password in chat.
4. Provare il ripristino in un ambiente separato prima di considerare affidabile il backup.
5. Ripetere l'esportazione dopo ogni modifica importante a schema o dati.

## 7. Proprietà intellettuale, marchio e reputazione
1. Aprire `IP_PROTECTION_PLAN.md` e completare la verifica del titolare giuridico dei diritti.
2. Eseguire ricerca anteriorità CASHUP e logo su UIBM, EUIPO/TMview e WIPO; valutare deposito con consulente.
3. Inventariare autori e licenze di codice, font, icone, immagini, testi, video e componenti di terzi.
4. Ottenere accordi scritti su riservatezza e diritti economici da sviluppatori, grafici, agenzie e collaboratori.
5. Conservare prove datate, hash, commit e release firmate; valutare deposito SIAE del software.
6. Proteggere domini, DNS, email e account social; impostare SPF, DKIM e DMARC.
7. Definire procedura per impersonificazione, frode, copia del marchio e diffamazione: conservazione prove, segnalazioni e assistenza legale.


## 8. Pacchetti a pagamento, anti-pirateria e ban
Prima di vendere qualsiasi pacchetto premium:
1. Scegliere e collegare il provider di pagamento/store senza mettere segreti nel client.
2. Verificare sul server ogni ricevuta o webhook: firma, prodotto, importo, valuta, ambiente, utente, scadenza e stato.
3. Implementare entitlement server-side con idempotenza, protezione replay, rinnovi, scadenze, rimborsi, chargeback e revoche.
4. Far verificare l'entitlement a ogni API che consegna contenuti premium o esegue azioni a pagamento.
5. Provare bypass del client, REST diretto, replay, downgrade, token scaduti, acquisti rimborsati e account diversi.
6. Implementare rate limit, rilevamento anomalie e casi antifrode con prove verificabili.
7. Consentire limitazioni progressive e sospensioni temporanee; ban permanenti solo con prove e revisione umana, motivazione e ricorso.
8. Non attivare blocchi automatici basati soltanto su IP, VPN, device fingerprint o punteggio AI.
9. Non vendere pacchetti finché test end-to-end, assistenza e procedura di ricorso non sono pronti.

**Stato attuale:** pacchetti a pagamento, provider, webhook, entitlement e ban applicativi non sono implementati. CASHUP continua a mostrare contenuti dimostrativi; nessun acquisto reale è attivo.

## Criterio finale
CASHUP BRAIN non è pronto per la produzione finché tutte le verifiche sopra non hanno evidenza verificabile. Il branch di lavoro non va unito a `main` e la console non va pubblicata senza un'autorizzazione specifica.
