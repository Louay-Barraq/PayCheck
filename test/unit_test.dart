import 'package:flutter_test/flutter_test.dart';
import 'package:paycheck/models/client.dart';
import 'package:paycheck/models/payment.dart';
import 'package:paycheck/utils/payment_utils.dart';

void main() {
  group('PaymentUtils Tests', () {
    test('addMonths adds months safely without day overflow', () {
      final jan31 = DateTime(2026, 1, 31);
      final feb = addMonths(jan31, 1);
      expect(feb.year, 2026);
      expect(feb.month, 2);
      expect(feb.day, 28); // 2026 is not a leap year

      final oct31 = DateTime(2026, 10, 31);
      final nov = addMonths(oct31, 1);
      expect(nov.month, 11);
      expect(nov.day, 30);
    });

    test('computeNextDue returns contract start date when no payments exist', () {
      final client = Client(
        id: '1',
        contractNumber: 'C001',
        fullName: 'Test User',
        paymentPeriod: PaymentPeriod.monthly,
        amountDue: 100,
        contractStartDate: DateTime(2026, 1, 1),
      );

      final nextDue = computeNextDue(client, []);
      expect(nextDue, DateTime(2026, 1, 1));
    });

    test('computeNextDue returns latest payment periodEnd', () {
      final client = Client(
        id: '1',
        contractNumber: 'C001',
        fullName: 'Test User',
        paymentPeriod: PaymentPeriod.monthly,
        amountDue: 100,
        contractStartDate: DateTime(2026, 1, 1),
      );

      final payments = [
        Payment(
          id: 'p1',
          clientId: '1',
          amountPaid: 100,
          paymentDate: DateTime(2026, 1, 1),
          periodStart: DateTime(2026, 1, 1),
          periodEnd: DateTime(2026, 2, 1),
          method: PaymentMethod.cash,
        ),
        Payment(
          id: 'p2',
          clientId: '1',
          amountPaid: 100,
          paymentDate: DateTime(2026, 2, 1),
          periodStart: DateTime(2026, 2, 1),
          periodEnd: DateTime(2026, 3, 1),
          method: PaymentMethod.cash,
        ),
      ];

      final nextDue = computeNextDue(client, payments);
      expect(nextDue, DateTime(2026, 3, 1));
    });
  });
}
