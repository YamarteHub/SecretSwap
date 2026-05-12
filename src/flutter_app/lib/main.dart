import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'app/providers.dart';
import 'core/firebase/firebase_emulator_config.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint('[TarciSwap] main start');

  debugPrint('[TarciSwap] Firebase initialize start');
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e, st) {
    debugPrint('[TarciSwap] Firebase initialize FAILED: $e');
    debugPrint('$st');
    runApp(_FirebaseErrorApp(message: '$e'));
    return;
  }
  debugPrint('[TarciSwap] Firebase initialize OK');
  debugPrint(
    '[TarciSwap] env USE_FIREBASE_EMULATORS=${FirebaseEmulatorConfig.useEmulatorsDefineRaw} '
    'FIREBASE_EMULATOR_HOST='
    '${FirebaseEmulatorConfig.hostDefineRaw.isEmpty ? "<auto:${FirebaseEmulatorConfig.resolvedHost}>" : FirebaseEmulatorConfig.hostDefineRaw}',
  );
  debugPrint(
    '[TarciSwap] env emulator_connection='
    '${FirebaseEmulatorConfig.shouldUseEmulators ? "enabled" : "disabled"}',
  );

  debugPrint('[TarciSwap] connect emulators (if enabled) start');
  try {
    await FirebaseEmulatorConfig.connectIfEnabled().timeout(
      const Duration(seconds: 15),
      onTimeout: () {
        throw TimeoutException(
          'Emuladores no respondieron en 15s. Comprueba que el suite '
          'esté en marcha y FIREBASE_EMULATOR_HOST (móvil físico).',
        );
      },
    );
    debugPrint('[TarciSwap] connect emulators OK');
  } catch (e, st) {
    debugPrint('[TarciSwap] connect emulators FAILED (continuando): $e');
    debugPrint('$st');
  }

  debugPrint('[TarciSwap] runApp');
  runApp(const ProviderScope(child: _Bootstrap()));
}

/// Pantalla mínima si [Firebase.initializeApp] falla (evita quedar en el splash nativo).
class _FirebaseErrorApp extends StatelessWidget {
  const _FirebaseErrorApp({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Tarci Secret',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'No se pudo iniciar Firebase.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  SelectableText(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12, color: Colors.red),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Bootstrap extends ConsumerWidget {
  const _Bootstrap();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return TarciSwapApp(router: router);
  }
}
