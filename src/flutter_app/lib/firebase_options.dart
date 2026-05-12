// Debe coincidir con `android/app/google-services.json`. Regenerar con:
// `dart pub global activate flutterfire_cli` → `flutterfire configure`
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Web no configurado para Tarci Secret.');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError('Plataforma no soportada.');
    }
  }

  // Valores tomados de google-services.json (proyecto tarciswap-dev).
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD_wnFRIiU7LjckxUsTp3QvJt-ALc6-kPk',
    appId: '1:857129315324:android:0344f4c20006b13c212079',
    messagingSenderId: '857129315324',
    projectId: 'tarciswap-dev',
    storageBucket: 'tarciswap-dev.firebasestorage.app',
  );

  // Placeholder: generar con `flutterfire configure` si compilas para iOS.
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDummyEmulatorOnlyKey000000000000',
    appId: '1:123456789012:ios:abc0000000000000emulator',
    messagingSenderId: '123456789012',
    projectId: 'tarciswap-dev',
    storageBucket: 'tarciswap-dev.firebasestorage.app',
    iosBundleId: 'com.secretswap.secretswap',
  );
}
