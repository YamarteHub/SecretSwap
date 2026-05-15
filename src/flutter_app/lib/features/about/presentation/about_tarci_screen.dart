import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/premium_ui.dart';
import '../../../core/version/public_marketing_version.dart';
import '../../../l10n/app_localizations.dart';

/// Perfil público indicado en la fase 7B.
const String kTarciCreatorLinkedInUrl =
    'https://es.linkedin.com/in/stalin-yamarte-4360b857';

List<String> _aboutSplitParagraphs(String text) {
  return text
      .split('\n\n')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();
}

List<String> _aboutCapabilityLabels(AppLocalizations l10n) {
  return [
    l10n.dynamicsCardSecretSantaTitle,
    l10n.dynamicsCardRaffleTitle,
    l10n.dynamicsCardTeamsTitle,
    l10n.dynamicsCardPairingsTitle,
    l10n.dynamicsCardDuelsTitle,
  ];
}

class AboutTarciScreen extends StatelessWidget {
  const AboutTarciScreen({super.key});

  Future<void> _openLinkedIn(BuildContext context) async {
    final uri = Uri.parse(kTarciCreatorLinkedInUrl);
    final l10n = context.l10n;
    try {
      final ok = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!ok && context.mounted) {
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
    final whatParas = _aboutSplitParagraphs(l10n.aboutSectionWhatBody);
    final privacyParas = _aboutSplitParagraphs(l10n.aboutSectionPrivacyBody);

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
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 36),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 30),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.softCream,
                  AppTheme.warmIvory.withValues(alpha: 0.92),
                ],
              ),
              borderRadius: BorderRadius.circular(26),
              boxShadow: AppTheme.softElevatedShadow,
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.11),
              ),
            ),
            child: Column(
              children: [
                const BrandMark(variant: BrandAsset.vertical, height: 104, rounded: false),
                const SizedBox(height: 18),
                Text(
                  l10n.appName,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    height: 1.12,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.aboutTagline,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.82),
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SecretCard(
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.aboutSectionWhatTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 14),
                for (var i = 0; i < whatParas.length; i++) ...[
                  if (i > 0) const SizedBox(height: 14),
                  Text(
                    whatParas[i],
                    style: theme.textTheme.bodyMedium?.copyWith(
                      height: 1.52,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text(
            l10n.aboutCapabilitiesTitle,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 0.1,
              color: AppTheme.deepPlum.withValues(alpha: 0.88),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _aboutCapabilityLabels(l10n).map((label) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.deepPlum.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: AppTheme.deepPlum.withValues(alpha: 0.12),
                  ),
                ),
                child: Text(
                  label,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.deepPlum.withValues(alpha: 0.88),
                    height: 1.15,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 22),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.mutedGold.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.auto_stories_outlined,
                  color: AppTheme.deepPlum.withValues(alpha: 0.88),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.aboutSectionHowTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _AboutStepTile(
            icon: Icons.groups_outlined,
            title: l10n.aboutStep1Title,
            body: l10n.aboutStep1Body,
          ),
          const SizedBox(height: 10),
          _AboutStepTile(
            icon: Icons.tune_rounded,
            title: l10n.aboutStep2Title,
            body: l10n.aboutStep2Body,
          ),
          const SizedBox(height: 10),
          _AboutStepTile(
            icon: Icons.shuffle_rounded,
            title: l10n.aboutStep3Title,
            body: l10n.aboutStep3Body,
          ),
          const SizedBox(height: 10),
          _AboutStepTile(
            icon: Icons.celebration_outlined,
            title: l10n.aboutStep4Title,
            body: l10n.aboutStep4Body,
          ),
          const SizedBox(height: 20),
          SecretCard(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.verified_user_outlined,
                      color: AppTheme.deepPlum.withValues(alpha: 0.78),
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.aboutSectionPrivacyTitle,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.aboutSectionPrivacyLead,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                    color: AppTheme.deepPlum.withValues(alpha: 0.85),
                  ),
                ),
                const SizedBox(height: 12),
                for (var i = 0; i < privacyParas.length; i++) ...[
                  if (i > 0) const SizedBox(height: 14),
                  Text(
                    privacyParas[i],
                    style: theme.textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                  decoration: BoxDecoration(
                    color: AppTheme.deepPlum.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppTheme.deepPlum.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Text(
                    l10n.aboutSectionPrivacyTrust,
                    style: theme.textTheme.bodySmall?.copyWith(
                      height: 1.42,
                      color: theme.colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SectionCard(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
            backgroundColor: AppTheme.warmIvory,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.schedule_outlined,
                      color: AppTheme.softTerracotta.withValues(alpha: 0.95),
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.aboutRetentionTitle,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.aboutRetentionLead,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.88),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.aboutRetentionBody,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
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
                const SizedBox(height: 8),
                Text(
                  l10n.aboutSectionCreatorSubtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.42,
                  ),
                ),
                const SizedBox(height: 16),
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
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.aboutAppInfoTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 14),
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
                        l10n.aboutPackageInfoError,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          height: 1.35,
                        ),
                      );
                    }
                    final p = snap.data!;
                    final build = p.buildNumber.trim();
                    final publicVer = formatPublicMarketingVersion(p.version);
                    final onVar = theme.colorScheme.onSurfaceVariant;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.appName,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.2,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          publicVer,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                            color: AppTheme.deepPlum,
                            height: 1.1,
                          ),
                        ),
                        if (build.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            l10n.aboutBuildLine(build),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: onVar.withValues(alpha: 0.88),
                              height: 1.3,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.15,
                            ),
                          ),
                        ],
                        const SizedBox(height: 14),
                        Text(
                          l10n.aboutCopyrightLine,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: onVar.withValues(alpha: 0.72),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.12,
                            height: 1.25,
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
    return SectionCard(
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              gradient: AppTheme.brandHeroGradient,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppTheme.deepPlum.withValues(alpha: 0.88), size: 21),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  body,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.82),
                    height: 1.45,
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
