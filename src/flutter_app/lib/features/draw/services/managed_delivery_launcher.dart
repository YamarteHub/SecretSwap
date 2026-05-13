import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// Abre WhatsApp, cliente de correo o comparte texto sin exponer datos en backend.
class ManagedDeliveryLauncher {
  ManagedDeliveryLauncher._();

  /// Intenta abrir `wa.me` con el texto; si falla, usa el sheet nativo de compartir.
  static Future<void> shareWhatsAppOrFallback(String text) async {
    final uri = Uri.parse(
      'https://wa.me/?text=${Uri.encodeComponent(text)}',
    );
    try {
      if (await canLaunchUrl(uri)) {
        final ok = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        if (ok) return;
      }
    } catch (_) {
      // Fallback below
    }
    await Share.share(text);
  }

  static Future<bool> openEmailComposer({
    required String subject,
    required String body,
  }) async {
    final mailto = Uri.parse(
      'mailto:?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}',
    );
    try {
      if (await canLaunchUrl(mailto)) {
        var ok = await launchUrl(mailto, mode: LaunchMode.platformDefault);
        if (ok) return true;
        // Algunos OEMs responden mejor con modo explícito fuera de la app.
        ok = await launchUrl(mailto, mode: LaunchMode.externalApplication);
        if (ok) return true;
      }
    } catch (e) {
      debugPrint('mailto launch failed: $e');
    }
    if (kIsWeb) {
      try {
        return launchUrl(mailto, webOnlyWindowName: '_blank');
      } catch (_) {
        return false;
      }
    }
    return false;
  }
}
