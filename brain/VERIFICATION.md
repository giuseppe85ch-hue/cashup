# CASHUP BRAIN — stato di verifica aggiornato

Ultimo controllo diretto sul progetto Supabase CASHUP: 19 novembre 2026.

## Completato e verificato
- [x] Progetto corretto `fzcricigqqpzcujrenkf`, stato ACTIVE_HEALTHY.
- [x] Migrazioni di hardening 0004, 0005, 0006 e 0007 applicate tramite connessione Supabase e presenti nella cronologia remota con versioni timestamp.
- [!] Le migrazioni iniziali 0001–0003 risultano applicate manualmente in precedenza (tabelle e funzione esistono), ma non compaiono nella cronologia remota restituita da Supabase. Prima di usare `db push`, `db reset`, creare branch DB o ricostruire il progetto, occorre riallineare il baseline senza rieseguire queste DDL sul database attivo.
- [x] 7 tabelle BRAIN presenti, tutte con RLS e FORCE RLS.
- [x] 8 policy BRAIN previste e nessuna policy aggiuntiva.
- [x] 8 agenti registrati, nessuno attivo.
- [x] 5 impostazioni conservative presenti: autonomia false, emergency stop true, spesa automatizzata 0, approvazione finanziaria true, approvazione alto rischio true.
- [x] Funzione privata SECURITY DEFINER con search_path vuoto, EXECUTE negato ad anon e consentito ad authenticated, requisito AAL2 nel corpo funzione; funzione pubblica precedente assente.
- [x] Schema private: USAGE negato ad anon e consentito ad authenticated.
- [x] Grants BRAIN: zero privilegi diretti per anon e service_role; founder table sola lettura per authenticated; audit solo SELECT/INSERT.
- [x] Tabelle CASHUP applicative: nessun privilegio anon, nessun TRUNCATE/REFERENCES/TRIGGER per anon/authenticated/service_role; grants authenticated limitati alle operazioni richieste dalle policy.
- [x] Default privileges del ruolo postgres in public revocati per nuovi oggetti tabella, sequenza e funzione; EXECUTE su nuove funzioni create da postgres revocato anche a PUBLIC.
- [x] Test RLS con identità fondatore: funzione true e visibili gli 8 agenti/5 impostazioni.
- [x] Test RLS non fondatore AAL1/AAL2: funzione false e zero righe BRAIN visibili.
- [x] Test RLS fondatore: AAL1 negato e zero agenti visibili; AAL2 autorizzato e 8 agenti visibili.
- [x] Policy utente ottimizzate con `(select auth.uid())`; indici aggiunti sulle 9 chiavi esterne segnalate.
- [x] Security Advisor dopo le modifiche: resta un avviso Auth per Leaked Password Protection disattivata.
- [x] Performance Advisor: nessun avviso di foreign key non indicizzate e nessun avviso RLS initplan; restano solo avvisi informativi per indici nuovi/non ancora utilizzati.

## Da completare fuori dal database
- [ ] Leaked Password Protection non attivabile sul piano Free: Supabase la rende disponibile dal piano Pro. Nessun upgrade è stato richiesto o eseguito; usare password lunga/unica e MFA finché il progetto resta Free.
- [ ] Configurare e testare MFA per l'account fondatore: il database mostra 0 fattori registrati. Il flusso TOTP/AAL2 è stato aggiunto alla dashboard e al database ma non ancora collaudato nel browser.
- [ ] Abilitare Passkeys nelle impostazioni Supabase Auth e configurare RP ID/origins sul dominio HTTPS definitivo; nessuna passkey è ancora registrata. La funzione Supabase è sperimentale. La console richiede comunque TOTP AAL2. TOTP è disponibile nel progetto senza richiedere un upgrade.
- [ ] Verificare redirect URL, rate limits, CAPTCHA e schemi esposti nella Data API; mantenere `private` non esposto. La configurazione esposta non è leggibile dal catalogo SQL disponibile.
- [ ] Verificare secret scanning, push protection, MFA GitHub e protezione branch.
- [ ] Verificare backup/retention e fare un test di ripristino.
- [ ] Pubblicare la dashboard solo su hosting privato/protetto; applicare davvero gli header HTTP di `_headers` nella root del sito, con regole limitate a `/brain/dashboard/*`.
- [x] Codice client predisposto per passkey WebAuthn (registrazione, accesso, elenco e revoca) senza trattare o memorizzare dati biometrici.
- [ ] Test end-to-end nel browser con login reale, enrollment TOTP, challenge AAL2 e verifica della console.
- [ ] Testare header CSP/HSTS/anti-framing sul dominio effettivo.
- [ ] Eseguire una revisione indipendente prima di qualsiasi attivazione di agenti o automazioni.

## Vincoli attivi
- Nessun merge in `main` e nessun deploy Cloudflare eseguito.
- Console BRAIN non pubblicata.
- Nessun agente attivo e nessuna automazione.
- `autonomy_enabled=false`, `emergency_stop=true`, `max_automated_spend_eur=0`.
- Pagamenti, contratti, accessi sensibili e azioni irreversibili richiedono approvazione umana.

## Nota
Questi test dimostrano i controlli esaminati nel database, non una sicurezza assoluta né una certificazione di sicurezza. Le impostazioni Auth, GitHub, Cloudflare, backup e il test end-to-end restano separati e non vanno dichiarati completati finché non sono verificati con evidenza.