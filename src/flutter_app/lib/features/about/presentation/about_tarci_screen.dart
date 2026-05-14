import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/premium_ui.dart';

/// Perfil público indicado en la fase 7B.
const String kTarciCreatorLinkedInUrl =
    'https://es.linkedin.com/in/stalin-yamarte-4360b857';

class AboutTarciScreen extends StatelessWidget {
  const AboutTarciScreen({super.key});

  Future<void> _openLinkedIn(BuildContext context) async {
    final uri = Uri.tryParse(kTarciCreatorLinkedInUrl);
    final l10n = context.l10n;
    if (uri == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.aboutLinkedInError)),
      );
      return;
    }
    try {
      if (await canLaunchUrl(uri)) {
        final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
        if (!ok && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.aboutLinkedInError)),
          );
        }
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.aboutLinkedInError)),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.aboutLinkedInError)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppTheme.warmIvory,
      appBar: AppBar(
        leading: IconButton(
          tooltip: l10n.back,
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.groupsHome);
            }
          },
        ),
        title: Text(
          l10n.aboutScreenTitle,
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
        children: [
          SecretCard(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 22),
            child: Column(
              children: [
                const BrandMark(variant: BrandAsset.vertical, height: 112, rounded: false),
                const SizedBox(height: 16),
                Text(
                  l10n.appName,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.aboutTagline,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.82),
                    height: 1.45,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SecretCard(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.aboutSectionWhatTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.aboutSectionWhatBody,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.42,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.aboutSectionHowTitle,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          _AboutStepTile(
            icon: Icons.groups_outlined,
            title: l10n.aboutStep1Title,
            body: l10n.aboutStep1Body,
          ),
          const SizedBox(height: 8),
          _AboutStepTile(
            icon: Icons.tune_rounded,
            title: l10n.aboutStep2Title,
            body: l10n.aboutStep2Body,
          ),
          const SizedBox(height: 8),
          _AboutStepTile(
            icon: Icons.shuffle_rounded,
            title: l10n.aboutStep3Title,
            body: l10n.aboutStep3Body,
          ),
          const SizedBox(height: 8),
          _AboutStepTile(
            icon: Icons.celebration_outlined,
            title: l10n.aboutStep4Title,
            body: l10n.aboutStep4Body,
          ),
          const SizedBox(height: 16),
          SecretCard(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.aboutSectionPrivacyTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.aboutSectionPrivacyBody,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.42,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.aboutSectionPrivacyTrust,
                  style: theme.textTheme.bodySmall?.copyWith(
                    height: 1.38,
                    color: theme.colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SecretCard(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.aboutSectionCreatorTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.aboutSectionCreatorSubtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 14),
                FilledButton.tonalIcon(
                  onPressed: () => _openLinkedIn(context),
                  icon: const Icon(Icons.work_outline_rounded),
                  label: Text(l10n.aboutLinkedInCta),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SecretCard(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.aboutVersionTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snap) {
                    if (snap.connectionState != ConnectionState.done) {
                      return const SizedBox(
                        height: 28,
                        width: 28,
                        child: CircularProgressIndicator(strokeWidth: 2.2),
                      );
                    }
                    if (snap.hasError || !snap.hasData) {
                      return Text(
                        l10n.aboutVersionLine('—'),
                        style: theme.textTheme.bodyMedium,
                      );
                    }
                    final p = snap.data!;
                    final build = p.buildNumber.trim();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.aboutVersionLine(p.version),
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (build.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            l10n.aboutBuildLine(build),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                        const SizedBox(height: 10),
                        Text(
                          l10n.productAuthorshipLine,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.9),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutStepTile extends StatelessWidget {
  const _AboutStepTile({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SecretCard(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.mutedGold.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppTheme.deepPlum.withValues(alpha: 0.88)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.82),
                    height: 1.35,
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
