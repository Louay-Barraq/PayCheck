// screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../models/client.dart';
import '../models/payment.dart';
import '../providers/client_providers.dart';
import '../providers/dashboard_providers.dart';
import '../providers/payment_providers.dart';
import '../providers/user_profile_provider.dart';
import '../services/notification_service.dart';
import '../theme/app_theme.dart';
import '../widgets/status_badge.dart';
import 'client_detail_screen.dart';
import 'payment_history_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  void _showAllOverdueDialog(
    BuildContext context,
    List<Client> overdueClients,
    String currency,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.allOverdueClients(overdueClients.length),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: overdueClients.length,
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, i) {
                      final c = overdueClients[i];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.dangerLight,
                            child: Text(
                              c.fullName.isNotEmpty
                                  ? c.fullName[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                color: AppColors.danger,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          title: Text(
                            c.fullName,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            '${l10n.contract}: ${c.contractNumber} · ${c.paymentPeriod.localizedLabel(context)}',
                          ),
                          trailing: Text(
                            '${c.amountDue.toStringAsFixed(0)} $currency',
                            style: const TextStyle(
                              color: AppColors.danger,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ClientDetailScreen(client: c),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currency = ref.watch(currencySymbolProvider);
    final dashAsync = ref.watch(dashboardProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.dashboard),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            tooltip: l10n.history,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PaymentHistoryScreen()),
            ),
          ),
        ],
      ),
      body: dashAsync.when(
        data: (data) {
          ref.read(clientsProvider).whenData((clients) {
            final Map<String, List<Payment>> paymentsByClient = {};
            for (final c in clients) {
              paymentsByClient[c.id] = ref.watch(paymentsForClientProvider(c.id)).value ?? [];
            }
            ref.read(notificationServiceProvider).checkAndSendPaymentAlerts(
                  clients: clients,
                  paymentsByClient: paymentsByClient,
                  currencySymbol: currency,
                );
          });

          return ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          children: [
            // Hero card: main revenue KPI with trend
            _RevenueHeroCard(data: data, currency: currency),
            const SizedBox(height: 16),

            // Secondary KPI grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.45,
              children: [
                _MiniKpi(
                  icon: Icons.people_outline_rounded,
                  label: l10n.activeClients,
                  value: '${data.totalActiveClients}',
                  color: AppColors.primary,
                ),
                _MiniKpi(
                  icon: Icons.warning_amber_rounded,
                  label: l10n.overdueClients,
                  value: '${data.overdueCount}',
                  sub: '${data.totalOverdueAmount.toStringAsFixed(0)} $currency',
                  color: AppColors.danger,
                ),
                _MiniKpi(
                  icon: Icons.receipt_long_rounded,
                  label: l10n.pendingQuittances,
                  value: '${data.pendingQuittanceCount}',
                  color: AppColors.warning,
                ),
                _MiniKpi(
                  icon: Icons.event_available_rounded,
                  label: l10n.dueSoon,
                  value: '${data.dueSoon.length}',
                  color: AppColors.primary,
                ),
              ],
            ),

            const SizedBox(height: 24),
            Text(
              l10n.distributionByMethod,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: data.byMethod.entries.map((e) {
                    final total = data.byMethod.values.fold(
                      0.0,
                      (a, b) => a + b,
                    );
                    final pct = total == 0 ? 0.0 : e.value / total;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    e.key.icon,
                                    size: 16,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    e.key.localizedLabel(context),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                              Text(
                                '${e.value.toStringAsFixed(0)} $currency',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: pct,
                              minHeight: 6,
                              backgroundColor: AppColors.bg,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            if (data.overdueClients.isNotEmpty) ...[
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.overdueTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  StatusBadge.overdue(l10n),
                ],
              ),
              const SizedBox(height: 12),
              ...data.overdueClients
                  .take(5)
                  .map(
                    (c) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        leading: CircleAvatar(
                          backgroundColor: AppColors.dangerLight,
                          child: Text(
                            c.fullName.isNotEmpty
                                ? c.fullName[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              color: AppColors.danger,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        title: Text(
                          c.fullName,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text('${l10n.contract}: ${c.contractNumber}'),
                        trailing: Text(
                          '${c.amountDue.toStringAsFixed(0)} $currency',
                          style: const TextStyle(
                            color: AppColors.danger,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ClientDetailScreen(client: c),
                          ),
                        ),
                      ),
                    ),
                  ),
              if (data.overdueClients.length > 5)
                Align(
                  alignment: Alignment.center,
                  child: TextButton.icon(
                    onPressed: () =>
                        _showAllOverdueDialog(context, data.overdueClients, currency),
                    icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                    label: Text(
                      l10n.viewAllOverdue(data.overdueClients.length - 5),
                    ),
                  ),
                ),
            ],
          ],
        );
      },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) {
          debugPrint('Error: $e');
          return Center(child: Text('${AppLocalizations.of(context)!.error}: $e'));
        },
      ),
    );
  }
}

class _RevenueHeroCard extends StatelessWidget {
  final DashboardData data;
  final String currency;
  const _RevenueHeroCard({required this.data, required this.currency});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final up = data.monthOverMonthPct >= 0;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.collectedThisMonth,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Text(
            '${data.collectedThisMonth.toStringAsFixed(0)} $currency',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      up
                          ? Icons.trending_up_rounded
                          : Icons.trending_down_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      l10n.vsLastMonth(data.monthOverMonthPct.abs().toStringAsFixed(0)),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                l10n.paymentsCount(data.paymentsCountThisMonth),
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniKpi extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? sub;
  final Color color;

  const _MiniKpi({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 22),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (sub != null)
                  Text(
                    sub!,
                    style: TextStyle(
                      fontSize: 11,
                      color: color.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
