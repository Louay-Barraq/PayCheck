<p align="center">
  <img src="assets/icons/paycheck_v2_full_preview.png" alt="PayCheck" width="180"/>
</p>

<h1 align="center">PayCheck</h1>

<p align="center">
  <strong>Contract, payment &amp; receipt management for independent landlords and professionals.</strong><br/>
  Built with Flutter + Firebase (Firestore, Auth).
</p>

---

## Features

- 🏠 **Client management** — Create and track clients with contract details
- 💳 **Payment history** — Record payments with method, period, and amount
- 🧾 **Quittances** — Track which payments have receipts issued
- 📊 **Dashboard** — Overdue clients, monthly revenue, pending quittances at a glance
- 🔒 **Multi-account** — Each user's data is fully isolated (multi-tenant Firestore)
- 📡 **Offline support** — Works without internet, syncs when back online

---

## Getting Started

### Prerequisites

- Flutter SDK ≥ 3.11
- A Firebase project with Firestore & Authentication enabled
- `google-services.json` placed in `android/app/`

### Run

```bash
flutter pub get
flutter run
```

---

## Seed Script

Use the script in `paycheck-seed/` to populate Firestore with realistic test data.

### Setup

```bash
cd paycheck-seed
npm install
# Place your Firebase service account key at:
# paycheck-seed/serviceAccountKey.json
```

### Run

```bash
node seed.js <YOUR_FIREBASE_AUTH_UID>
```

Find your UID in **Firebase Console → Authentication → Users**.

---

## Privacy Policy

Hosted at: [louay-barraq.github.io/PayCheck](https://louay-barraq.github.io/PayCheck/)

---

## License

Private — All rights reserved. © 2026 Louay Barraq
