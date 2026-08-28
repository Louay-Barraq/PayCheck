import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/client.dart';
import '../models/payment.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get _userId {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('User not authenticated');
    return uid;
  }

  CollectionReference get _clients =>
      _db.collection('users').doc(_userId).collection('clients');

  // ---- Clients ----

  Stream<List<Client>> watchClients() {
    return _clients
        .orderBy('fullName')
        .snapshots()
        .map((snap) => snap.docs.map((d) => Client.fromFirestore(d)).toList());
  }

  Future<void> addClient(Client client) async {
    await _clients.doc(client.id).set(client.toFirestore());
  }

  Future<void> updateClient(Client client) async {
    await _clients.doc(client.id).update(client.toFirestore());
  }

  // ---- Payments (subcollection) ----

  CollectionReference _paymentsOf(String clientId) =>
      _clients.doc(clientId).collection('payments');

  Stream<List<Payment>> watchPayments(String clientId) {
    return _paymentsOf(clientId)
        .orderBy('paymentDate', descending: true)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((d) => Payment.fromFirestore(d, clientId)).toList(),
        );
  }

  Stream<List<Payment>> watchAllPayments() {
    return _db
        .collectionGroup('payments')
        .where('userId', isEqualTo: _userId)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map(
                (d) => Payment.fromFirestore(d, d.reference.parent.parent!.id),
              )
              .toList(),
        );
  }

  Future<void> addPayment(Payment payment) async {
    final data = payment.toFirestore();
    data['userId'] = _userId;
    await _paymentsOf(payment.clientId).doc(payment.id).set(data);
  }

  Future<void> updatePayment(Payment payment) async {
    final data = payment.toFirestore();
    data['userId'] = _userId;
    await _paymentsOf(payment.clientId).doc(payment.id).update(data);
  }

  // Quittance-pending clients: collectionGroup query filtered by userId
  Stream<List<Payment>> watchPendingQuittances() {
    return _db
        .collectionGroup('payments')
        .where('userId', isEqualTo: _userId)
        .where('quittanceGiven', isEqualTo: false)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map(
                (d) => Payment.fromFirestore(d, d.reference.parent.parent!.id),
              )
              .toList(),
        );
  }

  // Delete all user data (GDPR / Account Deletion compliance)
  Future<void> deleteAllUserData() async {
    final clientsSnap = await _clients.get();
    for (final clientDoc in clientsSnap.docs) {
      final paymentsSnap = await clientDoc.reference.collection('payments').get();
      for (final p in paymentsSnap.docs) {
        await p.reference.delete();
      }
      await clientDoc.reference.delete();
    }
  }
}
