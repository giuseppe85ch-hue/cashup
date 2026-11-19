# CASHUP BRAIN — configurazione passkey e biometria

## Obiettivo
Consentire al fondatore di usare una passkey WebAuthn. Il telefono o il gestore credenziali può chiedere impronta digitale, riconoscimento del volto, PIN o chiave di sicurezza. CASHUP non riceve né memorizza dati biometrici: riceve solo la prova crittografica WebAuthn.

## Stato
- Il client web è predisposto con l'opt-in sperimentale Supabase JS `auth.experimental.passkey: true`.
- La console consente accesso con passkey, registrazione e rimozione dopo MFA AAL2.
- Supabase Passkeys è una funzione sperimentale e va abilitata nella Dashboard Auth prima di usarla.
- Nessuna passkey risulta ancora registrata nel progetto.
- La registrazione passkey non sostituisce TOTP: l'accesso alla console continua a richiedere AAL2. Dopo l'accesso passkey, la console richiede comunque il codice TOTP finché Supabase non espone un flusso MFA passkey con livello AAL2 supportato.

## Configurazione Supabase da eseguire solo dopo aver scelto il dominio definitivo
Aprire Supabase Dashboard → Authentication → Passkeys:
1. Abilitare **Enable Passkey authentication**.
2. Relying Party Display Name: `CASHUP BRAIN`.
3. Relying Party ID: il solo hostname definitivo, senza schema, percorso o porta. Per esempio `cashup-859.pages.dev` solo se questo resta il dominio definitivo.
4. Relying Party Origins: solo l'origine HTTPS esatta, per esempio `https://cashup-859.pages.dev`.
5. Non aggiungere domini di preview, wildcard o domini non controllati.
6. Non cambiare il RP ID dopo aver registrato passkey: il cambio rende inutilizzabili le credenziali già registrate.

## Test obbligatori prima del rilascio
- Browser Android supportato e HTTPS.
- Registrazione passkey dopo autenticazione fondatore AAL2.
- Verifica che Android mostri il gestore credenziali e che almeno un metodo locale (biometria o PIN) funzioni.
- Nuovo accesso con passkey e completamento TOTP AAL2.
- Rifiuto di account non fondatore anche con passkey valida.
- Rimozione di una passkey e verifica che non sia più accettata.
- Verificare il comportamento su dispositivo senza biometria: il PIN o il blocco schermo può essere il fallback.
- Verificare il recupero account prima di rimuovere l'unico fattore TOTP o l'unica passkey.

## Limiti e privacy
- Il sito non può imporre che il dispositivo usi proprio l'impronta invece del volto o del PIN: la scelta è gestita dal sistema operativo e dal browser.
- La biometria non viene inviata a Supabase.
- Passkeys Supabase è sperimentale; tenere TOTP come secondo fattore e mantenere un metodo di recupero indipendente.
- Non pubblicare la console prima di proteggere l'hosting con accesso privato (es. Cloudflare Access) e verificare le intestazioni HTTP.
