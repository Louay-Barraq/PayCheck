import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paycheck/l10n/app_localizations.dart';
import 'package:paycheck/theme/app_theme.dart';
import 'package:paycheck/widgets/status_badge.dart';

void main() {
  testWidgets('StatusBadge renders appropriate localized labels and colors', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        locale: const Locale('en'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(builder: (context) {
          final l10n = AppLocalizations.of(context)!;
          return Scaffold(
            body: Column(
              children: [
                StatusBadge.overdue(l10n),
                StatusBadge.upToDate(l10n),
                StatusBadge.quittancePending(l10n),
              ],
            ),
          );
        }),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Overdue'), findsOneWidget);
    expect(find.text('Up to Date'), findsOneWidget);
    expect(find.text('Receipt Pending'), findsOneWidget);
  });
}
