# CASHUP

**IL MOVIMENTO PREMIA**

CASHUP is an international-first rewards and engagement platform prototype. The current public web build is deployed at https://cashup-859.pages.dev/.

## Current project status

### Web app
- Email sign-up, sign-in and profile storage use Supabase Auth and the `profiles` table.
- CASHUP Steps has a web/native bridge. The native Expo app uses `@appeeky/expo-healthkit` to read step totals from Android Health Connect and Apple HealthKit after permission is granted.
- Daily engagement and reminder preferences have database support. Native daily reminders require an installed native build and notification permission.
- Rewards, cash wallet, partner shops, referral payouts and withdrawals are not live. The displayed balance and step points are demonstrative.

### CASHUP GAMES
- 10,000 catalog concepts are stored in nine JSON files and loaded by the games page.
- 600 categories are planned; 100 currently have catalog entries and 500 are marked as planned.
- Four playable prototypes are available: Reflexes, Memory, Math Challenge and Quick Quiz.
- Catalog concepts are not 10,000 finished games. New games need to be implemented, tested and connected to secure progress storage before being described as playable.
- Prototype scores and play counts are stored locally on the device. They are not cash rewards and are not anti-cheat verified.

## Native Android build

The Expo project is configured for Android and iOS. Android Health Connect and local notifications require a native build; they do not work in a browser/PWA.

```bash
npm install
npx expo install --check
npx expo-doctor
npx expo prebuild --platform android
cd android
./gradlew assembleDebug
```

The GitHub Actions workflow validates the catalog and mini-game JavaScript, checks Expo dependencies, runs Expo Doctor and builds an installable Android debug APK.

## Backend and security

Supabase provides authentication, profile data, daily step totals, engagement records, verified mission/ad reward events, point ledger entries and per-user game/content progress storage. Row Level Security is enabled on the public tables. Reward claims must only be issued after trusted server-side verification.

A real advertising provider, its application/placement IDs and server callback secret are not configured. Affiliate merchants and sponsored offers require approved partner accounts and verified commercial terms. Payments and withdrawals require a compliant payment provider, legal review, fraud controls and operational approval.

## Release blockers

Before a public international launch:
1. Complete physical-device Android tests for Health Connect and notifications.
2. Complete iOS build and HealthKit tests on an eligible Apple developer setup.
3. Connect and test an advertising provider; configure its secret securely.
4. Sign real affiliate/sponsor agreements and import only verified offers.
5. Finish reward, referral, payout, fraud-prevention and customer-support workflows.
6. Complete privacy policy, terms, data deletion/export flows and applicable store declarations.
7. Translate the full user interface and test right-to-left layouts and currency formatting.
8. Test the deployed production build end to end.

Never promise cash rewards, cashback rates or earnings until the funding partner, verification and redemption path are live and tested.
