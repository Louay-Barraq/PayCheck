// providers/history_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/payment_with_client.dart';
import 'client_providers.dart';
import 'payment_providers.dart';

export '../models/payment_with_client.dart';

final recentPaymentsProvider = Provider<AsyncValue<List<PaymentWithClient>>>((ref) {
  final clientsAsync = ref.watch(clientsProvider);
  final paymentsAsync = ref.watch(allPaymentsProvider);

  return clientsAsync.when(
    data: (clients) => paymentsAsync.when(
      data: (paymentsList) {
        final clientsById = {for (final c in clients) c.id: c};
        final payments = [...paymentsList]
          ..sort((a, b) => b.paymentDate.compareTo(a.paymentDate));

        final joined = payments
            .where((p) => clientsById.containsKey(p.clientId))
            .map((p) => PaymentWithClient(
                  payment: p,
                  clientName: clientsById[p.clientId]!.fullName,
                  contractNumber: clientsById[p.clientId]!.contractNumber,
                ))
            .toList();

        return AsyncValue.data(joined);
      },
      loading: () => const AsyncValue.loading(),
      error: (e, st) => AsyncValue.error(e, st),
    ),
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
  );
});