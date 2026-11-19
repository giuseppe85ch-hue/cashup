import React, { useCallback, useRef, useState } from "react";
import { ActivityIndicator, BackHandler, Platform, StatusBar, StyleSheet, Text, View } from "react-native";
import { WebView } from "react-native-webview";
import * as HealthKit from "@appeeky/expo-healthkit";

const CASHUP_URL = "https://cashup-859.pages.dev/";
const TRUSTED_ORIGIN = "https://cashup-859.pages.dev";
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

export default function App() {
  const webView = useRef(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

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
      if (message.type === "CASHUP_GET_TODAY_STEPS" && typeof message.requestId === "string") {
        readTodaySteps(message.requestId);
      }
    } catch (_) {
      // Ignore malformed messages from the embedded page.
    }
  }, [readTodaySteps]);

  const allowNavigation = useCallback((request) => {
    try {
      const url = new URL(request.url);
      return url.origin === TRUSTED_ORIGIN;
    } catch (_) {
      return false;
    }
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
        injectedJavaScriptBeforeContentLoaded={HEALTH_BRIDGE}
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
