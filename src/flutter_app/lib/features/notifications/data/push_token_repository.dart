import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';

class PushTokenRepository {
  PushTokenRepository({FirebaseFunctions? functions})
      : _functions = functions ?? FirebaseFunctions.instance;

  final FirebaseFunctions _functions;

  Future<void> registerPushToken({
    required String token,
    required String platform,
    String? preferredLocale,
  }) async {
    final callable = _functions.httpsCallable('registerPushToken');
    await callable.call(<String, dynamic>{
      'token': token,
      'platform': platform,
      if (preferredLocale != null) 'preferredLocale': preferredLocale,
    });
  }

  static String platformLabel() {
    if (kIsWeb) return 'web';
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'android';
      case TargetPlatform.iOS:
        return 'ios';
      default:
        return 'unknown';
    }
  }
}
