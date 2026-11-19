# CASHUP BRAIN — verifiche manuali prima del rilascio

Questa lista contiene solo attività che richiedono l'accesso del fondatore alle console o a un dispositivo reale. Non condividere password, chiavi, codici MFA, QR o stringhe di connessione in chat.

## 1. Supabase — Data API (priorità massima)
1. Aprire il progetto CASHUP nella Dashboard Supabase.
2. Aprire **Integrations → Data API** (in alcune versioni la voce può essere sotto **Settings → API**).
3. In **Exposed schemas**, lasciare esposto solo lo schema necessario all'applicazione, attualmente `public`; verificare che `private` NON sia presente.
4. Disattivare **Automatically expose new tables** (o la voce equivalente).
5. Salvare e ricontrollare la configurazione.

Motivo: la funzione fondatore è nello schema `private`; inoltre i default ACL gestiti da Supabase per il ruolo `supabase_admin` in `public` non sono modificabili dal ruolo del progetto. Evitare di installare estensioni nello schema `public`.

## 2. Supabase — autenticazione
1. Aprire **Authentication → URL Configuration**.
2. Impostare il Site URL sul dominio CASHUP definitivo e rimuovere redirect URL non utilizzati o di test.
3. Aprire le impostazioni di **Rate Limits** e verificare i limiti per login, OTP e invio email.
4. Configurare CAPTCHA se disponibile e compatibile con il flusso.
5. Non cambiare dominio/RP ID dopo aver registrato passkey.

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
5. Verificare gli header HTTP effettivi: CSP, HSTS, X-Frame-Options, nosniff, Referrer-Policy, Permissions-Policy, Cache-Control no-store e X-Robots-Tag.
6. Testare che il login TOTP/passkey funzioni con la CSP attiva.

## 5. GitHub — repository
1. Attivare MFA per l'account GitHub.
2. In **Settings → Code security and analysis**, attivare secret scanning, push protection, Dependabot alerts e security updates se disponibili.
3. In **Settings → Branches / Rulesets**, proteggere `main`: bloccare force-push e cancellazione; richiedere controlli CI superati prima del merge.
4. Verificare il workflow **CASHUP BRAIN static security checks** e mantenere i permessi minimi.
5. Non aggiungere segreti al repository. La chiave publishable Supabase è pubblica; una service-role key non deve mai stare nel browser.

## 6. Backup e ripristino
Il piano Supabase Free non offre backup automatici giornalieri.
1. Eseguire un'esportazione manuale del database e dei dati necessari all'autenticazione usando gli strumenti ufficiali Supabase.
2. Cifrare il backup e conservarlo fuori dal progetto e fuori dal repository GitHub.
3. Non incollare stringhe di connessione o password in chat.
4. Provare il ripristino in un ambiente separato prima di considerare affidabile il backup.
5. Ripetere l'esportazione dopo ogni modifica importante a schema o dati.

## Criterio finale
CASHUP BRAIN non è pronto per la produzione finché tutte le verifiche sopra non hanno evidenza verificabile. Il branch di lavoro non va unito a `main` e la console non va pubblicata senza un'autorizzazione specifica.
