(() => {
  const start = () => {
    const home = document.getElementById("home");
    if (!home || document.getElementById("cashup-engagement")) return;
    const panel = document.createElement("section");
    panel.id = "cashup-engagement";
    panel.className = "section auth-card";
    panel.innerHTML = `
      <h2 style="margin-top:0">Torna ogni giorno su CASHUP ✨</h2>
      <p class="muted">Ogni giorno trovi attività, giochi e offerte da scoprire. Le missioni si aggiornano ogni giorno.</p>
      <div class="grid">
        <div class="card"><div class="emoji">📅</div><h3>Visite di oggi</h3><p><strong id="cashup-visits">0 / 3</strong><br>Apri CASHUP in momenti diversi della giornata.</p></div>
        <div class="card"><div class="emoji">🎮</div><h3>Missione giochi</h3><p>Prova un gioco disponibile e scopri le novità.</p><a href="/games/" style="color:#42e890">Vai a CASHUP GAMES</a></div>
        <div class="card"><div class="emoji">👟</div><h3>Missione passi</h3><p>Controlla i tuoi passi giornalieri in CASHUP Steps.</p><button class="secondary" id="cashup-go-steps" type="button">Apri Steps</button></div>
        <div class="card"><div class="emoji">🎁</div><h3>Offerte sponsorizzate</h3><p id="cashup-ad-status">Le campagne e i video con premio saranno attivati dopo il collegamento e la verifica del fornitore pubblicitario.</p></div>
      </div>
      <div class="section" style="border-top:1px solid #294333;padding-top:14px">
        <h3>Promemoria CASHUP 🔔</h3>
        <p class="muted">Scegli quanti promemoria ricevere. Nessun avviso ogni 10 o 20 minuti: massimo 3 al giorno, disattivabili quando vuoi.</p>
        <label for="cashup-reminder-count">Promemoria al giorno</label>
        <select id="cashup-reminder-count" style="width:100%;padding:12px;background:#0b150e;border:1px solid #42634b;border-radius:10px;color:white">
          <option value="1">1 al giorno · ore 18:00</option>
          <option value="2">2 al giorno · ore 12:00 e 18:00</option>
          <option value="3" selected>3 al giorno · ore 10:00, 15:00 e 20:00</option>
        </select>
        <div class="actions">
          <button class="primary" id="cashup-enable-reminders" type="button">Attiva promemoria</button>
          <button class="secondary" id="cashup-disable-reminders" type="button">Disattiva</button>
        </div>
        <p id="cashup-reminder-status" class="auth-status" aria-live="polite">I promemoria sono facoltativi. Attivali solo se li desideri.</p>
      </div>
      <p class="muted" style="font-size:11px">Le aperture dell’app da sole non assegnano punti. Le visite vengono conteggiate per migliorare l’esperienza; i premi arrivano solo dopo la verifica lato server di missioni o visualizzazioni pubblicitarie completate.</p>
    `;
    home.appendChild(panel);
    const today = () => { const d=new Date(); return d.getFullYear()+"-"+String(d.getMonth()+1).padStart(2,"0")+"-"+String(d.getDate()).padStart(2,"0"); };
    const key = "cashup_engagement_v1";
    let state = {};
    try { state = JSON.parse(localStorage.getItem(key) || "{}") || {}; } catch (_) {}
    const date = today();
    if (state.date !== date) state = {date, visits:0, lastVisit:0};
    const updateVisitCounter = () => {
      const currentDate=today(), now=Date.now();
      if (state.date !== currentDate) state = {date:currentDate,visits:0,lastVisit:0};
      if (!state.lastVisit || now - state.lastVisit >= 30*60*1000) {
        state.visits = Math.min(3, (Number(state.visits)||0)+1);
        state.lastVisit = now;
        try { localStorage.setItem(key, JSON.stringify(state)); } catch (_) {}
      }
      const counter=document.getElementById("cashup-visits");
      if(counter) counter.textContent=(state.visits||0)+" / 3";
    };
    updateVisitCounter();
    document.addEventListener("visibilitychange",()=>{if(!document.hidden)updateVisitCounter();});
    document.getElementById("cashup-go-steps").addEventListener("click", () => {
      const btn=document.querySelector('nav button[data-page="steps"]');
      if(btn) btn.click();
    });
    const count = document.getElementById("cashup-reminder-count");
    const savedCount = localStorage.getItem("cashup_reminder_count_v1");
    if (savedCount && ["1","2","3"].includes(savedCount)) count.value=savedCount;
    const status = document.getElementById("cashup-reminder-status");
    document.getElementById("cashup-enable-reminders").addEventListener("click", async () => {
      const bridge=window.CASHUP_NATIVE_NOTIFICATIONS;
      if (!bridge || typeof bridge.scheduleDailyReminders !== "function") {
        status.textContent="Per programmare promemoria anche con CASHUP chiusa serve la versione installata nativa. Nel browser questa funzione non è ancora disponibile.";
        return;
      }
      const times = (count.value==="1" ? ["18:00"] : count.value==="2" ? ["12:00","18:00"] : ["10:00","15:00","20:00"]);
      status.textContent="Richiesta del permesso notifiche…";
      try {
        await bridge.scheduleDailyReminders(times);
        localStorage.setItem("cashup_reminder_count_v1",count.value);
        if (typeof window.CASHUP_SAVE_NOTIFICATION_PREFS === "function") {
          try { await window.CASHUP_SAVE_NOTIFICATION_PREFS(true,times); } catch (_) {}
        }
        status.textContent="Promemoria attivati. Puoi disattivarli in qualsiasi momento.";
      } catch (error) {
        status.textContent=error?.message || "Non è stato possibile attivare i promemoria.";
      }
    });
    document.getElementById("cashup-disable-reminders").addEventListener("click", async () => {
      const bridge=window.CASHUP_NATIVE_NOTIFICATIONS;
      if (!bridge || typeof bridge.cancelDailyReminders !== "function") {
        status.textContent="Apri la versione installata di CASHUP per gestire i promemoria programmati.";
        return;
      }
      try {
        await bridge.cancelDailyReminders();
        localStorage.removeItem("cashup_reminder_count_v1");
        if (typeof window.CASHUP_SAVE_NOTIFICATION_PREFS === "function") {
          try { await window.CASHUP_SAVE_NOTIFICATION_PREFS(false,[]); } catch (_) {}
        }
        status.textContent="Promemoria disattivati.";
      } catch (error) { status.textContent=error?.message || "Non è stato possibile disattivare i promemoria."; }
    });
  };
  if (document.readyState === "loading") document.addEventListener("DOMContentLoaded",start); else start();
})();