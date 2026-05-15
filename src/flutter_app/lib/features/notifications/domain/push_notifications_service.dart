import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/routing/app_router.dart';
import '../data/push_token_repository.dart';

const _pushActivatedKey = 'tarci.push.activated';
const _pushPromoDismissedKey = 'tarci.push.promoDismissed';

/// Handler de mensajes en background (proceso aislado).
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('[TarciPush] background message: ${message.messageId}');
}

class PushNotificationsService {
  PushNotificationsService({
    FirebaseMessaging? messaging,
    PushTokenRepository? tokenRepository,
    required GlobalKey<NavigatorState> navigatorKey,
  })  : _messaging = messaging ?? FirebaseMessaging.instance,
        _tokenRepository = tokenRepository ?? PushTokenRepository(),
        _navigatorKey = navigatorKey;

  final FirebaseMessaging _messaging;
  final PushTokenRepository _tokenRepository;
  final GlobalKey<NavigatorState> _navigatorKey;

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    final initial = await _messaging.getInitialMessage();
    if (initial != null) {
      _scheduleNavigation(initial);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_scheduleNavigation);

    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    _messaging.onTokenRefresh.listen((token) async {
      final locale = await _readPreferredLocaleCode();
      try {
        await _tokenRepository.registerPushToken(
          token: token,
          platform: PushTokenRepository.platformLabel(),
          preferredLocale: locale,
        );
        await _setActivated(true);
      } catch (e, st) {
        debugPrint('[TarciPush] token refresh register failed: $e\n$st');
      }
    });
  }

  void _onForegroundMessage(RemoteMessage message) {
    final data = message.data;
    final groupId = data['groupId'];
    if (groupId == null || groupId.isEmpty) return;

    final ctx = _navigatorKey.currentContext;
    if (ctx == null) return;

    final title = message.notification?.title;
    final body = message.notification?.body;
    final label = [
      if (title != null && title.isNotEmpty) title,
      if (body != null && body.isNotEmpty) body,
    ].join('\n');

    if (label.isEmpty) return;

    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Text(label),
        action: SnackBarAction(
          label: '→',
          onPressed: () => _navigateToGroup(groupId),
        ),
      ),
    );
  }

  void _scheduleNavigation(RemoteMessage message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleOpenMessage(message);
    });
  }

  void _handleOpenMessage(RemoteMessage message) {
    final groupId = message.data['groupId'];
    if (groupId == null || groupId.isEmpty) return;
    _navigateToGroup(groupId);
  }

  void _navigateToGroup(String groupId) {
    final ctx = _navigatorKey.currentContext;
    if (ctx == null) return;
    ctx.go(AppRoutes.groupDetailFor(groupId));
  }

  Future<bool> isActivated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_pushActivatedKey) ?? false;
  }

  Future<bool> isPromoDismissed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_pushPromoDismissedKey) ?? false;
  }

  Future<void> dismissPromo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_pushPromoDismissedKey, true);
  }

  Future<void> _setActivated(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_pushActivatedKey, value);
  }

  Future<String?> _readPreferredLocaleCode() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('tarci.locale');
    if (raw == null || raw.isEmpty || raw == 'system') return null;
    return raw;
  }

  Future<bool> requestPermissionAndRegister({String? preferredLocale}) async {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      final status = await Permission.notification.request();
      if (!status.isGranted && !status.isLimited) {
        return false;
      }
    }

    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    final allowed = settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
    if (!allowed) {
      return false;
    }

    final token = await _messaging.getToken();
    if (token == null || token.isEmpty) {
      return false;
    }

    await _tokenRepository.registerPushToken(
      token: token,
      platform: PushTokenRepository.platformLabel(),
      preferredLocale: preferredLocale,
    );
    await _setActivated(true);
    return true;
  }

  Future<void> syncPreferredLocale(String languageCode) async {
    if (!await isActivated()) return;
    final token = await _messaging.getToken();
    if (token == null || token.isEmpty) return;
    try {
      await _tokenRepository.registerPushToken(
        token: token,
        platform: PushTokenRepository.platformLabel(),
        preferredLocale: languageCode,
      );
    } catch (e, st) {
      debugPrint('[TarciPush] sync locale failed: $e\n$st');
    }
  }
}
