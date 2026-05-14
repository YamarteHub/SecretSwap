import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/premium_ui.dart';
import '../../groups/presentation/providers.dart';

const Duration _kAuthTimeout = Duration(seconds: 10);
/// Tiempo mínimo de lectura del splash Flutter (crédito + marca) antes de salir.
const Duration _kMinSplashBrandTime = Duration(milliseconds: 1350);

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  bool _loading = true;
  String? _error;

  late final AnimationController _entryCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 720),
  )..forward();

  late final Animation<double> _fade = CurvedAnimation(
    parent: _entryCtrl,
    curve: Curves.easeOutCubic,
  );

  late final Animation<Offset> _slide =
      Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero).animate(
        CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutCubic),
      );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _boot());
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    super.dispose();
  }

  Future<void> _prefetchDashboardData() async {
    try {
      await ref.read(myGroupsProvider.future);
    } catch (e, st) {
      debugPrint('[TarciSwap] splash: prefetch myGroups failed: $e');
      debugPrint('$st');
    }
  }

  Future<void> _boot() async {
    final startedAt = DateTime.now();
    debugPrint('[TarciSwap] splash: inicio init / boot');
    if (!mounted) return;
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final existing = FirebaseAuth.instance.currentUser;
      if (existing != null) {
        debugPrint('[TarciSwap] splash: sesión ya activa uid=${existing.uid}');
        await Future.wait([
          _ensureMinSplashTime(startedAt),
          _prefetchDashboardData(),
        ]);
        if (!mounted) return;
        context.go(AppRoutes.groupsHome);
        return;
      }

      debugPrint(
        '[TarciSwap] splash: inicio login anónimo (timeout ${_kAuthTimeout.inSeconds}s)',
      );
      await FirebaseAuth.instance.signInAnonymously().timeout(
        _kAuthTimeout,
        onTimeout: () {
          throw TimeoutException(
            'El Auth Emulator no respondió en ${_kAuthTimeout.inSeconds}s. '
            '¿Está corriendo en el host (puerto 9099) y la app en Android Emulator usa 10.0.2.2?',
          );
        },
      );
      debugPrint('[TarciSwap] splash: login correcto');
      await Future.wait([
        _ensureMinSplashTime(startedAt),
        _prefetchDashboardData(),
      ]);
      if (!mounted) return;
      context.go(AppRoutes.groupsHome);
    } on TimeoutException catch (e) {
      debugPrint('[TarciSwap] splash: error timeout $e');
      if (!mounted) return;
      setState(() {
        _error = e.message ?? '$e';
        _loading = false;
      });
    } catch (e, st) {
      debugPrint('[TarciSwap] splash: error $e');
      debugPrint('[TarciSwap] splash: stack $st');
      if (!mounted) return;
      setState(() {
        _error = '$e';
        _loading = false;
      });
    }
  }

  Future<void> _ensureMinSplashTime(DateTime startedAt) async {
    final elapsed = DateTime.now().difference(startedAt);
    final remaining = _kMinSplashBrandTime - elapsed;
    if (remaining.isNegative) return;
    await Future.delayed(remaining);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.warmBackgroundGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Column(
              children: [
                const Spacer(flex: 2),
                FadeTransition(
                  opacity: _fade,
                  child: SlideTransition(
                    position: _slide,
                    child: const _SplashBrand(),
                  ),
                ),
                const SizedBox(height: 18),
                FadeTransition(
                  opacity: _fade,
                  child: Text(
                    l10n.splashTagline,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.78),
                      height: 1.45,
                    ),
                  ),
                ),
                const Spacer(flex: 3),
                if (_error != null) ...[
                  WarningBox(message: _error!),
                  const SizedBox(height: 14),
                  FilledButton(
                    onPressed: _loading ? null : _boot,
                    child: Text(l10n.retry),
                  ),
                ] else if (_loading) ...[
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: AppTheme.deepPlum.withValues(alpha: 0.55),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.splashBootBrandedHint,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
                      height: 1.38,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ] else
                  const SizedBox.shrink(),
                const SizedBox(height: 16),
                FadeTransition(
                  opacity: _fade,
                  child: Text(
                    l10n.productAuthorshipLine,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.52),
                      letterSpacing: 0.12,
                      height: 1.25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Logo del splash con un glow radial cálido detrás para integrar el logo
/// transparente sobre el fondo crema sin recurrir a una card cuadrada.
class _SplashBrand extends StatelessWidget {
  const _SplashBrand();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          IgnorePointer(
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.mutedGold.withValues(alpha: 0.22),
                    AppTheme.mutedGold.withValues(alpha: 0.06),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.55, 1.0],
                ),
              ),
            ),
          ),
          const BrandMark(
            variant: BrandAsset.vertical,
            height: 210,
            rounded: false,
          ),
        ],
      ),
    );
  }
}
