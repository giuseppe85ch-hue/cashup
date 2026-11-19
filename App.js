import React, { useCallback, useRef, useState } from "react";
import { ActivityIndicator, Platform, StatusBar, StyleSheet, Text, View } from "react-native";
import AsyncStorage from "@react-native-async-storage/async-storage";
import * as Notifications from "expo-notifications";
import { WebView } from "react-native-webview";
import * as HealthKit from "@appeeky/expo-healthkit";

const CASHUP_URL = "https://cashup-859.pages.dev/";
const TRUSTED_ORIGIN = "https://cashup-859.pages.dev";
const REMINDER_IDS_KEY = "cashup.daily.reminder.ids.v1";

Notifications.setNotificationHandler({
  handleNotification: async () => ({
    shouldShowAlert: true,
    shouldPlaySound: false,
    shouldSetBadge: false
  })
});
const HEALTH_BRIDGE = `
(function () {
  if (window.__CASHUP_HEALTH_BRIDGE__) return true;
  window.__CASHUP_HEALTH_BRIDGE__ = true;
  var pending = Object.create(null);
  var sequence = 0;
  window.CASHUP_NATIVE_HEALTH = {
    getTodaySteps: function () {
      return new Promise(function (resolve, reject) {
        var requestId = "cashup-steps-" + (++sequence) + "-" + Date.now();
        var timeout = setTimeout(function () {
          delete pending[requestId];
          reject(new Error("La lettura dei passi è scaduta. Riprova."));
        }, 25000);
        pending[requestId] = { resolve: resolve, reject: reject, timeout: timeout };
        window.ReactNativeWebView.postMessage(JSON.stringify({
          type: "CASHUP_GET_TODAY_STEPS",
          requestId: requestId
        }));
      });
    }
  };
  window.addEventListener("cashup:native-steps-result", function (event) {
    var result = event.detail || {};
    var item = pending[result.requestId];
    if (!item) return;
    clearTimeout(item.timeout);
    delete pending[result.requestId];
    if (result.error) item.reject(new Error(result.error));
    else item.resolve(Number(result.steps) || 0);
  });
  return true;
})();
true;
`;


const NOTIFICATIONS_BRIDGE = `
(function () {
  if (window.__CASHUP_NOTIFICATIONS_BRIDGE__) return true;
  window.__CASHUP_NOTIFICATIONS_BRIDGE__ = true;
  var pending = Object.create(null);
  var sequence = 0;
  function request(type, extra) {
    return new Promise(function(resolve, reject) {
      var requestId = "cashup-notify-" + (++sequence) + "-" + Date.now();
      var timeout = setTimeout(function(){ delete pending[requestId]; reject(new Error("La richiesta notifiche è scaduta.")); }, 20000);
      pending[requestId] = {resolve:resolve,reject:reject,timeout:timeout};
      window.ReactNativeWebView.postMessage(JSON.stringify(Object.assign({type:type,requestId:requestId},extra||{})));
    });
  }
  window.CASHUP_NATIVE_NOTIFICATIONS = {
    scheduleDailyReminders: function(times) { return request("CASHUP_SCHEDULE_REMINDERS",{times:times}); },
    cancelDailyReminders: function() { return request("CASHUP_CANCEL_REMINDERS",{}); }
  };
  window.addEventListener("cashup:native-notification-result",function(event){
    var result=event.detail||{}, item=pending[result.requestId];
    if(!item)return;
    clearTimeout(item.timeout); delete pending[result.requestId];
    if(result.error)item.reject(new Error(result.error)); else item.resolve(result);
  });
  return true;
})();
true;
`;

export default function App() {
  const webView = useRef(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  const sendNotificationResult = useCallback((requestId, result) => {
    const payload = JSON.stringify({ requestId, ...result }).replace(/</g, "\\u003c");
    webView.current?.injectJavaScript(
      "window.dispatchEvent(new CustomEvent('cashup:native-notification-result',{detail:" + payload + "})); true;"
    );
  }, []);

  const scheduleDailyReminders = useCallback(async (requestId, times) => {
    try {
      if (!Array.isArray(times) || times.length < 1 || times.length > 3) {
        throw new Error("Scegli da 1 a 3 promemoria al giorno.");
      }
      const normalized = [...new Set(times)].filter((value) => /^([01]\d|2[0-3]):[0-5]\d$/.test(value));
      if (normalized.length !== times.length) throw new Error("Orario dei promemoria non valido.");
      if (Platform.OS === "android") {
        await Notifications.setNotificationChannelAsync("daily-reminders", {
          name: "Promemoria CASHUP",
          importance: Notifications.AndroidImportance.DEFAULT,
          vibrationPattern: [0, 180],
          lightColor: "#42e890"
        });
      }
      const permission = await Notifications.requestPermissionsAsync();
      if (!permission.granted) throw new Error("Permesso notifiche non concesso. Puoi abilitarlo dalle impostazioni del telefono.");
      const previous = JSON.parse((await AsyncStorage.getItem(REMINDER_IDS_KEY)) || "[]");
      await Promise.all(previous.map((id) => Notifications.cancelScheduledNotificationAsync(id).catch(() => {})));
      const ids = [];
      for (const value of normalized) {
        const [hour, minute] = value.split(":").map(Number);
        const id = await Notifications.scheduleNotificationAsync({
          content: {
            title: "CASHUP ti aspetta ✨",
            body: "Ci sono attività e missioni da scoprire oggi. Apri CASHUP quando ti fa comodo.",
            sound: false,
            data: { screen: "home", kind: "daily_reminder" }
          },
          trigger: { type: Notifications.SchedulableTriggerInputTypes.DAILY, hour, minute, channelId: "daily-reminders" }
        });
        ids.push(id);
      }
      await AsyncStorage.setItem(REMINDER_IDS_KEY, JSON.stringify(ids));
      sendNotificationResult(requestId, { ok: true, count: ids.length });
    } catch (err) {
      sendNotificationResult(requestId, { error: err?.message || "Impossibile programmare i promemoria." });
    }
  }, [sendNotificationResult]);

  const cancelDailyReminders = useCallback(async (requestId) => {
    try {
      const previous = JSON.parse((await AsyncStorage.getItem(REMINDER_IDS_KEY)) || "[]");
      await Promise.all(previous.map((id) => Notifications.cancelScheduledNotificationAsync(id).catch(() => {})));
      await AsyncStorage.removeItem(REMINDER_IDS_KEY);
      sendNotificationResult(requestId, { ok: true });
    } catch (err) {
      sendNotificationResult(requestId, { error: err?.message || "Impossibile disattivare i promemoria." });
    }
  }, [sendNotificationResult]);

  const sendResult = useCallback((requestId, result) => {
    const payload = JSON.stringify({ requestId, ...result });
    const safePayload = payload.replace(/</g, "\\u003c");
    webView.current?.injectJavaScript(
      "window.dispatchEvent(new CustomEvent('cashup:native-steps-result',{detail:" +
      safePayload + "})); true;"
    );
  }, []);

  const readTodaySteps = useCallback(async (requestId) => {
    try {
      if (!HealthKit.isAvailable()) {
        throw new Error(
          Platform.OS === "android"
            ? "Google Health Connect non è disponibile su questo dispositivo. Aggiornalo o installalo dalle impostazioni Android."
            : "Apple Salute non è disponibile su questo dispositivo."
        );
      }

      await HealthKit.requestAuthorization({
        toRead: [HealthKit.QuantityType.stepCount],
        toShare: []
      });

      const now = new Date();
      const start = new Date(now);
      start.setHours(0, 0, 0, 0);

      const result = await HealthKit.queryStatistics({
        type: HealthKit.QuantityType.stepCount,
        unit: HealthKit.Unit.count,
        from: start,
        to: now,
        options: HealthKit.StatisticsOption.cumulativeSum
      });

      sendResult(requestId, { steps: Math.max(0, Math.floor(result?.sum || 0)) });
    } catch (err) {
      sendResult(requestId, { error: err?.message || "Impossibile leggere i passi dal servizio Salute." });
    }
  }, [sendResult]);

  const onMessage = useCallback((event) => {
    try {
      const message = JSON.parse(event.nativeEvent.data || "{}");
      if (message.type === "CASHUP_SCHEDULE_REMINDERS" && typeof message.requestId === "string") {
        scheduleDailyReminders(message.requestId, message.times);
      } else if (message.type === "CASHUP_CANCEL_REMINDERS" && typeof message.requestId === "string") {
        cancelDailyReminders(message.requestId);
      } else if (message.type === "CASHUP_GET_TODAY_STEPS" && typeof message.requestId === "string") {
        readTodaySteps(message.requestId);
      }
    } catch (_) {
      // Ignore malformed messages from the embedded page.
    }
  }, [readTodaySteps, scheduleDailyReminders, cancelDailyReminders]);

  const allowNavigation = useCallback((request) => {
    return request.url === TRUSTED_ORIGIN || request.url.startsWith(TRUSTED_ORIGIN + "/");
  }, []);

  return (
    <View style={styles.root}>
      <StatusBar barStyle="light-content" backgroundColor="#08110c" />
      {loading && (
        <View style={styles.loading}>
          <ActivityIndicator size="large" color="#42e890" />
          <Text style={styles.loadingText}>CASHUP si sta avviando…</Text>
        </View>
      )}
      {!!error && <Text style={styles.error}>{error}</Text>}
      <WebView
        ref={webView}
        source={{ uri: CASHUP_URL }}
        originWhitelist={["https://cashup-859.pages.dev"]}
        onShouldStartLoadWithRequest={allowNavigation}
        onMessage={onMessage}
        injectedJavaScript={HEALTH_BRIDGE + NOTIFICATIONS_BRIDGE}
        javaScriptEnabled
        domStorageEnabled
        sharedCookiesEnabled
        thirdPartyCookiesEnabled
        setSupportMultipleWindows={false}
        onLoadEnd={() => setLoading(false)}
        onError={() => setError("Connessione a CASHUP non disponibile. Controlla Internet e riprova.")}
        onHttpError={(event) => {
          if (event.nativeEvent.statusCode >= 500) setError("Il servizio CASHUP è momentaneamente non disponibile.");
        }}
        style={styles.web}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  root: { flex: 1, backgroundColor: "#08110c", paddingTop: Platform.OS === "android" ? StatusBar.currentHeight || 0 : 0 },
  web: { flex: 1, backgroundColor: "#08110c" },
  loading: { position: "absolute", zIndex: 2, top: "45%", alignSelf: "center", alignItems: "center" },
  loadingText: { color: "#e9fff0", marginTop: 12 },
  error: { color: "#ffd6d6", padding: 12, backgroundColor: "#401919" }
});
