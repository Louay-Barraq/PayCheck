import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paycheck/screens/auth/auth_gate.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:paycheck/theme/app_theme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  await initializeDateFormatting('fr_FR', null);

  runApp(const ProviderScope(child: PayCheckApp()));
}

class PayCheckApp extends StatelessWidget {
  const PayCheckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PayCheck',
      theme: buildAppTheme(),
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
    );
  }
}
