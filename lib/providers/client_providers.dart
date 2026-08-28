import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/client.dart';
import '../services/firestore_service.dart';

final firestoreServiceProvider = Provider<FirestoreService>((ref) => FirestoreService());

final clientsProvider = StreamProvider<List<Client>>((ref) {
  return ref.watch(firestoreServiceProvider).watchClients();
});