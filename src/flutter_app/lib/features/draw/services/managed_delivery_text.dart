import '../../../l10n/app_localizations.dart';

/// Textos localizados para compartir resultados de participantes gestionados.
class ManagedDeliveryText {
  ManagedDeliveryText._();

  static String whatsappBody(
    AppLocalizations l10n, {
    required String managedName,
    required String groupName,
    required String receiverName,
    String? receiverSubgroupName,
  }) {
    final buf = StringBuffer();
    buf.writeln(l10n.managedDeliveryWhatsappBrand);
    buf.writeln();
    buf.writeln(l10n.managedDeliveryWhatsappHello(managedName));
    buf.writeln(l10n.managedDeliveryWhatsappDrawLine(groupName));
    buf.writeln();
    buf.writeln(l10n.managedDeliveryWhatsappGiftIntro);
    buf.writeln(l10n.managedDeliveryWhatsappReceiverLine(receiverName));
    final sub = receiverSubgroupName?.trim();
    if (sub != null && sub.isNotEmpty) {
      buf.writeln();
      buf.writeln(l10n.managedDeliverySubgroupBelongsTo(sub));
    }
    buf.writeln();
    buf.writeln(l10n.managedDeliveryClosingSecret);
    return buf.toString();
  }

  static String emailSubject(AppLocalizations l10n, String groupName) =>
      l10n.managedDeliveryEmailSubject(groupName);

  static String emailBody(
    AppLocalizations l10n, {
    required String managedName,
    required String groupName,
    required String receiverName,
    String? receiverSubgroupName,
  }) {
    final buf = StringBuffer();
    buf.writeln(l10n.managedDeliveryEmailGreeting(managedName));
    buf.writeln();
    buf.writeln(l10n.managedDeliveryEmailLead(groupName));
    buf.writeln();
    buf.writeln(l10n.managedDeliveryEmailGiftLabel);
    buf.writeln(l10n.managedDeliveryEmailReceiverLine(receiverName));
    final sub = receiverSubgroupName?.trim();
    if (sub != null && sub.isNotEmpty) {
      buf.writeln();
      buf.writeln(l10n.managedDeliveryEmailSubgroupLine(sub));
    }
    buf.writeln();
    buf.writeln(l10n.managedDeliveryEmailClosing);
    buf.writeln();
    buf.writeln(l10n.managedDeliveryEmailSignoff);
    return buf.toString();
  }
}
