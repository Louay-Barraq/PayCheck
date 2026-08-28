import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/payment.dart';
import 'client_providers.dart';

final allPaymentsProvider = StreamProvider<List<Payment>>((ref) {
  return ref.watch(firestoreServiceProvider).watchAllPayments();
});

final paymentsForClientProvider =
    StreamProvider.family<List<Payment>, String>((ref, clientId) {
  return ref.watch(firestoreServiceProvider).watchPayments(clientId);
});

final pendingQuittancesProvider = StreamProvider<List<Payment>>((ref) {
  return ref.watch(firestoreServiceProvider).watchPendingQuittances();
});