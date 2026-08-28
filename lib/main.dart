import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:paycheck/l10n/app_localizations.dart';
import 'package:paycheck/screens/auth/auth_gate.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:paycheck/theme/app_theme.dart';
import 'package:paycheck/providers/locale_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  // Initialize date formatting for all supported locales (both bare tags and regional)
  await initializeDateFormatting('en', null);
  await initializeDateFormatting('en_US', null);
  await initializeDateFormatting('fr', null);
  await initializeDateFormatting('fr_FR', null);
  await initializeDateFormatting('ar', null);
  await initializeDateFormatting('ar_TN', null);
  await initializeDateFormatting('es', null);
  await initializeDateFormatting('es_ES', null);

  runApp(const ProviderScope(child: PayCheckApp()));
}

class PayCheckApp extends ConsumerWidget {
  const PayCheckApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);

    return MaterialApp(
      title: 'PayCheck',
      theme: buildAppTheme(),
      debugShowCheckedModeBanner: false,
      locale: currentLocale,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English (Primary/Template)
        Locale('fr'), // French
        Locale('ar'), // Arabic
        Locale('es'), // Spanish
      ],
      home: const AuthGate(),
    );
  }
}
