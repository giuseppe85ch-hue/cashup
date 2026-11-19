(() => {
  const languages = [
    ["it","Italiano"],["en","English"],["es","Español"],["fr","Français"],["de","Deutsch"],
    ["pt","Português"],["pt-BR","Português (Brasil)"],["ar","العربية"],["zh-Hans","简体中文"],
    ["zh-Hant","繁體中文"],["ja","日本語"],["hi","हिन्दी"],["ru","Русский"],["tr","Türkçe"],
    ["id","Bahasa Indonesia"],["ko","한국어"],["nl","Nederlands"],["pl","Polski"],
    ["sw","Kiswahili"],["bn","বাংলা"],["ur","اردو"],["vi","Tiếng Việt"],["th","ไทย"],
    ["uk","Українська"],["fa","فارسی"],["he","עברית"],["ro","Română"],["sv","Svenska"],
    ["no","Norsk"],["da","Dansk"],["fi","Suomi"],["el","Ελληνικά"],["cs","Čeština"],
    ["hu","Magyar"],["ms","Bahasa Melayu"],["fil","Filipino"],["ta","தமிழ்"],
    ["te","తెలుగు"],["mr","मराठी"],["gu","ગુજરાતી"],["am","አማርኛ"]
  ];
  const currencyFallback = ["EUR","USD","GBP","CHF","CAD","AUD","JPY","CNY","INR","BRL","MXN","ARS","CLP","COP","PEN","ZAR","NGN","KES","GHS","EGP","AED","SAR","QAR","TRY","RUB","UAH","PLN","SEK","NOK","DKK","ISK","KRW","IDR","MYR","SGD","THB","VND","PHP","BDT","PKR","LKR","NPR","ILS","MAD","TND","XOF","XAF","NZD"];
  const supported = typeof Intl.supportedValuesOf === "function" ? Intl.supportedValuesOf("currency") : currencyFallback;
  const browserLocale = (navigator.language || "en").replace("_","-");
  const initialLanguage = languages.some(x=>x[0].toLowerCase()===browserLocale.toLowerCase())
    ? browserLocale : (languages.find(x=>x[0]===browserLocale.split("-")[0])?.[0] || "en");
  let locale = localStorage.getItem("cashup_locale") || initialLanguage;
  let currency = localStorage.getItem("cashup_currency") || "EUR";
  if (!languages.some(x=>x[0]===locale)) locale = initialLanguage;
  if (!supported.includes(currency)) currency = "EUR";
  const header = document.querySelector("header");
  if (!header || document.getElementById("cashup-global-controls")) return;
  const controls = document.createElement("div");
  controls.id = "cashup-global-controls";
  controls.innerHTML = '<label for="cashup-language">🌐</label><select id="cashup-language" aria-label="Language / Lingua"></select><label for="cashup-currency">💱</label><select id="cashup-currency" aria-label="Currency / Valuta"></select><small id="cashup-global-note">Lingua preferita · valuta visualizzata; cambi in tempo reale non collegati / Preferred language · display currency only; live rates not connected</small>';
  header.appendChild(controls);
  const style = document.createElement("style");
  style.textContent = '#cashup-global-controls{display:flex;align-items:center;gap:6px;flex-wrap:wrap;margin-left:auto;font-size:11px}#cashup-global-controls label{margin:0;color:#a4b8aa}#cashup-global-controls select{max-width:145px;width:auto;padding:7px 8px;background:#0b150e;color:#fff;border:1px solid #42634b;border-radius:8px;font-size:12px}#cashup-global-note{display:none;color:#a4b8aa}@media(max-width:560px){header{flex-wrap:wrap}#cashup-global-controls{width:100%;margin:8px 0 0}#cashup-global-controls select{flex:1;min-width:100px}}';
  document.head.appendChild(style);
  const langSelect = controls.querySelector("#cashup-language");
  const currencySelect = controls.querySelector("#cashup-currency");
  languages.forEach(([code,name])=>{const option=document.createElement("option");option.value=code;option.textContent=name;langSelect.appendChild(option)});
  langSelect.value=locale;
  const displayNames = (()=>{try{return new Intl.DisplayNames([locale],{type:"currency"})}catch(e){return null}})();
  supported.forEach(code=>{const option=document.createElement("option");option.value=code;let label=code;try{label=displayNames?displayNames.of(code)+" ("+code+")":code}catch(e){}option.textContent=label;currencySelect.appendChild(option)});
  currencySelect.value=currency;
  function formatBalances(){
    document.querySelectorAll(".amount[data-cashup-value]").forEach(el=>{
      const amount=Number(el.dataset.cashupValue || 0);
      try{el.textContent=new Intl.NumberFormat(locale,{style:"currency",currency,maximumFractionDigits:2}).format(amount)}catch(e){el.textContent=amount.toFixed(2)+" "+currency}
    });
  }
  function applyLanguage(){
    document.documentElement.lang=locale;
    document.documentElement.dir=["ar","he","fa","ur"].includes(locale.split("-")[0])?"rtl":"ltr";
    localStorage.setItem("cashup_locale",locale);
    formatBalances();
  }
  langSelect.addEventListener("change",()=>{locale=langSelect.value;applyLanguage()});
  currencySelect.addEventListener("change",()=>{currency=currencySelect.value;localStorage.setItem("cashup_currency",currency);formatBalances()});
  applyLanguage();
})();