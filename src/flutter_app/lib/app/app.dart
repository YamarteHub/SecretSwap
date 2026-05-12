import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import '../core/l10n/locale_controller.dart';
import '../l10n/app_localizations.dart';
import '../core/theme/app_theme.dart';

class TarciSwapApp extends ConsumerWidget {
  final GoRouter router;

  const TarciSwapApp({super.key, required this.router});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLocale = ref.watch(localeControllerProvider);
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appName,
      theme: AppTheme.light(),
      routerConfig: router,
      locale: selectedLocale,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        if (selectedLocale != null) return selectedLocale;
        if (deviceLocale == null) return const Locale('es');
        for (final locale in supportedLocales) {
          if (locale.languageCode == deviceLocale.languageCode) {
            return locale;
          }
        }
        return const Locale('es');
      },
    );
  }
}
