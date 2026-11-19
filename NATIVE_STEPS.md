# CASHUP native app and real step-count source

## Chosen implementation

CASHUP Steps uses the existing `@appeeky/expo-healthkit` native bridge:
- Android: Google Health Connect, reading only `READ_STEPS`.
- iOS: Apple HealthKit, reading only `stepCount`.
- No health data is written back to Health Connect or HealthKit.
- The embedded CASHUP website requests today's total through a restricted WebView bridge. The native app reads the system's daily aggregate and returns only the integer step total.

The app does not run its own motion-sensor algorithm. The phone OS / Health Connect / Apple Health collects and aggregates the steps; CASHUP reads the total after the user grants permission. On Android 14+ with SDK Extension 20+, Health Connect can collect on-device steps after an app receives READ_STEPS. Older Android devices may need another compatible source to write steps to Health Connect.

## Important limitations before release

- The native integration is merged into `main`. The Android debug APK has been built successfully in GitHub Actions and is available as the `cashup-android-debug` artifact (workflow run 44531101728). It has not yet been installed or tested on a physical phone.
- HealthKit requires the HealthKit capability enabled for the final iOS App ID and user permission.
- Health Connect requires a supported Android device and user permission. Play Console requires a Health Connect declaration and a privacy policy before production release.
- The package identifier `com.cashup.mobile` is provisional. Confirm the final application identifier before publishing; changing it after store publication is not straightforward.
- The web-only PWA cannot access Health Connect or Apple Health directly. Real step reading is available only in this native shell.
- The website currently stores daily step totals in the CASHUP database. This is not a tamper-proof proof-of-steps system. Step totals and the displayed 0–100 points remain demonstrative; do not enable cash rewards, redeemable points, or payouts until server-side anti-fraud validation and end-to-end tests are implemented.
- The app refreshes the daily aggregate when opened / when the user presses refresh. The operating system may continue collecting steps while CASHUP is closed; background delivery and periodic server sync have not been implemented or tested.

## Build and device verification

Requires Node.js 20+, npm, Android SDK/Android Studio for local Android builds, and Xcode + an Apple Developer App ID with HealthKit capability for iOS.

1. `npm install`
2. `npx expo-doctor`
3. `npx expo prebuild`
4. Android: `npx expo run:android` (or download the `cashup-android-debug` artifact from the GitHub Actions workflow run)
5. iOS (macOS only): `npx expo run:ios`

On the phone, open CASHUP Steps, press **Collega Salute e leggi i passi**, grant only step-count permission, walk, then refresh. Compare against the Health Connect / Apple Health daily total. Test date rollover, denied/revoked permission, no-data state, offline mode, duplicate reads, and user logout.

## Privacy and licensing

The integration requests only step-count read access. It does not request heart rate, sleep, location, workouts, or write permissions. The library is licensed under PolyForm Shield 1.0.0; its upstream README says it may be used inside commercial apps, but it may not be repackaged as a competing HealthKit/Health Connect library. Review the full license before release.
