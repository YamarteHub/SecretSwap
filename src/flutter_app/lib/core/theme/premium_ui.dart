import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'app_theme.dart';

/// Variantes del logo. Cada variante apunta a dos archivos reales declarados
/// en `pubspec.yaml` y copiados dentro de `assets/brand/`:
///   - una variante `_Transparent.png` (recomendada, fondo eliminado),
///   - la variante original con fondo crema/blanco como fallback.
///
/// IMPORTANTE: los assets viven dentro del proyecto Flutter (no en
/// `../../imagenes/`) porque Flutter no soporta de forma fiable rutas
/// fuera del directorio del paquete y los archivos no se empaquetaban
/// en el APK.
///
/// Las variantes transparentes se generan en `scripts/make_brand_transparent.py`
/// con un color-key automático sobre los PNG opacos. Si en el futuro se
/// reciben PNG transparentes nativos desde diseño, basta con sobrescribir
/// los archivos `*_Transparent.png` manteniendo el mismo nombre.
enum BrandAsset {
  /// Icono cuadrado, ideal para insignias compactas (avatar header, badge).
  icon,

  /// Wordmark vertical: logo + nombre apilados. Protagonista en splash y dashboard.
  vertical,

  /// Wordmark horizontal: logo + nombre en línea. Útil en headers compactos.
  horizontal,

  /// Variante principal alternativa.
  principal,
}

// Rutas preferidas (PNG con fondo eliminado, integrables sobre cualquier
// degradado o card cálido).
const String _kAssetIconTransparent =
    'assets/brand/TarciSecret_Icono_Transparent.png';
const String _kAssetVerticalTransparent =
    'assets/brand/TarciSecret_Vertical_Transparent.png';
const String _kAssetHorizontalTransparent =
    'assets/brand/TarciSecret_Horizontal_Transparent.png';
const String _kAssetPrincipalTransparent =
    'assets/brand/TarciSecret_Principal_Transparent.png';

// Rutas opacas originales (fallback si la transparente no carga).
const String _kAssetIconOpaque = 'assets/brand/TarciSecret_Icono.png';
const String _kAssetVerticalOpaque = 'assets/brand/TarciSecret_Vertical.png';
const String _kAssetHorizontalOpaque =
    'assets/brand/TarciSecret_Horizontal.png';
const String _kAssetPrincipalOpaque =
    'assets/brand/TarciSecret_Principal.png';

String _assetPathTransparent(BrandAsset asset) {
  switch (asset) {
    case BrandAsset.icon:
      return _kAssetIconTransparent;
    case BrandAsset.vertical:
      return _kAssetVerticalTransparent;
    case BrandAsset.horizontal:
      return _kAssetHorizontalTransparent;
    case BrandAsset.principal:
      return _kAssetPrincipalTransparent;
  }
}

String _assetPathOpaque(BrandAsset asset) {
  switch (asset) {
    case BrandAsset.icon:
      return _kAssetIconOpaque;
    case BrandAsset.vertical:
      return _kAssetVerticalOpaque;
    case BrandAsset.horizontal:
      return _kAssetHorizontalOpaque;
    case BrandAsset.principal:
      return _kAssetPrincipalOpaque;
  }
}

/// Representación visual de la marca Tarci Secret.
///
/// Reglas:
/// - `BrandAsset.icon`: insignias compactas (AppBar, avatar de header).
/// - `BrandAsset.vertical` / `principal`: logo protagonista (splash, hero).
/// - `BrandAsset.horizontal`: header compacto en línea.
///
/// Por defecto carga la variante transparente (sin caja ni recorte
/// rectangular). Si la transparente no estuviese disponible, cae a la
/// variante opaca; si tampoco existe, en debug muestra un mensaje rojo
/// visible y en release una insignia neutra cálida sin icono genérico.
///
/// `rounded` está en `false` por defecto: con assets transparentes no se
/// recortan esquinas. Solo el icono cuadrado puede activar `rounded: true`
/// si se quiere encerrar en una insignia.
class BrandMark extends StatelessWidget {
  final BrandAsset variant;
  final double height;
  final double? width;
  final bool rounded;

  const BrandMark({
    super.key,
    this.variant = BrandAsset.icon,
    this.height = 44,
    this.width,
    this.rounded = false,
  });

  @override
  Widget build(BuildContext context) {
    final transparentPath = _assetPathTransparent(variant);
    final opaquePath = _assetPathOpaque(variant);
    final radius = rounded
        ? BorderRadius.circular(variant == BrandAsset.icon ? 16 : 10)
        : BorderRadius.zero;

    final image = Image.asset(
      transparentPath,
      height: height,
      width: width,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.medium,
      errorBuilder: (_, error, __) {
        debugPrint(
          '[TarciSecret] BrandMark fallo cargando transparente '
          '"$transparentPath": $error. Probando opaco...',
        );
        return Image.asset(
          opaquePath,
          height: height,
          width: width,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.medium,
          errorBuilder: (_, opaqueError, __) {
            debugPrint(
              '[TarciSecret] BrandMark fallo cargando opaco '
              '"$opaquePath": $opaqueError',
            );
            return _BrandFallback(
              height: height,
              width: width,
              rounded: rounded,
              assetPath: '$transparentPath / $opaquePath',
            );
          },
        );
      },
    );
    if (!rounded) return image;
    return ClipRRect(borderRadius: radius, child: image);
  }
}

class _BrandFallback extends StatelessWidget {
  const _BrandFallback({
    required this.height,
    required this.width,
    required this.rounded,
    required this.assetPath,
  });

  final double height;
  final double? width;
  final bool rounded;
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (kDebugMode) {
      return Container(
        height: height,
        width: width ?? height * 1.6,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.softCoral.withValues(alpha: 0.18),
          border: Border.all(color: AppTheme.softCoral),
          borderRadius: rounded ? BorderRadius.circular(12) : null,
        ),
        alignment: Alignment.center,
        child: Text(
          'Asset Tarci no encontrado:\n$assetPath',
          textAlign: TextAlign.center,
          style: theme.textTheme.labelSmall?.copyWith(
            color: AppTheme.softCoral,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }
    return Container(
      height: height,
      width: width ?? height,
      decoration: BoxDecoration(
        gradient: AppTheme.brandHeroGradient,
        borderRadius: rounded ? BorderRadius.circular(16) : null,
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.18),
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        'TS',
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w800,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}

/// Hero de marca con fondo cálido degradado para el dashboard. El logo se
/// dibuja sobre el mismo gradiente del card (sin caja blanca ni recorte
/// rectangular) gracias a la variante transparente declarada en `BrandMark`.
class BrandHero extends StatelessWidget {
  final String tagline;
  /// Título corto bajo el logo (opcional) para jerarquía en dashboard.
  final String? headline;
  final VoidCallback? onSecretTap;
  final VoidCallback? onSecretLongPress;

  const BrandHero({
    super.key,
    required this.tagline,
    this.headline,
    this.onSecretTap,
    this.onSecretLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 26, 20, 22),
      decoration: BoxDecoration(
        gradient: AppTheme.brandHeroGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppTheme.softElevatedShadow,
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.10),
        ),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: onSecretTap,
            onLongPress: onSecretLongPress,
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              width: 200,
              height: 150,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  IgnorePointer(
                    child: Container(
                      width: 180,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppTheme.mutedGold.withValues(alpha: 0.18),
                            AppTheme.mutedGold.withValues(alpha: 0.04),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.55, 1.0],
                        ),
                      ),
                    ),
                  ),
                  const BrandMark(
                    variant: BrandAsset.vertical,
                    height: 130,
                    rounded: false,
                  ),
                ],
              ),
            ),
          ),
          if (headline != null && headline!.trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              headline!,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                height: 1.25,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 8),
          ] else
            const SizedBox(height: 14),
          Text(
            tagline,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.78),
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

/// Header limpio para pantallas de detalle/secundarias.
class PremiumHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? trailing;
  final bool showBrand;

  const PremiumHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.showBrand = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (showBrand) ...[
          const BrandMark(variant: BrandAsset.icon, height: 44),
          const SizedBox(width: 14),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
        if (trailing != null) ...[const SizedBox(width: 8), trailing!],
      ],
    );
  }
}

class SectionCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool highlighted;
  final Color? backgroundColor;

  const SectionCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.highlighted = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg =
        backgroundColor ??
        (highlighted ? const Color(0xFFFBF1EB) : AppTheme.softCream);
    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: highlighted
              ? AppTheme.softTerracotta.withValues(alpha: 0.22)
              : theme.colorScheme.outlineVariant,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 14,
            spreadRadius: -8,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

/// Card de bloque protagonista (estado de grupo, asignación). Mantiene la
/// estética cálida-premium con un suave gradiente.
class SecretCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const SecretCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        gradient: AppTheme.secretCardGradient,
        borderRadius: BorderRadius.circular(22),
        boxShadow: AppTheme.softElevatedShadow,
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.20),
        ),
      ),
      child: child,
    );
  }
}

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final Widget? action;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, size: 24, color: theme.colorScheme.primary),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          if (action != null) ...[const SizedBox(height: 14), action!],
        ],
      ),
    );
  }
}

class PersonTile extends StatelessWidget {
  final String name;
  final String roleLabel;
  final String? subgroupName;
  final String subgroupPrefix;
  final String noSubgroupLabel;
  final bool canEdit;
  final VoidCallback? onTap;

  const PersonTile({
    super.key,
    required this.name,
    required this.roleLabel,
    required this.subgroupName,
    this.subgroupPrefix = 'Subgrupo',
    this.noSubgroupLabel = 'Sin subgrupo asignado',
    this.canEdit = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasSubgroup = subgroupName != null;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppTheme.softCream,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppTheme.deepPlum.withValues(alpha: 0.10),
                  child: Text(
                    _initial(name),
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: AppTheme.deepPlum,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          _miniChip(
                            theme,
                            roleLabel,
                            color: AppTheme.deepPlumAlt,
                          ),
                          _miniChip(
                            theme,
                            hasSubgroup
                                ? '$subgroupPrefix · $subgroupName'
                                : noSubgroupLabel,
                            color: hasSubgroup
                                ? AppTheme.sageGreen
                                : AppTheme.softTerracotta,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (canEdit) ...[
                  const SizedBox(width: 4),
                  Icon(
                    Icons.edit_outlined,
                    size: 18,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _initial(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '·';
    return trimmed.characters.first.toUpperCase();
  }

  static Widget _miniChip(ThemeData theme, String text, {required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.30)),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class GuardianTile extends StatelessWidget {
  final String name;
  final String personTypeLabel;
  final String responsibilityLine;
  final String? subgroupName;
  final String subgroupPrefix;
  final String noSubgroupLabel;
  final String privateResultLabel;
  final Widget? trailing;

  const GuardianTile({
    super.key,
    required this.name,
    required this.personTypeLabel,
    required this.responsibilityLine,
    required this.subgroupName,
    this.subgroupPrefix = 'Subgrupo',
    this.noSubgroupLabel = 'Sin subgrupo asignado',
    this.privateResultLabel = 'Resultado privado',
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasSubgroup = subgroupName != null;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
      decoration: BoxDecoration(
        color: AppTheme.softCream,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppTheme.mutedGold.withValues(alpha: 0.18),
            child: const Icon(
              Icons.shield_moon_outlined,
              color: AppTheme.deepPlum,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$personTypeLabel · $responsibilityLine',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    PersonTile._miniChip(
                      theme,
                      hasSubgroup
                          ? '$subgroupPrefix · $subgroupName'
                          : noSubgroupLabel,
                      color: hasSubgroup
                          ? AppTheme.sageGreen
                          : AppTheme.softTerracotta,
                    ),
                    PersonTile._miniChip(
                      theme,
                      privateResultLabel,
                      color: AppTheme.deepPlumAlt,
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class WarningBox extends StatelessWidget {
  final String message;

  const WarningBox({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.softCoral.withValues(alpha: 0.10),
        border: Border.all(
          color: AppTheme.softTerracotta.withValues(alpha: 0.35),
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppTheme.softTerracotta,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StatusChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? color;

  const StatusChip({super.key, required this.label, this.icon, this.color});

  @override
  Widget build(BuildContext context) {
    final tone = color ?? Theme.of(context).colorScheme.secondary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: tone.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: tone.withValues(alpha: 0.32)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 15, color: tone),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: tone,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Diálogo premium reutilizable. Estructura: ícono cálido + título humano +
/// contenido + acción primaria dominante + acción secundaria discreta.
/// Asegura aire visual y botones nunca apilados/comprimidos.
class PremiumDialog extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? content;
  final String primaryLabel;
  final VoidCallback? onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final bool primaryLoading;

  const PremiumDialog({
    super.key,
    required this.icon,
    required this.title,
    required this.primaryLabel,
    required this.onPrimary,
    this.subtitle,
    this.content,
    this.secondaryLabel,
    this.onSecondary,
    this.primaryLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: AppTheme.softCream,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: AppTheme.brandHeroGradient,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      icon,
                      color: AppTheme.deepPlum,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 10),
                Text(
                  subtitle!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
              if (content != null) ...[
                const SizedBox(height: 18),
                content!,
              ],
              const SizedBox(height: 22),
              FilledButton(
                onPressed: primaryLoading ? null : onPrimary,
                child: primaryLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(primaryLabel),
              ),
              if (secondaryLabel != null) ...[
                const SizedBox(height: 10),
                TextButton(
                  onPressed: onSecondary,
                  child: Text(secondaryLabel!),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
