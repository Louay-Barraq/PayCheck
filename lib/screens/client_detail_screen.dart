// screens/client_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../models/client.dart';
import '../models/payment.dart';
import '../providers/client_providers.dart';
import '../providers/payment_providers.dart';
import '../providers/user_profile_provider.dart';
import '../utils/payment_utils.dart';
import 'add_payment_screen.dart';

class ClientDetailScreen extends ConsumerWidget {
  final Client client;

  const ClientDetailScreen({super.key, required this.client});

  static final _dateFmt = DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currency = ref.watch(currencySymbolProvider);
    final paymentsAsync = ref.watch(paymentsForClientProvider(client.id));

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F8FA),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          client.fullName,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1F2937),
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Color(0xFF1F2937)),
            onSelected: (value) async {
              if (value == 'toggle_active') {
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
                    const SizedBox(width: 10),
                    Text(client.isActive ? l10n.archive : l10n.activate),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: paymentsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFF0F766E)),
        ),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('${l10n.error}: $error', textAlign: TextAlign.center),
          ),
        ),
        data: (payments) {
          final nextDue = computeNextDue(client, payments);
          final isPaymentOverdue = isOverdue(client, payments);

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
            children: [
              _ClientHeaderCard(
                client: client,
                nextDue: nextDue,
                isPaymentOverdue: isPaymentOverdue,
                dateFmt: _dateFmt,
              ),
              const SizedBox(height: 16),
              _ContractSummaryCard(
                client: client,
                currency: currency,
                dateFmt: _dateFmt,
                payments: payments,
                onViewDetails: () {
                  _showContractDetails(context, client, currency, l10n);
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    l10n.paymentHistory,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (payments.isEmpty)
                _EmptyPaymentsCard(message: l10n.noPayments),
              ...payments.map(
                (payment) => _PaymentCard(
                  payment: payment,
                  currency: currency,
                  dateFmt: _dateFmt,
                  onQuittancePressed: payment.quittanceGiven
                      ? () async {
                          final updated = payment.copyWith(
                            quittanceGiven: false,
                            quittanceDate: DateTime.now(),
                          );
                          final fs = ref.read(firestoreServiceProvider);
                          await fs.updatePayment(updated);
                        }
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
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF98E8D5),
        foregroundColor: const Color(0xFF064E46),
        elevation: 8,
        extendedPadding: const EdgeInsets.symmetric(horizontal: 24),
        icon: const Icon(Icons.add_rounded, size: 28),
        label: Text(
          l10n.addPayment,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddPaymentScreen(client: client)),
          );
        },
      ),
    );
  }

  void _showContractDetails(
    BuildContext context,
    Client client,
    String currency,
    AppLocalizations l10n,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD1D5DB),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.contractDetails,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 20),
                _DetailRow(
                  icon: Icons.description_outlined,
                  label: l10n.contractNumber,
                  value: client.contractNumber,
                ),
                _DetailRow(
                  icon: Icons.calendar_month_outlined,
                  label: l10n.paymentPeriod,
                  value: client.paymentPeriod.localizedLabel(context),
                ),
                _DetailRow(
                  icon: Icons.payments_outlined,
                  label: l10n.amountDue,
                  value: '${client.amountDue.toStringAsFixed(0)} $currency',
                ),
                if (client.phone != null && client.phone!.trim().isNotEmpty)
                  _DetailRow(
                    icon: Icons.phone_outlined,
                    label: l10n.phone,
                    value: client.phone!,
                  ),
                if (client.address != null && client.address!.trim().isNotEmpty)
                  _DetailRow(
                    icon: Icons.location_on_outlined,
                    label: l10n.address,
                    value: client.address!,
                  ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF0F766E),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      l10n.close,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ClientHeaderCard extends StatelessWidget {
  final Client client;
  final DateTime nextDue;
  final bool isPaymentOverdue;
  final DateFormat dateFmt;

  const _ClientHeaderCard({
    required this.client,
    required this.nextDue,
    required this.isPaymentOverdue,
    required this.dateFmt,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final initials = _getInitials(client.fullName);

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Color(0xFFE3F2EF),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  initials,
                  style: const TextStyle(
                    color: Color(0xFF0F766E),
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      client.fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.contractWithNumber(client.contractNumber),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _StatusBadge(
                      isOverdue: isPaymentOverdue,
                      isActive: client.isActive,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isPaymentOverdue
                  ? const Color(0xFFFFF1F2)
                  : const Color(0xFFF1FAF8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isPaymentOverdue
                        ? const Color(0xFFFDE2E4)
                        : const Color(0xFFE0F5F0),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isPaymentOverdue
                        ? Icons.warning_amber_rounded
                        : Icons.event_available_rounded,
                    color: isPaymentOverdue
                        ? const Color(0xFFDC4B4B)
                        : const Color(0xFF0F766E),
                    size: 23,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.nextPaymentDue,
                        style: TextStyle(
                          fontSize: 14,
                          color: isPaymentOverdue
                              ? const Color(0xFFB45353)
                              : const Color(0xFF4B5563),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        dateFmt.format(nextDue),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      if (!isPaymentOverdue) ...[
                        const SizedBox(height: 2),
                        Text(
                          _daysUntilText(nextDue, l10n),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0F766E),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _daysUntilText(DateTime date, AppLocalizations l10n) {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final dueDate = DateTime(date.year, date.month, date.day);
    final days = dueDate.difference(todayDate).inDays;

    if (days <= 0) return l10n.today;
    if (days == 1) return l10n.tomorrow;
    return l10n.inDays(days);
  }

  String _getInitials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
        .toUpperCase();
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isOverdue;
  final bool isActive;

  const _StatusBadge({required this.isOverdue, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (!isActive) {
      return _badge(
        icon: Icons.pause_circle_outline_rounded,
        text: l10n.inactive,
        background: const Color(0xFFF1F3F5),
        foreground: const Color(0xFF6B7280),
      );
    }

    if (isOverdue) {
      return _badge(
        icon: Icons.warning_amber_rounded,
        text: l10n.overdue,
        background: const Color(0xFFFDE8E8),
        foreground: const Color(0xFFD94848),
      );
    }

    return _badge(
      icon: Icons.check_circle_rounded,
      text: l10n.upToDate,
      background: const Color(0xFFE5F6EF),
      foreground: const Color(0xFF269B63),
    );
  }

  Widget _badge({
    required IconData icon,
    required String text,
    required Color background,
    required Color foreground,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: foreground),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: foreground,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContractSummaryCard extends StatelessWidget {
  final Client client;
  final String currency;
  final DateFormat dateFmt;
  final List<Payment> payments;
  final VoidCallback onViewDetails;

  const _ContractSummaryCard({
    required this.client,
    required this.currency,
    required this.dateFmt,
    required this.payments,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    DateTime? contractStart;

    if (payments.isNotEmpty) {
      final sorted = [...payments]
        ..sort((a, b) => a.periodStart.compareTo(b.periodStart));
      contractStart = sorted.first.periodStart;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.assignment_outlined,
                color: Color(0xFF0F766E),
                size: 23,
              ),
              const SizedBox(width: 10),
              Text(
                l10n.contractSummary,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _SummaryItem(
                  icon: Icons.calendar_month_outlined,
                  label: l10n.paymentPeriod,
                  value: client.paymentPeriod.localizedLabel(context),
                ),
              ),
              const SizedBox(width: 6),
              Container(width: 1, height: 62, color: const Color(0xFFE5E7EB)),
              const SizedBox(width: 10),
              Expanded(
                child: _SummaryItem(
                  icon: Icons.payments_outlined,
                  label: l10n.amountDue,
                  value: '${client.amountDue.toStringAsFixed(0)} $currency',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _SummaryItem(
                  icon: Icons.phone_outlined,
                  label: l10n.phone,
                  value: client.phone != null && client.phone!.trim().isNotEmpty
                      ? client.phone!
                      : '—',
                ),
              ),
              const SizedBox(width: 6),
              Container(width: 1, height: 62, color: const Color(0xFFE5E7EB)),
              const SizedBox(width: 10),
              Expanded(
                child: _SummaryItem(
                  icon: Icons.event_outlined,
                  label: l10n.contractStart,
                  value: contractStart != null
                      ? dateFmt.format(contractStart)
                      : '—',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: const BoxDecoration(
            color: Color(0xFFEAF7F4),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xFF0F766E), size: 20),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PaymentCard extends StatelessWidget {
  final Payment payment;
  final String currency;
  final DateFormat dateFmt;
  final VoidCallback? onQuittancePressed;

  const _PaymentCard({
    required this.payment,
    required this.currency,
    required this.dateFmt,
    required this.onQuittancePressed,
  });

  @override
  Widget build(BuildContext context) {
    final isRemote = payment.method.isRemote;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F3F5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.015),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 6,
                color: payment.quittanceGiven
                    ? const Color(0xFF269B63)
                    : const Color(0xFFE0932A),
              ),
              
              const SizedBox(width: 12),
              
              Center(
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isRemote
                        ? const Color(0xFFFFF3DF)
                        : const Color(0xFFEAF7F4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    payment.method.icon,
                    color: isRemote
                        ? const Color(0xFFE0932A)
                        : const Color(0xFF0F766E),
                    size: 18,
                  ),
                ),
              ),
              
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          // const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '${payment.amountPaid.toStringAsFixed(0)} $currency',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF1F2937),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF3F4F6),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        payment.method.localizedLabel(context),
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF4B5563),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  l10n.paymentDateWithLabel(
                                    dateFmt.format(payment.paymentDate),
                                  ),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF6B7280),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${dateFmt.format(payment.periodStart)} → ${dateFmt.format(payment.periodEnd)}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF9CA3AF),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // const SizedBox(width: 8),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: _ReceiptBadge(
                            given: payment.quittanceGiven,
                            onPressed: onQuittancePressed,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReceiptBadge extends StatelessWidget {
  final bool given;
  final VoidCallback? onPressed;

  const _ReceiptBadge({required this.given, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final background = given
        ? const Color(0xFFEAF7EF)
        : const Color(0xFFFFF2DE);
    final foreground = given
        ? const Color(0xFF269B63)
        : const Color(0xFFE0932A);
    final icon = given ? Icons.check_circle_rounded : Icons.receipt_outlined;
    final text = given ? l10n.receiptIssued : l10n.quittancePending;

    final badge = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: foreground.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: foreground, size: 15),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: foreground,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );

    if (onPressed == null) {
      return badge;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: badge,
      ),
    );
  }
}

class _EmptyPaymentsCard extends StatelessWidget {
  final String message;

  const _EmptyPaymentsCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: const BoxDecoration(
              color: Color(0xFFEAF7F4),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.receipt_long_outlined,
              color: Color(0xFF0F766E),
              size: 27,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF6B7280), fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: Color(0xFFEAF7F4),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF0F766E), size: 20),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
