// screens/payment_history_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../models/payment.dart';
import '../providers/history_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/empty_state.dart';

class PaymentHistoryScreen extends ConsumerWidget {
  const PaymentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final dateFmt = DateFormat('dd MMMM yyyy', locale);
    final historyAsync = ref.watch(recentPaymentsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.historyTitle)),
      body: historyAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return EmptyState(
              icon: Icons.history_rounded,
              message: l10n.noPaymentsHistory,
            );
          }

          // Group by date (day) for a clean chronological feed
          final Map<String, List<PaymentWithClient>> grouped = {};
          for (final item in items) {
            final key = dateFmt.format(item.payment.paymentDate);
            grouped.putIfAbsent(key, () => []).add(item);
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: grouped.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8, top: 12),
                    child: Text(
                      entry.key,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  ...entry.value.map((item) => _HistoryTile(item: item)),
                ],
              );
            }).toList(),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('${l10n.error}: $e')),
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final PaymentWithClient item;
  const _HistoryTile({required this.item});

  static final _timeFmt = DateFormat('HH:mm');

  @override
  Widget build(BuildContext context) {
    final p = item.payment;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primaryLight,
          child: Icon(p.method.icon, color: AppColors.primary, size: 20),
        ),
        title: Text(item.clientName, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('N° ${item.contractNumber} · ${p.method.localizedLabel(context)}'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${p.amountPaid.toStringAsFixed(0)} DT',
              style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary),
            ),
            const SizedBox(height: 2),
            if (!p.quittanceGiven)
              const Icon(Icons.warning_amber_rounded, size: 14, color: AppColors.warning)
            else
              Text(_timeFmt.format(p.paymentDate), style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}