import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../domain/push_notifications_service.dart';

final pushNotificationsServiceProvider = Provider<PushNotificationsService>((ref) {
  return PushNotificationsService(navigatorKey: rootNavigatorKey);
});

final pushActivationVisibleProvider = FutureProvider.autoDispose<bool>((ref) async {
  final service = ref.watch(pushNotificationsServiceProvider);
  if (await service.isActivated()) return false;
  if (await service.isPromoDismissed()) return false;
  return true;
});
