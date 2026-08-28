// screens/client_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../utils/payment_utils.dart';
import '../models/client.dart';
import '../models/payment.dart';
import '../providers/client_providers.dart';
import '../providers/payment_providers.dart';
import 'add_payment_screen.dart';

class ClientDetailScreen extends ConsumerWidget {
  final Client client;
  const ClientDetailScreen({super.key, required this.client});

  static final _dateFmt = DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final paymentsAsync = ref.watch(paymentsForClientProvider(client.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(client.fullName),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (val) async {
              if (val == 'toggle_active') {
                final fs = ref.read(firestoreServiceProvider);
                final updated = client.copyWith(isActive: !client.isActive);
                await fs.updateClient(updated);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        updated.isActive ? l10n.activate : l10n.archive,
                      ),
                    ),
                  );
                }
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'toggle_active',
                child: Row(
                  children: [
                    Icon(
                      client.isActive
                          ? Icons.archive_outlined
                          : Icons.unarchive_outlined,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(client.isActive ? l10n.archive : l10n.activate),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: paymentsAsync.when(
        data: (payments) {
          final nextDue = computeNextDue(client, payments);
          final isPaymentOverdue = isOverdue(client, payments);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${l10n.contractNumber}: ${client.contractNumber}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          if (!client.isActive)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                l10n.inactive,
                                style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text('${l10n.paymentPeriod}: ${client.paymentPeriod.localizedLabel(context)}'),
                      Text('${l10n.amountDue}: ${client.amountDue.toStringAsFixed(0)} DT'),
                      if (client.phone != null && client.phone!.isNotEmpty)
                        Text('${l10n.phone}: ${client.phone}'),
                      if (client.address != null && client.address!.isNotEmpty)
                        Text('${l10n.address}: ${client.address}'),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            isPaymentOverdue
                                ? Icons.warning_amber_rounded
                                : Icons.check_circle_rounded,
                            color: isPaymentOverdue ? Colors.red : Colors.green,
                            size: 20,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isPaymentOverdue
                                ? '${l10n.overdue} ${_dateFmt.format(nextDue)}'
                                : '${l10n.nextPaymentDue}: ${_dateFmt.format(nextDue)}',
                            style: TextStyle(
                              color: isPaymentOverdue ? Colors.red : Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                l10n.paymentHistory,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (payments.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Center(
                    child: Text(
                      l10n.noPayments,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ...payments.map((p) => _PaymentTile(payment: p)),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('${l10n.error}: $e')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: Text(l10n.addPayment),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddPaymentScreen(client: client)),
        ),
      ),
    );
  }
}

class _PaymentTile extends ConsumerWidget {
  final Payment payment;
  const _PaymentTile({required this.payment});

  static final _dateFmt = DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: payment.method.isRemote
              ? const Color(0xFFFCF0DC)
              : const Color(0xFFE3F2EF),
          child: Icon(
            payment.method.icon,
            color: payment.method.isRemote
                ? const Color(0xFFE0932A)
                : const Color(0xFF0F6B5C),
            size: 20,
          ),
        ),
        title: Text('${payment.amountPaid.toStringAsFixed(0)} DT — ${payment.method.localizedLabel(context)}'),
        subtitle: Text(
          '${l10n.paymentDate}: ${_dateFmt.format(payment.paymentDate)}\n'
          '${_dateFmt.format(payment.periodStart)} → ${_dateFmt.format(payment.periodEnd)}',
        ),
        isThreeLine: true,
        trailing: IconButton(
          icon: Icon(
            payment.quittanceGiven
                ? Icons.receipt_long_rounded
                : Icons.receipt_outlined,
            color: payment.quittanceGiven ? Colors.green : Colors.orange,
          ),
          tooltip: payment.quittanceGiven
              ? l10n.quittanceGiven
              : l10n.quittancePending,
          onPressed: payment.quittanceGiven
              ? null
              : () async {
                  final updated = payment.copyWith(
                    quittanceGiven: true,
                    quittanceDate: DateTime.now(),
                  );
                  final fs = ref.read(firestoreServiceProvider);
                  await fs.updatePayment(updated);
                },
        ),
      ),
    );
  }
}
