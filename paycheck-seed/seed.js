const admin = require("firebase-admin");
const { getFirestore, Timestamp } = require("firebase-admin/firestore");
const serviceAccount = require("./serviceAccountKey.json");

// ─────────────────────────────────────────────────────────────
//  USAGE:
//    node seed.js <TARGET_USER_ID>
//
//  Example:
//    node seed.js abc123xyz456
//
//  The target user ID is the Firebase Auth UID of the account
//  you want to seed data for. You can find it in the Firebase
//  Console → Authentication → Users.
// ─────────────────────────────────────────────────────────────

admin.initializeApp({
  credential: admin.cert(serviceAccount),
});

const db = getFirestore();

const firstNames = [
  "Mohamed", "Ahmed", "Fatma", "Amina", "Youssef", "Sami", "Ines", "Rania",
  "Karim", "Nabil", "Mariem", "Salma", "Walid", "Hedi", "Nadia", "Sonia",
  "Anis", "Bilel", "Emna", "Khaled", "Leila", "Mahdi", "Nour", "Omar",
];
const lastNames = [
  "Ben Salah", "Trabelsi", "Gharbi", "Jlassi", "Bouazizi", "Khelifi",
  "Mansouri", "Sassi", "Ayari", "Chaabane", "Dridi", "Fejjari",
  "Guesmi", "Hamdi", "Jaballah", "Kacem", "Larbi", "Mejri",
];

const periods = ["monthly", "quarterly", "semester", "annual"];
const periodMonths = { monthly: 1, quarterly: 3, semester: 6, annual: 12 };
const methods = ["cash", "postal", "card", "check"];

function randomItem(arr) {
  return arr[Math.floor(Math.random() * arr.length)];
}

function randomDate(daysAgoMin, daysAgoMax) {
  const daysAgo = Math.floor(Math.random() * (daysAgoMax - daysAgoMin)) + daysAgoMin;
  const d = new Date();
  d.setDate(d.getDate() - daysAgo);
  return d;
}

// Safe month addition that clamps to month-end (avoids date overflow)
function addMonths(date, months) {
  const d = new Date(date);
  const targetMonth = d.getMonth() + months;
  d.setMonth(targetMonth);
  // If we overflowed (e.g. Jan 31 + 1 month → Mar 3), clamp back
  if (d.getMonth() !== ((targetMonth % 12) + 12) % 12) {
    d.setDate(0); // last day of the previous month
  }
  return d;
}

async function getTargetUserId() {
  const uid = process.argv[2];
  if (!uid) {
    console.error("❌  No user ID provided.");
    console.error("   Usage: node seed.js <FIREBASE_AUTH_UID>");
    console.error("   Find your UID in Firebase Console → Authentication → Users.");
    process.exit(1);
  }
  console.log(`✅  Target UID: ${uid}`);
  return uid;
}

async function seed() {
  const targetUserId = await getTargetUserId();

  const NUM_CLIENTS = 40;
  const userClientsRef = db
    .collection("users")
    .doc(targetUserId)
    .collection("clients");

  console.log(`\n🌱  Seeding ${NUM_CLIENTS} clients for user ${targetUserId}...\n`);

  for (let i = 0; i < NUM_CLIENTS; i++) {
    const fullName = `${randomItem(firstNames)} ${randomItem(lastNames)}`;
    const contractNumber = `C${(2024000 + i).toString()}`;
    const period = randomItem(periods);
    const amountDue = [50, 80, 120, 150, 200, 300][Math.floor(Math.random() * 6)];
    const contractStartDate = randomDate(60, 900);

    const clientRef = userClientsRef.doc();
    await clientRef.set({
      contractNumber,
      fullName,
      phone: `2${Math.floor(10000000 + Math.random() * 89999999)}`,
      address: null,
      paymentPeriod: period,
      amountDue,
      contractStartDate: Timestamp.fromDate(contractStartDate),
      isActive: true,
    });

    // Generate 0–6 past payments
    const numPayments = Math.floor(Math.random() * 7);
    let periodStart = new Date(contractStartDate);

    for (let p = 0; p < numPayments; p++) {
      const periodEnd = addMonths(periodStart, periodMonths[period]);
      const method = randomItem(methods);
      const isRemote = method === "postal" || method === "card";
      const quittanceGiven = isRemote ? Math.random() > 0.4 : true;

      const paymentRef = clientRef.collection("payments").doc();
      await paymentRef.set({
        userId: targetUserId,
        amountPaid: amountDue,
        paymentDate: Timestamp.fromDate(new Date(periodStart)),
        periodStart: Timestamp.fromDate(periodStart),
        periodEnd: Timestamp.fromDate(periodEnd),
        method,
        quittanceGiven,
        quittanceDate: quittanceGiven
          ? Timestamp.fromDate(new Date(periodStart))
          : null,
      });

      periodStart = periodEnd;
    }

    console.log(`  [${i + 1}/${NUM_CLIENTS}] ${fullName} (${contractNumber}) — ${numPayments} payment(s)`);
  }

  console.log("\n✅  Done seeding! Open your app and sign in to see the data.");
  process.exit(0);
}

seed().catch((err) => {
  console.error("❌  Seed failed:", err);
  process.exit(1);
});
