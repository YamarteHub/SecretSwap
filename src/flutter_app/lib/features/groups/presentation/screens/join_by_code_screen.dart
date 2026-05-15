import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/messaging/functions_user_message.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/premium_ui.dart';
import '../../domain/group_models.dart';
import '../../../teams/presentation/teams_ui_copy.dart';
import '../providers.dart';

/// Pantalla "Unirme con código".
///
/// UX premium pensada para invitados que no usan la app a diario:
///   - Fondo cálido (`warmIvory`) y AppBar limpio con `BrandMark.icon`.
///   - Hero textual breve que responde "dónde estoy" en menos de 3 segundos.
///   - `SectionCard` con dos únicos campos: código y nombre.
///   - El código se uppercase visualmente con un `TextInputFormatter`; los
///     espacios pegados desde portapapeles se eliminan al validar.
///   - El nombre se valida con un mínimo razonable y mensaje humano.
///   - Tras unirse, se muestra `_JoinSuccessDialog` (PremiumDialog) con:
///       * Caso normal: el invitado escoge subgrupo/casa con copy cálido.
///       * Caso sin subgrupos: mensaje amable, sin sensación de error.
///
/// LIMITACIÓN ACTUAL — preview pre-join:
/// El contrato `joinGroupByCode` solo retorna `groupId` (ver
/// `groups_repository_impl.dart`). No existe un endpoint que permita
/// previsualizar el grupo *antes* de unirse, así que mostramos el preview
/// (nombre real del grupo) en el modal *posterior* al join, usando el
/// `GroupDetail` ya disponible. No se inventa endpoint.
class JoinByCodeScreen extends ConsumerStatefulWidget {
  const JoinByCodeScreen({super.key});

  @override
  ConsumerState<JoinByCodeScreen> createState() => _JoinByCodeScreenState();
}

class _JoinByCodeScreenState extends ConsumerState<JoinByCodeScreen> {
  final _codeCtrl = TextEditingController();
  final _nickCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _loading = false;

  /// Longitud mínima razonable para considerar un código "completo".
  /// El backend valida la unicidad real; este umbral solo evita lanzar
  /// la llamada cuando el usuario claramente aún no terminó de pegar.
  static const int _minCodeLength = 4;
  static const int _minNicknameLength = 3;

  @override
  void initState() {
    super.initState();
    // Pre-relleno cálido: si el usuario ya tiene un displayName en su cuenta,
    // lo usamos. En modo anónimo / quick mode no habrá nada y el campo queda
    // vacío con su helper visible. Eliminamos el antiguo default literal
    // "Miembro" que se mostraba como si fuera el nombre del usuario.
    final auth = FirebaseAuth.instance.currentUser;
    final displayName = auth?.displayName?.trim();
    if (displayName != null && displayName.isNotEmpty) {
      _nickCtrl.text = displayName;
    }
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _nickCtrl.dispose();
    super.dispose();
  }

  /// Limpia el código de espacios y normaliza a mayúsculas.
  /// El backend ya hace `code.trim()` (ver repository), así que aquí
  /// nos limitamos a saneado defensivo y consistente con el visual.
  String _sanitizedCode() {
    return _codeCtrl.text.replaceAll(RegExp(r'\s+'), '').toUpperCase();
  }

  String? _validateCode(String? raw) {
    final l10n = context.l10n;
    final code = (raw ?? '').replaceAll(RegExp(r'\s+'), '');
    if (code.isEmpty) return l10n.joinScreenCodeRequired;
    if (code.length < _minCodeLength) return l10n.joinScreenCodeTooShort;
    return null;
  }

  String? _validateNickname(String? raw) {
    final l10n = context.l10n;
    final nick = (raw ?? '').trim();
    if (nick.isEmpty) return l10n.joinScreenNicknameRequired;
    if (nick.length < _minNicknameLength) return l10n.joinScreenNicknameTooShort;
    return null;
  }

  Future<void> _submit() async {
    if (_loading) return;
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    final code = _sanitizedCode();
    final nick = _nickCtrl.text.trim();

    setState(() => _loading = true);
    try {
      final repo = ref.read(groupsRepositoryProvider);
      final groupId = await repo.joinGroupByCode(
        code: code,
        nickname: nick,
      );
      if (!mounted) return;
      ref.invalidate(myGroupsProvider);

      final detail = await repo.getGroupDetail(groupId);
      if (!mounted) return;

      // Modal de éxito post-join. El usuario decide si elige subgrupo
      // (cuando aplica) y luego confirma el paso al detalle del grupo.
      final result = await showDialog<_JoinSuccessResult>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => _JoinSuccessDialog(detail: detail),
      );
      if (!mounted) return;

      if (result == null) {
        // El usuario cerró el diálogo sin confirmar (botón secundario).
        // Igualmente le invalidamos los grupos y le dejamos esta screen
        // para que pueda volver atrás manualmente.
        return;
      }

      final selectedSubgroupId = result.subgroupId;
      if (detail.dynamicType != TarciDynamicType.simpleRaffle &&
          detail.dynamicType != TarciDynamicType.teams &&
          selectedSubgroupId != null) {
        final uid = FirebaseAuth.instance.currentUser?.uid;
        if (uid != null && uid.isNotEmpty) {
          await repo.setMemberSubgroup(
            groupId: groupId,
            memberUid: uid,
            subgroupId: selectedSubgroupId,
          );
        }
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.joinScreenSuccessSnackbar)),
      );
      context.go(AppRoutes.groupDetail.replaceFirst(':groupId', groupId));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(userVisibleActionErrorMessage(e, context.l10n))),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: AppTheme.warmIvory,
      appBar: AppBar(
        backgroundColor: AppTheme.warmIvory,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(l10n.joinScreenTitle),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ─── Hero textual ────────────────────────────────────────
                Container(
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
                              Icons.mail_outline_rounded,
                              color: AppTheme.deepPlum,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              l10n.joinScreenHeroTitle,
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
                        l10n.joinScreenHeroSubtitle,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.78),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                // ─── Card de campos ──────────────────────────────────────
                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _codeCtrl,
                        textCapitalization: TextCapitalization.characters,
                        textInputAction: TextInputAction.next,
                        autofocus: true,
                        // Force visual uppercase + bloquea espacios.
                        inputFormatters: [
                          _UpperCaseNoSpaceFormatter(),
                          LengthLimitingTextInputFormatter(20),
                        ],
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                        ),
                        decoration: InputDecoration(
                          labelText: l10n.joinScreenCodeLabel,
                          hintText: l10n.joinScreenCodeHint,
                          helperText: l10n.joinScreenCodeHelper,
                          helperMaxLines: 2,
                          prefixIcon: const Icon(Icons.vpn_key_outlined),
                        ),
                        validator: _validateCode,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _nickCtrl,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _submit(),
                        decoration: InputDecoration(
                          labelText: l10n.joinScreenNicknameLabel,
                          helperText: l10n.joinScreenNicknameHelper,
                          helperMaxLines: 2,
                          prefixIcon: const Icon(Icons.person_outline),
                        ),
                        validator: _validateNickname,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                // ─── CTA principal ───────────────────────────────────────
                FilledButton.icon(
                  onPressed: _loading ? null : _submit,
                  icon: _loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.login_rounded),
                  label: Text(
                    _loading
                        ? l10n.joinScreenCtaLoading
                        : l10n.joinScreenCta,
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: _loading ? null : () => context.pop(),
                  child: Text(context.l10n.back),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// `TextInputFormatter` que fuerza mayúsculas y elimina espacios al vuelo.
/// Permite pegar códigos en cualquier formato (con espacios, con minúsculas)
/// y deja al usuario un visual limpio sin tener que tocar nada.
class _UpperCaseNoSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final cleaned =
        newValue.text.replaceAll(RegExp(r'\s+'), '').toUpperCase();
    if (cleaned == newValue.text) return newValue;
    return TextEditingValue(
      text: cleaned,
      selection: TextSelection.collapsed(offset: cleaned.length),
    );
  }
}

/// Resultado del modal de éxito tras unirse al grupo.
class _JoinSuccessResult {
  const _JoinSuccessResult({this.subgroupId});

  /// Subgrupo elegido por el invitado (si aplica). `null` cuando el grupo
  /// todavía no tiene subgrupos creados o cuando no se requiere elegir.
  final String? subgroupId;
}

/// Modal de éxito post-join. Usa `PremiumDialog` para coherencia con el
/// resto de la app (mismo lenguaje visual que los modales del detalle).
///
/// Comportamiento por caso:
///   - Si `detail.subgroups` tiene elementos → fuerza al usuario a elegir
///     uno antes de confirmar (CTA principal deshabilitado hasta selección).
///   - Si está vacío → muestra mensaje amable explicando que el organizador
///     todavía no las creó y permite continuar igualmente.
///
/// El usuario también puede pulsar el CTA secundario "Quedarme aquí" para
/// no navegar inmediatamente al detalle (caso poco común pero permitido).
class _JoinSuccessDialog extends StatefulWidget {
  const _JoinSuccessDialog({required this.detail});

  final GroupDetail detail;

  @override
  State<_JoinSuccessDialog> createState() => _JoinSuccessDialogState();
}

class _JoinSuccessDialogState extends State<_JoinSuccessDialog> {
  String? _selectedSubgroupId;
  bool _showSelectionError = false;

  @override
  Widget build(BuildContext context) {
    if (widget.detail.dynamicType == TarciDynamicType.simpleRaffle) {
      return _buildRaffleSuccessDialog(context);
    }
    if (widget.detail.dynamicType == TarciDynamicType.teams) {
      if (widget.detail.teamsPreset == TeamsPreset.duels) {
        return _buildDuelsSuccessDialog(context);
      }
      if (widget.detail.teamsPreset == TeamsPreset.pairings) {
        return _buildPairingsSuccessDialog(context);
      }
      return _buildTeamsSuccessDialog(context);
    }
    return _buildSecretSantaSuccessDialog(context);
  }

  Widget _buildDuelsSuccessDialog(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final ui = TeamsUiCopy.of(l10n, TeamsPreset.duels);

    return PremiumDialog(
      icon: Icons.celebration_outlined,
      title: l10n.joinSuccessTitle,
      subtitle: ui.joinSuccessSubtitle(widget.detail.name),
      content: Text(
        ui.joinSuccessBody,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          height: 1.45,
        ),
      ),
      primaryLabel: ui.joinSuccessPrimaryCta,
      onPrimary: () => Navigator.pop(context, const _JoinSuccessResult()),
      secondaryLabel: l10n.joinSuccessSecondaryCta,
      onSecondary: () => Navigator.pop(context),
    );
  }

  Widget _buildPairingsSuccessDialog(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final ui = TeamsUiCopy.of(l10n, TeamsPreset.pairings);

    return PremiumDialog(
      icon: Icons.celebration_outlined,
      title: l10n.joinSuccessTitle,
      subtitle: ui.joinSuccessSubtitle(widget.detail.name),
      content: Text(
        ui.joinSuccessBody,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          height: 1.45,
        ),
      ),
      primaryLabel: ui.joinSuccessPrimaryCta,
      onPrimary: () => Navigator.pop(context, const _JoinSuccessResult()),
      secondaryLabel: l10n.joinSuccessSecondaryCta,
      onSecondary: () => Navigator.pop(context),
    );
  }

  Widget _buildTeamsSuccessDialog(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return PremiumDialog(
      icon: Icons.celebration_outlined,
      title: l10n.joinSuccessTitle,
      subtitle: l10n.joinSuccessTeamsSubtitle(widget.detail.name),
      content: Text(
        l10n.joinSuccessTeamsBody,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          height: 1.45,
        ),
      ),
      primaryLabel: l10n.joinSuccessTeamsPrimaryCta,
      onPrimary: () => Navigator.pop(context, const _JoinSuccessResult()),
      secondaryLabel: l10n.joinSuccessSecondaryCta,
      onSecondary: () => Navigator.pop(context),
    );
  }

  Widget _buildRaffleSuccessDialog(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return PremiumDialog(
      icon: Icons.celebration_outlined,
      title: l10n.joinSuccessTitle,
      subtitle: l10n.joinSuccessRaffleSubtitle(widget.detail.name),
      content: Text(
        l10n.joinSuccessRaffleBody,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          height: 1.45,
        ),
      ),
      primaryLabel: l10n.joinSuccessRafflePrimaryCta,
      onPrimary: () => Navigator.pop(context, const _JoinSuccessResult()),
      secondaryLabel: l10n.joinSuccessSecondaryCta,
      onSecondary: () => Navigator.pop(context),
    );
  }

  Widget _buildSecretSantaSuccessDialog(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final subgroups = widget.detail.subgroups;
    final hasSubgroups = subgroups.isNotEmpty;

    return PremiumDialog(
      icon: Icons.celebration_outlined,
      title: l10n.joinSuccessTitle,
      subtitle: l10n.joinSuccessSubtitle(widget.detail.name),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasSubgroups) ...[
            Text(
              l10n.joinSuccessChooseSubgroupTitle,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.joinSuccessChooseSubgroupHelp,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: AppTheme.warmIvory,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _showSelectionError && _selectedSubgroupId == null
                      ? AppTheme.softCoral.withValues(alpha: 0.5)
                      : theme.colorScheme.outlineVariant,
                ),
              ),
              child: DropdownButtonFormField<String>(
                value: _selectedSubgroupId,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: l10n.joinSuccessSubgroupLabel,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  contentPadding: EdgeInsets.zero,
                ),
                items: subgroups
                    .map(
                      (s) => DropdownMenuItem<String>(
                        value: s.subgroupId,
                        child: Text(s.name),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() {
                  _selectedSubgroupId = v;
                  _showSelectionError = false;
                }),
              ),
            ),
            if (_showSelectionError && _selectedSubgroupId == null) ...[
              const SizedBox(height: 8),
              Text(
                l10n.joinSuccessChooseRequired,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.softCoral,
                ),
              ),
            ],
          ] else ...[
            // Caso sin subgrupos: mensaje amable, no como error.
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.warmIvory,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.mutedGold.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.coffee_outlined,
                          size: 18,
                          color: AppTheme.mutedGold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          l10n.joinSuccessNoSubgroupsTitle,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.joinSuccessNoSubgroupsHelp,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
      primaryLabel: l10n.joinSuccessPrimaryCta,
      onPrimary: () {
        if (hasSubgroups && _selectedSubgroupId == null) {
          setState(() => _showSelectionError = true);
          return;
        }
        Navigator.pop(
          context,
          _JoinSuccessResult(subgroupId: _selectedSubgroupId),
        );
      },
      secondaryLabel: l10n.joinSuccessSecondaryCta,
      onSecondary: () => Navigator.pop(context),
    );
  }
}
