import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

enum PaymentMethod { cash, postal, card, check }

extension PaymentMethodX on PaymentMethod {
  String get label {
    switch (this) {
      case PaymentMethod.cash:
        return 'Espèces';
      case PaymentMethod.postal:
        return 'Poste';
      case PaymentMethod.card:
        return 'Carte bancaire';
      case PaymentMethod.check:
        return 'Chèque';
    }
  }

  String localizedLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case PaymentMethod.cash:
        return l10n.cash;
      case PaymentMethod.postal:
        return l10n.postal;
      case PaymentMethod.card:
        return l10n.card;
      case PaymentMethod.check:
        return l10n.check;
    }
  }

  IconData get icon {
    switch (this) {
      case PaymentMethod.cash:
        return Icons.payments_outlined;
      case PaymentMethod.postal:
        return Icons.local_post_office_outlined;
      case PaymentMethod.card:
        return Icons.credit_card_outlined;
      case PaymentMethod.check:
        return Icons.receipt_outlined;
    }
  }

  // Clients paid via postal/card are usually never met in person —
  // useful to flag for quittance follow-up
  bool get isRemote => this == PaymentMethod.postal || this == PaymentMethod.card;
}

class Payment {
  final String id;
  final String clientId;
  final String? userId;
  final double amountPaid;
  final DateTime paymentDate;
  final DateTime periodStart; // period this payment covers
  final DateTime periodEnd;
  final PaymentMethod method;
  final bool quittanceGiven;
  final DateTime? quittanceDate;

  Payment({
    required this.id,
    required this.clientId,
    this.userId,
    required this.amountPaid,
    required this.paymentDate,
    required this.periodStart,
    required this.periodEnd,
    required this.method,
    this.quittanceGiven = false,
    this.quittanceDate,
  });

  factory Payment.fromFirestore(DocumentSnapshot doc, String clientId) {
    final data = doc.data() as Map<String, dynamic>;
    return Payment(
      id: doc.id,
      clientId: clientId,
      userId: data['userId'],
      amountPaid: (data['amountPaid'] ?? 0).toDouble(),
      paymentDate: (data['paymentDate'] as Timestamp).toDate(),
      periodStart: (data['periodStart'] as Timestamp).toDate(),
      periodEnd: (data['periodEnd'] as Timestamp).toDate(),
      method: PaymentMethod.values.firstWhere(
        (e) => e.name == data['method'],
        orElse: () => PaymentMethod.cash,
      ),
      quittanceGiven: data['quittanceGiven'] ?? false,
      quittanceDate: data['quittanceDate'] != null
          ? (data['quittanceDate'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (userId != null) 'userId': userId,
      'amountPaid': amountPaid,
      'paymentDate': Timestamp.fromDate(paymentDate),
      'periodStart': Timestamp.fromDate(periodStart),
      'periodEnd': Timestamp.fromDate(periodEnd),
      'method': method.name,
      'quittanceGiven': quittanceGiven,
      'quittanceDate':
          quittanceDate != null ? Timestamp.fromDate(quittanceDate!) : null,
    };
  }

  Payment copyWith({
    String? id,
    String? clientId,
    String? userId,
    double? amountPaid,
    DateTime? paymentDate,
    DateTime? periodStart,
    DateTime? periodEnd,
    PaymentMethod? method,
    bool? quittanceGiven,
    DateTime? quittanceDate,
  }) {
    return Payment(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      userId: userId ?? this.userId,
      amountPaid: amountPaid ?? this.amountPaid,
      paymentDate: paymentDate ?? this.paymentDate,
      periodStart: periodStart ?? this.periodStart,
      periodEnd: periodEnd ?? this.periodEnd,
      method: method ?? this.method,
      quittanceGiven: quittanceGiven ?? this.quittanceGiven,
      quittanceDate: quittanceDate ?? this.quittanceDate,
    );
  }
}