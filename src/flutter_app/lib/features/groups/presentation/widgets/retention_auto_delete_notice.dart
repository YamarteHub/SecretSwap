import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/premium_ui.dart';

/// Aviso discreto de eliminación automática tras retención limitada (Fase 12).
class RetentionAutoDeleteNotice extends StatelessWidget {
  const RetentionAutoDeleteNotice({
    super.key,
    required this.retentionDeleteAt,
  });

  final DateTime retentionDeleteAt;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final loc = Localizations.localeOf(context).toString();
    final formatted = DateFormat.yMMMMd(loc).format(retentionDeleteAt);

    return SecretCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.schedule_outlined,
            size: 22,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.85),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.retentionAutoDeleteNotice(formatted),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.retentionAutoDeleteBody,
                  style: theme.textTheme.bodySmall?.copyWith(
                    height: 1.38,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Inserta el aviso si hay fecha de retención calculada en el servidor.
class RetentionAutoDeleteNoticeSlot extends StatelessWidget {
  const RetentionAutoDeleteNoticeSlot({
    super.key,
    required this.retentionDeleteAt,
  });

  final DateTime? retentionDeleteAt;

  @override
  Widget build(BuildContext context) {
    final at = retentionDeleteAt;
    if (at == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: RetentionAutoDeleteNotice(retentionDeleteAt: at),
    );
  }
}
