import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/premium_ui.dart';
import '../../domain/draw_models.dart';
import '../providers.dart';

/// Pantalla "Secretos que gestionas".
///
/// Aquí el organizador (o el responsable) ve los resultados de las personas
/// que dependen de él (niños y adultos sin app). La intención visual es
/// **responsabilidad privada**, no reporte administrativo:
///
///   - Fondo `warmIvory` y AppBar limpio con `BrandMark.icon`.
///   - Hero textual cálido que enmarca la responsabilidad ("Tú entregas
///     estos resultados en privado, sin que nadie más se entere.").
///   - Cada gestionado se presenta como una `_GuardianAssignmentCard`:
///     header con avatar de inicial, nombre del giver y badge de tipo
///     (niño / sin app), label sobrio "Su amigo secreto es", nombre del
///     receptor protagonista, y dos chips finales (subgrupo + entrega).
///   - Reminder de privacidad consolidado en el footer (antes aparecía
///     repetido en cada card; ahora una vez al final, más sobrio).
///
/// Responde en menos de 3 segundos: "¿Qué secretos debo gestionar yo?"
class ManagedAssignmentsScreen extends ConsumerWidget {
  final String groupId;
  final String executionId;

  const ManagedAssignmentsScreen({
    super.key,
    required this.groupId,
    required this.executionId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final future =
        ref.watch(_managedAssignmentsProvider((groupId, executionId)));
    return Scaffold(
      backgroundColor: AppTheme.warmIvory,
      appBar: AppBar(
        backgroundColor: AppTheme.warmIvory,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(l10n.managedSecrets),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Center(
              child: BrandMark(variant: BrandAsset.icon, height: 32),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: future.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 80),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            child: EmptyState(
              icon: Icons.lock_person_outlined,
              title: l10n.managedLoadErrorTitle,
              message: l10n.managedLoadErrorMessage,
            ),
          ),
          data: (items) => ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            children: [
              _ManagedHero(
                title: l10n.managedHeroTitle,
                subtitle: l10n.managedHeroSubtitle,
              ),
              const SizedBox(height: 18),
              if (items.isEmpty)
                EmptyState(
                  icon: Icons.inbox_outlined,
                  title: l10n.managedEmptyTitle,
                  message: l10n.managedEmptyMessage,
                )
              else ...[
                ...items.map(
                  (a) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _GuardianAssignmentCard(assignment: a),
                  ),
                ),
                const SizedBox(height: 6),
                _PrivacyFooterNote(text: l10n.managedFooterPrivacyNote),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Hero cálido para la pantalla. Reemplaza el `PremiumHeader` genérico
/// con un bloque más emocional centrado en la responsabilidad privada.
class _ManagedHero extends StatelessWidget {
  const _ManagedHero({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
      decoration: BoxDecoration(
        gradient: AppTheme.brandHeroGradient,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppTheme.deepPlum.withValues(alpha: 0.10),
        ),
        boxShadow: AppTheme.softElevatedShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.deepPlum.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.shield_moon_outlined,
                  color: AppTheme.deepPlum,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color:
                  theme.colorScheme.onSurface.withValues(alpha: 0.78),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

/// Tarjeta de asignación gestionada. Diseñada como ficha privada con
/// jerarquía clara y sin textos repetidos:
///
///   1. Header: avatar circular con la inicial + nombre del giver + badge
///      del tipo (niño / sin app).
///   2. Línea separadora suave.
///   3. Label sobrio "Su amigo secreto es".
///   4. Nombre del receiver protagonista (`headlineSmall`).
///   5. Chips finales: subgrupo (si aplica) + forma de entrega.
class _GuardianAssignmentCard extends StatelessWidget {
  const _GuardianAssignmentCard({required this.assignment});

  final ManagedAssignment assignment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final subName = assignment.receiverSubgroupName?.trim();
    final hasSubgroup = subName != null && subName.isNotEmpty;
    return SecretCard(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _InitialAvatar(name: assignment.giverDisplayName),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      assignment.giverDisplayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _TypeBadge(label: _giverTypeLabel(context, assignment.giverType)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(
            color: theme.colorScheme.outlineVariant,
            height: 1,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: AppTheme.mutedGold.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(
                  Icons.redeem_outlined,
                  size: 16,
                  color: AppTheme.mutedGold,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                l10n.managedRevealLabel,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurface
                      .withValues(alpha: 0.78),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            assignment.receiverDisplayName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              height: 1.1,
              color: AppTheme.deepPlum,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (hasSubgroup)
                _ChipPill(
                  icon: Icons.scatter_plot_outlined,
                  label: subName,
                ),
              _ChipPill(
                icon: _deliveryIcon(assignment.deliveryMode),
                label:
                    '${l10n.managedDeliveryChipLabel} · ${_deliveryModeLabel(context, assignment.deliveryMode)}',
                tone: AppTheme.deepPlum,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Avatar circular discreto con inicial del nombre. Aporta calidez sin
/// invadir el mensaje principal (que es el receptor, no el giver).
class _InitialAvatar extends StatelessWidget {
  const _InitialAvatar({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initial = _firstInitial(name);
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        gradient: AppTheme.brandHeroGradient,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppTheme.deepPlum.withValues(alpha: 0.18),
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w800,
          color: AppTheme.deepPlum,
        ),
      ),
    );
  }

  static String _firstInitial(String s) {
    final t = s.trim();
    if (t.isEmpty) return '·';
    final ch = t.runes.first;
    return String.fromCharCode(ch).toUpperCase();
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppTheme.warmIvory,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

/// Chip pequeño con icono. Soporta un tono opcional para diferenciar
/// el chip principal (entrega) del secundario (subgrupo).
class _ChipPill extends StatelessWidget {
  const _ChipPill({
    required this.icon,
    required this.label,
    this.tone,
  });

  final IconData icon;
  final String label;
  final Color? tone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = tone ?? theme.colorScheme.onSurfaceVariant;
    final bg = tone != null
        ? tone!.withValues(alpha: 0.10)
        : AppTheme.softCream;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: tone != null
              ? tone!.withValues(alpha: 0.30)
              : theme.colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: accent),
          const SizedBox(width: 6),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 220),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium?.copyWith(
                color: accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Footer de privacidad. Aparece **una sola vez al final del listado**,
/// no por cada card, para evitar la sensación de reporte repetitivo.
class _PrivacyFooterNote extends StatelessWidget {
  const _PrivacyFooterNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lock_outline,
            size: 14,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _giverTypeLabel(BuildContext context, String raw) {
  switch (raw) {
    case 'child_managed':
      return context.l10n.groupTypeChildManaged;
    case 'managed':
      return context.l10n.groupTypeAdultNoApp;
    default:
      return context.l10n.managedTypeManagedParticipant;
  }
}

String _deliveryModeLabel(BuildContext context, String raw) {
  switch (raw) {
    case 'verbal':
      return context.l10n.groupManagedDialogDeliveryVerbal;
    case 'printed':
      return context.l10n.groupManagedDialogDeliveryPrinted;
    case 'ownerDelegated':
      return context.l10n.managedDeliveryOwnerDelegated;
    default:
      return raw;
  }
}

IconData _deliveryIcon(String raw) {
  switch (raw) {
    case 'printed':
      return Icons.print_outlined;
    case 'ownerDelegated':
      return Icons.shield_outlined;
    case 'verbal':
    default:
      return Icons.record_voice_over_outlined;
  }
}

final _managedAssignmentsProvider =
    FutureProvider.family.autoDispose((ref, (String, String) key) async {
  final (groupId, executionId) = key;
  return ref.read(drawRepositoryProvider).getManagedAssignments(
        groupId: groupId,
        executionId: executionId,
      );
});
