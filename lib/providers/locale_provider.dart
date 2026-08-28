import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(() {
  return LocaleNotifier();
});

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    return const Locale('en');
  }

  void changeLanguage(String languageCode) {
    Locale newLocale;
    switch (languageCode) {
      case 'fr':
        newLocale = const Locale('fr');
        break;
      case 'ar':
        newLocale = const Locale('ar');
        break;
      case 'es':
        newLocale = const Locale('es');
        break;
      case 'en':
      default:
        newLocale = const Locale('en');
        break;
    }
    if (state != newLocale) {
      state = newLocale;
    }
  }
}
