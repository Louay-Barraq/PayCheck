// providers/dashboard_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/client.dart';
import '../models/payment.dart';
import '../utils/payment_utils.dart';
import 'client_providers.dart';
import 'payment_providers.dart';

class DashboardData {
  final double collectedThisMonth;
  final double collectedLastMonth;
  final int paymentsCountThisMonth;
  final double totalOverdueAmount;
  final int overdueCount;
  final List<Client> overdueClients;
  final int pendingQuittanceCount;
  final Map<PaymentMethod, double> byMethod;
  final List<Client> dueSoon;
  final int totalActiveClients;
  final double averagePayment;
  final Map<String, DateTime> nextDueDates;

  const DashboardData({
    required this.collectedThisMonth,
    required this.collectedLastMonth,
    required this.paymentsCountThisMonth,
    required this.totalOverdueAmount,
    required this.overdueCount,
    required this.overdueClients,
    required this.pendingQuittanceCount,
    required this.byMethod,
    required this.dueSoon,
    required this.totalActiveClients,
    required this.averagePayment,
    required this.nextDueDates,
  });

  double get monthOverMonthPct {
    if (collectedLastMonth == 0) return collectedThisMonth > 0 ? 100 : 0;
    return ((collectedThisMonth - collectedLastMonth) / collectedLastMonth) * 100;
  }
}

final dashboardProvider = Provider<AsyncValue<DashboardData>>((ref) {
  final clientsAsync = ref.watch(clientsProvider);
  final paymentsAsync = ref.watch(allPaymentsProvider);

  return clientsAsync.when(
    data: (clients) => paymentsAsync.when(
      data: (allPayments) {
        final now = DateTime.now();
        final monthStart = DateTime(now.year, now.month, 1);
        final lastMonthStart = DateTime(now.year, now.month - 1, 1);

        final paymentsByClient = <String, List<Payment>>{};
        for (final p in allPayments) {
          paymentsByClient.putIfAbsent(p.clientId, () => []).add(p);
        }

        double collectedThisMonth = 0;
        double collectedLastMonth = 0;
        int paymentsCountThisMonth = 0;
        final byMethod = <PaymentMethod, double>{};
        int pendingQuittanceCount = 0;

        for (final p in allPayments) {
          if (!p.paymentDate.isBefore(monthStart)) {
            collectedThisMonth += p.amountPaid;
            paymentsCountThisMonth++;
          } else if (!p.paymentDate.isBefore(lastMonthStart) && p.paymentDate.isBefore(monthStart)) {
            collectedLastMonth += p.amountPaid;
          }
          byMethod[p.method] = (byMethod[p.method] ?? 0) + p.amountPaid;
          if (!p.quittanceGiven) pendingQuittanceCount++;
        }

        final overdueClients = <Client>[];
        final dueSoon = <Client>[];
        final nextDueDates = <String, DateTime>{};
        final in7Days = now.add(const Duration(days: 7));
        double totalOverdueAmount = 0;
        int totalActiveClients = 0;

        for (final c in clients) {
          if (!c.isActive) continue;
          totalActiveClients++;
          final payments = paymentsByClient[c.id] ?? [];
          final nextDue = computeNextDue(c, payments);
          nextDueDates[c.id] = nextDue;
          if (nextDue.isBefore(now)) {
            overdueClients.add(c);
            totalOverdueAmount += c.amountDue;
          } else if (nextDue.isBefore(in7Days)) {
            dueSoon.add(c);
          }
        }

        overdueClients.sort((a, b) => b.amountDue.compareTo(a.amountDue));

        return AsyncValue.data(DashboardData(
          collectedThisMonth: collectedThisMonth,
          collectedLastMonth: collectedLastMonth,
          paymentsCountThisMonth: paymentsCountThisMonth,
          totalOverdueAmount: totalOverdueAmount,
          overdueCount: overdueClients.length,
          overdueClients: overdueClients,
          pendingQuittanceCount: pendingQuittanceCount,
          byMethod: byMethod,
          dueSoon: dueSoon,
          totalActiveClients: totalActiveClients,
          averagePayment: paymentsCountThisMonth == 0 ? 0 : collectedThisMonth / paymentsCountThisMonth,
          nextDueDates: nextDueDates,
        ));
      },
      loading: () => const AsyncValue.loading(),
      error: (e, st) => AsyncValue.error(e, st),
    ),
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
  );
});