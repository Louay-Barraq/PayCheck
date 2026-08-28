import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _kLanguagePrefKey = 'selected_language_code';
const List<String> _kSupportedLanguages = ['en', 'fr', 'ar', 'es'];

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(() {
  return LocaleNotifier();
});

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    // 1. Check system/device locale
    final deviceLang = PlatformDispatcher.instance.locale.languageCode.toLowerCase();
    final defaultLang = _kSupportedLanguages.contains(deviceLang) ? deviceLang : 'en';

    // 2. Load saved preference asynchronously
    _loadSavedLocale(defaultLang);

    return Locale(defaultLang);
  }

  Future<void> _loadSavedLocale(String fallbackLang) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCode = prefs.getString(_kLanguagePrefKey);
      if (savedCode != null && _kSupportedLanguages.contains(savedCode)) {
        if (state.languageCode != savedCode) {
          state = Locale(savedCode);
        }
      }
    } catch (_) {}
  }

  Future<void> changeLanguage(String languageCode) async {
    final code = _kSupportedLanguages.contains(languageCode) ? languageCode : 'en';
    final newLocale = Locale(code);

    if (state != newLocale) {
      state = newLocale;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kLanguagePrefKey, code);
    } catch (_) {}
  }
}
