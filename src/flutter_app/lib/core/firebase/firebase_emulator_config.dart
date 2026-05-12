import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Conecta SDKs al Firebase Emulator Suite solo si:
/// - NO es release
/// - `--dart-define=USE_FIREBASE_EMULATORS=true`
///
/// Host del host de emuladores (opcional):
/// - `flutter run --dart-define=FIREBASE_EMULATOR_HOST=<ip>`
/// - Si no se define: Android → `10.0.2.2`, otras plataformas → `127.0.0.1`
class FirebaseEmulatorConfig {
  FirebaseEmulatorConfig._();

  static const int authPort = 9099;
  static const int firestorePort = 8080;
  static const int functionsPort = 5001;

  static const String _hostFromEnvironment = String.fromEnvironment(
    'FIREBASE_EMULATOR_HOST',
  );
  static const String _useEmulatorsFromEnvironment = String.fromEnvironment(
    'USE_FIREBASE_EMULATORS',
    defaultValue: 'false',
  );

  static String get useEmulatorsDefineRaw => _useEmulatorsFromEnvironment;
  static String get hostDefineRaw => _hostFromEnvironment;

  static bool get shouldUseEmulators {
    if (kReleaseMode) return false;
    return _useEmulatorsFromEnvironment.toLowerCase() == 'true';
  }

  static String get _host {
    if (_hostFromEnvironment.isNotEmpty) {
      return _hostFromEnvironment;
    }
    if (Platform.isAndroid) {
      return '10.0.2.2';
    }
    return '127.0.0.1';
  }

  static String get resolvedHost => _host;

  /// Debe llamarse tras [Firebase.initializeApp] y antes de Auth/Firestore/Functions.
  static Future<void> connectIfEnabled() async {
    if (!shouldUseEmulators) {
      debugPrint(
        '[TarciSwap] connect emulators skipped '
        '(kReleaseMode=$kReleaseMode, USE_FIREBASE_EMULATORS=$useEmulatorsDefineRaw, '
        'FIREBASE_EMULATOR_HOST=${hostDefineRaw.isEmpty ? "<auto:$resolvedHost>" : hostDefineRaw})',
      );
      return;
    }

    debugPrint(
      '[TarciSwap] emulators enabled host=$_host '
      'auth=$authPort firestore=$firestorePort functions=$functionsPort',
    );
    await FirebaseAuth.instance.useAuthEmulator(_host, authPort);
    FirebaseFirestore.instance.useFirestoreEmulator(_host, firestorePort);
    FirebaseFunctions.instanceFor(region: 'us-central1').useFunctionsEmulator(_host, functionsPort);
  }
}
