import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _localePrefKey = 'tarci.locale';

class LocaleController extends Notifier<Locale?> {
  @override
  Locale? build() {
    _loadSavedLocale();
    return null; // null => sigue idioma del sistema
  }

  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_localePrefKey);
    if (raw == null || raw.isEmpty || raw == 'system') {
      state = null;
      return;
    }
    state = Locale(raw);
  }

  Future<void> useSystemLocale() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localePrefKey, 'system');
    state = null;
  }

  Future<void> setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localePrefKey, locale.languageCode);
    state = locale;
  }
}

final localeControllerProvider = NotifierProvider<LocaleController, Locale?>(
  LocaleController.new,
);

