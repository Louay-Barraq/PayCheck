import 'payment.dart';

class PaymentWithClient {
  final Payment payment;
  final String clientName;
  final String contractNumber;

  const PaymentWithClient({
    required this.payment,
    required this.clientName,
    required this.contractNumber,
  });
}
