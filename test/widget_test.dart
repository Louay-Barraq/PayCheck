import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paycheck/theme/app_theme.dart';
import 'package:paycheck/widgets/status_badge.dart';

void main() {
  testWidgets('StatusBadge renders appropriate labels and colors', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: Scaffold(
          body: Column(
            children: [
              StatusBadge.overdue(),
              StatusBadge.upToDate(),
              StatusBadge.quittancePending(),
            ],
          ),
        ),
      ),
    );

    expect(find.text('En retard'), findsOneWidget);
    expect(find.text('À jour'), findsOneWidget);
    expect(find.text('Quittance en attente'), findsOneWidget);
  });
}
