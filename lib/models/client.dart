import 'package:cloud_firestore/cloud_firestore.dart';

enum PaymentPeriod { monthly, quarterly, semester, annual }

extension PaymentPeriodX on PaymentPeriod {
  String get label {
    switch (this) {
      case PaymentPeriod.monthly:
        return 'Mensuel';
      case PaymentPeriod.quarterly:
        return 'Trimestriel';
      case PaymentPeriod.semester:
        return 'Semestriel';
      case PaymentPeriod.annual:
        return 'Annuel';
    }
  }

  int get months {
    switch (this) {
      case PaymentPeriod.monthly:
        return 1;
      case PaymentPeriod.quarterly:
        return 3;
      case PaymentPeriod.semester:
        return 6;
      case PaymentPeriod.annual:
        return 12;
    }
  }
}

class Client {
  final String id; // Firestore doc id
  final String contractNumber;
  final String fullName;
  final String? phone;
  final String? address;
  final PaymentPeriod paymentPeriod;
  final double amountDue; // amount due per period
  final DateTime contractStartDate;
  final bool isActive;

  Client({
    required this.id,
    required this.contractNumber,
    required this.fullName,
    this.phone,
    this.address,
    required this.paymentPeriod,
    required this.amountDue,
    required this.contractStartDate,
    this.isActive = true,
  });

  factory Client.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Client(
      id: doc.id,
      contractNumber: data['contractNumber'] ?? '',
      fullName: data['fullName'] ?? '',
      phone: data['phone'],
      address: data['address'],
      paymentPeriod: PaymentPeriod.values.firstWhere(
        (e) => e.name == data['paymentPeriod'],
        orElse: () => PaymentPeriod.monthly,
      ),
      amountDue: (data['amountDue'] ?? 0).toDouble(),
      contractStartDate: (data['contractStartDate'] as Timestamp).toDate(),
      isActive: data['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'contractNumber': contractNumber,
      'fullName': fullName,
      'phone': phone,
      'address': address,
      'paymentPeriod': paymentPeriod.name,
      'amountDue': amountDue,
      'contractStartDate': Timestamp.fromDate(contractStartDate),
      'isActive': isActive,
    };
  }

  Client copyWith({
    String? id,
    String? contractNumber,
    String? fullName,
    String? phone,
    String? address,
    PaymentPeriod? paymentPeriod,
    double? amountDue,
    DateTime? contractStartDate,
    bool? isActive,
  }) {
    return Client(
      id: id ?? this.id,
      contractNumber: contractNumber ?? this.contractNumber,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      paymentPeriod: paymentPeriod ?? this.paymentPeriod,
      amountDue: amountDue ?? this.amountDue,
      contractStartDate: contractStartDate ?? this.contractStartDate,
      isActive: isActive ?? this.isActive,
    );
  }
}