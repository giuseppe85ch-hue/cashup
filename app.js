import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.119.1?bundle';

const SUPABASE_URL = 'https://fzcricigqqpzcujrenkf.supabase.co';
const SUPABASE_PUBLISHABLE_KEY = 'sb_publishable_uy1xJ_55eYnmne1K8UrBQg_lV3LEyae';
const supabase = createClient(SUPABASE_URL, SUPABASE_PUBLISHABLE_KEY);

const statusEl = document.getElementById('auth-status');
const emailEl = document.getElementById('auth-email');
const passwordEl = document.getElementById('auth-password');

function showStatus(message) {
  statusEl.textContent = message;
}

function readableError(error) {
  const messages = {
    'Invalid login credentials': 'Email o password non corretti.',
    'User already registered': 'Questa email è già registrata. Prova ad accedere.',
    'Password should be at least 6 characters': 'La password deve contenere almeno 6 caratteri.'
  };
  return messages[error?.message] || error?.message || 'Si è verificato un errore. Riprova.';
}

async function loadCloudProfile(user) {
  const { data, error } = await supabase
    .from('profiles')
    .select('display_name')
    .eq('id', user.id)
    .maybeSingle();
  if (error) {
    document.getElementById('saved').textContent = 'Accesso al profilo online non riuscito: ' + readableError(error);
    return;
  }
  if (data?.display_name) {
    document.getElementById('name').value = data.display_name;
    try { localStorage.setItem('cashup_name', data.display_name); } catch (e) {}
  }
  document.getElementById('email').value = user.email || '';
}

async function saveCloudProfile() {
  const { data: sessionData, error: sessionError } = await supabase.auth.getSession();
  if (sessionError || !sessionData.session?.user) {
    document.getElementById('saved').textContent = 'Prima accedi al tuo account CASHUP.';
    return;
  }
  const user = sessionData.session.user;
  const displayName = document.getElementById('name').value.trim();
  if (!displayName) {
    document.getElementById('saved').textContent = 'Inserisci il tuo nome.';
    return;
  }
  document.getElementById('saved').textContent = 'Salvataggio del profilo online…';
  const { error } = await supabase
    .from('profiles')
    .upsert({ id: user.id, display_name: displayName }, { onConflict: 'id' });
  if (error) {
    document.getElementById('saved').textContent = 'Salvataggio online non riuscito: ' + readableError(error);
    return;
  }
  try {
    localStorage.setItem('cashup_name', displayName);
  } catch (e) {}
  document.getElementById('email').value = user.email || '';
  document.getElementById('saved').textContent = 'Profilo salvato nel database CASHUP.';
}

document.getElementById('save-profile-btn').addEventListener('click', saveCloudProfile);

async function refreshSession() {
  const { data, error } = await supabase.auth.getSession();
  if (error) {
    showStatus('Non riesco a verificare la sessione: ' + readableError(error));
    return;
  }
  if (data.session?.user) {
    showStatus('Accesso effettuato con: ' + data.session.user.email);
    await loadCloudProfile(data.session.user);
  } else {
    showStatus('Non hai ancora effettuato l’accesso.');
  }
}

document.getElementById('signup-btn').addEventListener('click', async () => {
  const email = emailEl.value.trim();
  const password = passwordEl.value;
  if (!email || !password) {
    showStatus('Inserisci email e password.');
    return;
  }
  if (password.length < 12) {
    showStatus('La password deve contenere almeno 12 caratteri.');
    return;
  }
  showStatus('Registrazione in corso…');
  const { data, error } = await supabase.auth.signUp({
    email,
    password,
    options: { emailRedirectTo: window.location.origin }
  });
  if (error) {
    showStatus(readableError(error));
  } else if (data.session) {
    showStatus('Account creato e accesso effettuato con: ' + data.user.email);
  } else {
    showStatus('Registrazione avviata. Controlla la tua email e apri il link di conferma per attivare l’account.');
  }
});

document.getElementById('signin-btn').addEventListener('click', async () => {
  const email = emailEl.value.trim();
  const password = passwordEl.value;
  if (!email || !password) {
    showStatus('Inserisci email e password.');
    return;
  }
  showStatus('Accesso in corso…');
  const { data, error } = await supabase.auth.signInWithPassword({ email, password });
  if (error) {
    showStatus(readableError(error));
  } else {
    showStatus('Accesso effettuato con: ' + data.user.email);
  }
});

document.getElementById('signout-btn').addEventListener('click', async () => {
  showStatus('Uscita in corso…');
  const { error } = await supabase.auth.signOut();
  if (error) {
    showStatus(readableError(error));
  } else {
    showStatus('Sei uscito dal tuo account CASHUP.');
  }
});

supabase.auth.onAuthStateChange((_event, session) => {
  if (session?.user) {
    showStatus('Accesso effettuato con: ' + session.user.email);
    setTimeout(() => loadCloudProfile(session.user), 0);
  } else {
    showStatus('Non hai ancora effettuato l’accesso.');
  }
});

refreshSession();

function showPage(id, button) {
  document.querySelectorAll('.page').forEach(page => page.classList.remove('active'));
  document.getElementById(id).classList.add('active');
  document.querySelectorAll('nav button').forEach(item => item.classList.remove('active'));
  button.classList.add('active');
  window.scrollTo(0, 0);
}

document.querySelectorAll('nav button[data-page]').forEach(button => {
  button.addEventListener('click', () => showPage(button.dataset.page, button));
});

try {
  document.getElementById('name').value = localStorage.getItem('cashup_name') || '';
} catch (error) {}

if ('serviceWorker' in navigator) {
  window.addEventListener('load', () => {
    navigator.serviceWorker.register('/sw.js').catch(() => {});
  });
}
