# CASHUP

CASHUP è un prototipo web/PWA internazionale in sviluppo. La versione attuale è dimostrativa: registrazione e accesso email sono predisposti; contapassi reale, ricompense, cashback, pagamenti e partnership commerciali non sono ancora attivi.

## Componenti
- `index.html`, `manifest.webmanifest`, `sw.js`: prototipo web/PWA.
- `brain/`: preparazione separata di CASHUP BRAIN, console privata del fondatore, schema database, verifiche e modello di sicurezza.
- `.github/workflows/cashup-brain-checks.yml`: controlli statici del codice BRAIN; non pubblica né distribuisce l'app.

## Stato e sicurezza
- Il database Supabase è su piano Free e usa RLS sulle tabelle applicative e BRAIN.
- CASHUP BRAIN resta in modalità conservativa: agenti inattivi, autonomia disattivata, arresto di emergenza attivo e limite spesa automatizzata pari a zero.
- La console BRAIN non è pubblicata e non deve essere distribuita prima di completare MFA del fondatore, impostazioni Data API, protezione hosting, controlli GitHub e backup verificato.
- Il prototipo non gestisce denaro reale e non deve essere presentato come servizio di pagamento o programma premi attivo.

## Sviluppo
Il branch di lavoro è `cashup-brain-setup`; `main` non viene modificato automaticamente. Le migrazioni e le istruzioni sono documentate in `brain/README.md` e `brain/VERIFICATION.md`.

Non inserire mai chiavi `service_role`, segreti o password nel codice client o nel repository.
