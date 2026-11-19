import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const status = document.getElementById("cloud-progress-status");
const supabase = createClient(
  "https://fzcricigqqpzcujrenkf.supabase.co",
  "sb_publishable_uy1xJ_55eYnmne1K8UrBQg_lV3LEyae"
);

let currentUser = null;
let sessionReady = false;
const pendingEvents = [];

async function saveProgress(detail) {
  const gameId = String(detail.key || "");
  if (!/^(reflex|memory|math|quiz)$/.test(gameId) || !currentUser) return;
  const best = Math.max(0, Math.floor(Number(detail.best ?? detail.score) || 0));
  const score = Math.max(0, Math.floor(Number(detail.score) || 0));
  const plays = Math.max(1, Math.floor(Number(detail.plays) || 1));
  const { error } = await supabase.from("player_game_progress").upsert({
    user_id: currentUser.id,
    game_id: "cashup-" + gameId,
    save_slot: 1,
    progress: { best_score: best, total_plays: plays, last_score: score },
    level: 1,
    score: best,
    play_time_seconds: 0,
    updated_at: new Date().toISOString()
  }, { onConflict: "user_id,game_id,save_slot" });
  if (status) status.textContent = error
    ? "Partita salvata sul dispositivo; sincronizzazione online non riuscita."
    : "Progressi sincronizzati con il tuo account CASHUP.";
}

window.addEventListener("cashup:game-played", (event) => {
  const detail = event.detail || {};
  if (!sessionReady) pendingEvents.push(detail);
  else if (currentUser) saveProgress(detail).catch(() => {
    if (status) status.textContent = "Partita salvata sul dispositivo; sincronizzazione online non riuscita.";
  });
});

supabase.auth.getSession().then(async ({ data, error }) => {
  if (error) throw error;
  currentUser = data.session?.user || null;
  sessionReady = true;
  if (status) status.textContent = currentUser
    ? "Progressi collegati al tuo account CASHUP."
    : "Accedi a CASHUP per sincronizzare i progressi su più dispositivi.";
  if (currentUser) {
    for (const detail of pendingEvents.splice(0)) await saveProgress(detail);
  } else {
    pendingEvents.length = 0;
  }
}).catch(() => {
  sessionReady = true;
  pendingEvents.length = 0;
  if (status) status.textContent = "Sincronizzazione online momentaneamente non disponibile.";
});

supabase.auth.onAuthStateChange((_event, session) => {
  currentUser = session?.user || null;
  if (status) status.textContent = currentUser
    ? "Progressi collegati al tuo account CASHUP."
    : "Progressi salvati solo su questo dispositivo. Accedi per sincronizzarli.";
});
