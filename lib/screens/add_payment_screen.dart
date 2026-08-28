import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../models/client.dart';
import '../models/payment.dart';
import '../providers/client_providers.dart';
import '../theme/app_theme.dart';
import '../utils/payment_utils.dart';

class AddPaymentScreen extends ConsumerStatefulWidget {
  final Client client;
  const AddPaymentScreen({super.key, required this.client});

  @override
  ConsumerState<AddPaymentScreen> createState() => _AddPaymentScreenState();
}

class _AddPaymentScreenState extends ConsumerState<AddPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  DateTime _paymentDate = DateTime.now();
  DateTime _periodStart = DateTime.now();
  PaymentMethod _method = PaymentMethod.cash;
  bool _quittanceGiven = false;
  bool _saving = false;

  static final _dateFmt = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    _amountCtrl.text = widget.client.amountDue.toStringAsFixed(0);
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  DateTime get _periodEnd => addMonths(_periodStart, widget.client.paymentPeriod.months);

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    try {
      final amount = double.tryParse(_amountCtrl.text.trim());
      if (amount == null || amount <= 0) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Veuillez entrer un montant valide supérieur à 0')),
        );
        return;
      }

      final payment = Payment(
        id: const Uuid().v4(),
        clientId: widget.client.id,
        amountPaid: amount,
        paymentDate: _paymentDate,
        periodStart: _periodStart,
        periodEnd: _periodEnd,
        method: _method,
        quittanceGiven: _quittanceGiven,
        quittanceDate: _quittanceGiven ? DateTime.now() : null,
      );

      final fs = ref.read(firestoreServiceProvider);
      await fs.addPayment(payment);
      if (mounted) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Paiement enregistré avec succès')),
        );
        navigator.pop();
      }
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'enregistrement: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _pickDate(bool isPaymentDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isPaymentDate ? _paymentDate : _periodStart,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isPaymentDate) {
          _paymentDate = picked;
        } else {
          _periodStart = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nouveau paiement')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            // Client summary chip
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: AppColors.primary,
                    child: Icon(Icons.person, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.client.fullName,
                            style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                        Text('N° ${widget.client.contractNumber} · ${widget.client.paymentPeriod.label}',
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _amountCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Montant payé (DT)',
                        prefixIcon: Icon(Icons.payments_outlined),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (v) {
                        final d = double.tryParse(v?.trim() ?? '');
                        return (d == null || d <= 0) ? 'Montant invalide' : null;
                      },
                    ),
                    const SizedBox(height: 14),
                    _DateRow(
                      label: 'Date de paiement',
                      date: _paymentDate,
                      formattedDate: _dateFmt.format(_paymentDate),
                      onTap: () => _pickDate(true),
                    ),
                    const SizedBox(height: 10),
                    _DateRow(
                      label: 'Début de la période couverte',
                      date: _periodStart,
                      formattedDate: _dateFmt.format(_periodStart),
                      subLabel: 'Jusqu\'au ${_dateFmt.format(_periodEnd)}',
                      onTap: () => _pickDate(false),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(bottom: 8, left: 4),
              child: Text('Méthode de paiement',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
            ),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 2.6,
              children: PaymentMethod.values.map((m) {
                final selected = m == _method;
                return InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => setState(() {
                    _method = m;
                    if (m.isRemote) _quittanceGiven = false;
                  }),
                  child: Container(
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primaryLight : AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: selected ? AppColors.primary : Colors.grey.shade300),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(m.icon, size: 18, color: selected ? AppColors.primary : AppColors.textSecondary),
                        const SizedBox(width: 8),
                        Text(m.label,
                            style: TextStyle(
                              color: selected ? AppColors.primary : AppColors.textPrimary,
                              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                              fontSize: 13,
                            )),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),
            Card(
              color: _method.isRemote ? AppColors.warningLight : AppColors.surface,
              child: SwitchListTile(
                title: const Text('Quittance donnée', style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: _method.isRemote
                    ? const Text('Paiement à distance — pensez à faire parvenir la quittance',
                        style: TextStyle(fontSize: 12))
                    : null,
                value: _quittanceGiven,
                activeThumbColor: AppColors.primary,
                onChanged: (v) => setState(() => _quittanceGiven = v),
              ),
            ),

            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox(
                      width: 18, height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.check_rounded),
              label: Text(_saving ? 'Enregistrement...' : 'Enregistrer le paiement'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateRow extends StatelessWidget {
  final String label;
  final String? subLabel;
  final DateTime date;
  final String formattedDate;
  final VoidCallback onTap;

  const _DateRow({
    required this.label,
    required this.date,
    required this.formattedDate,
    required this.onTap,
    this.subLabel,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_rounded, size: 18, color: AppColors.textSecondary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: Theme.of(context).textTheme.bodySmall),
                  Text(formattedDate, style: const TextStyle(fontWeight: FontWeight.w600)),
                  if (subLabel != null)
                    Text(subLabel!, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}