import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/messaging/functions_user_message.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/premium_ui.dart';
import '../../domain/wishlist_models.dart';
import '../providers.dart';
import '../widgets/wishlist_read_body.dart';

class WishlistRouteExtra {
  const WishlistRouteExtra({this.subjectDisplayName, this.readOnly = false});

  final String? subjectDisplayName;
  final bool readOnly;
}

class WishlistEditScreen extends ConsumerStatefulWidget {
  const WishlistEditScreen({
    super.key,
    required this.groupId,
    required this.participantId,
    this.subjectDisplayName,
    this.readOnly = false,
  });

  final String groupId;
  final String participantId;
  final String? subjectDisplayName;
  final bool readOnly;

  @override
  ConsumerState<WishlistEditScreen> createState() => _WishlistEditScreenState();
}

class _LinkRowControllers {
  _LinkRowControllers({String? label, String? url})
      : label = TextEditingController(text: label ?? ''),
        url = TextEditingController(text: url ?? '');

  final TextEditingController label;
  final TextEditingController url;

  void dispose() {
    label.dispose();
    url.dispose();
  }
}

class _WishlistEditScreenState extends ConsumerState<WishlistEditScreen> {
  static const int _maxText = 500;
  static const int _maxLinks = 3;

  final _wishCtrl = TextEditingController();
  final _likesCtrl = TextEditingController();
  final _avoidCtrl = TextEditingController();
  final List<_LinkRowControllers> _links = [];

  bool _loading = true;
  bool _saving = false;
  String? _error;
  WishlistData? _loaded;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void dispose() {
    _wishCtrl.dispose();
    _likesCtrl.dispose();
    _avoidCtrl.dispose();
    for (final l in _links) {
      l.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await ref.read(wishlistRepositoryProvider).getWishlist(
            groupId: widget.groupId,
            participantId: widget.participantId,
          );
      if (!mounted) return;
      _wishCtrl.text = data.wishText ?? '';
      _likesCtrl.text = data.likesText ?? '';
      _avoidCtrl.text = data.avoidText ?? '';
      for (final l in _links) {
        l.dispose();
      }
      _links.clear();
      for (final l in data.links) {
        _links.add(_LinkRowControllers(label: l.label, url: l.url));
      }
      setState(() {
        _loaded = data;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = userVisibleErrorMessage(e);
      });
    }
  }

  bool _validHttpUrl(String raw) {
    final u = raw.trim();
    if (u.isEmpty) return false;
    final uri = Uri.tryParse(u);
    if (uri == null) return false;
    return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  Future<void> _save() async {
    final l10n = context.l10n;
    for (final row in _links) {
      final url = row.url.text.trim();
      final lab = row.label.text.trim();
      if (url.isEmpty && lab.isEmpty) continue;
      if (!_validHttpUrl(url)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.wishlistUrlInvalid)),
        );
        return;
      }
    }

    final payloadLinks = <WishlistLink>[];
    for (final row in _links) {
      final url = row.url.text.trim();
      final lab = row.label.text.trim();
      if (url.isEmpty) continue;
      payloadLinks.add(
        WishlistLink(
          label: lab.isEmpty ? null : lab,
          url: url,
        ),
      );
    }
    if (payloadLinks.length > _maxLinks) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.wishlistLinksMax(_maxLinks))),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      await ref.read(wishlistRepositoryProvider).setWishlist(
            groupId: widget.groupId,
            participantId: widget.participantId,
            payload: WishlistWritePayload(
              wishText: _wishCtrl.text.trim().isEmpty ? null : _wishCtrl.text.trim(),
              likesText: _likesCtrl.text.trim().isEmpty ? null : _likesCtrl.text.trim(),
              avoidText: _avoidCtrl.text.trim().isEmpty ? null : _avoidCtrl.text.trim(),
              links: payloadLinks,
            ),
          );
      ref.invalidate(
        wishlistDataProvider(
          WishlistParticipantKey(
            groupId: widget.groupId,
            participantId: widget.participantId,
          ),
        ),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.wishlistSaveSuccess)),
      );
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(userVisibleErrorMessage(e))),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _addLink() {
    if (_links.length >= _maxLinks) return;
    setState(() => _links.add(_LinkRowControllers()));
  }

  void _removeLink(int i) {
    setState(() {
      _links[i].dispose();
      _links.removeAt(i);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final title = widget.readOnly
        ? l10n.wishlistViewTitle
        : l10n.wishlistEditorTitle;
    final name = widget.subjectDisplayName?.trim();
    return Scaffold(
      backgroundColor: AppTheme.warmIvory,
      appBar: AppBar(
        backgroundColor: AppTheme.warmIvory,
        title: Text(title),
        actions: [
          if (!widget.readOnly)
            TextButton(
              onPressed: _saving || _loading ? null : _save,
              child: _saving
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.wishlistSaveCta),
            ),
        ],
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(_error!, textAlign: TextAlign.center),
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (name != null && name.isNotEmpty) ...[
                          Text(
                            name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                        ],
                        Text(
                          widget.readOnly
                              ? l10n.wishlistViewIntro
                              : l10n.wishlistEditorIntro,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 18),
                        if (widget.readOnly) ...[
                          if (_loaded != null) WishlistReadBody(data: _loaded!),
                          const SizedBox(height: 16),
                          OutlinedButton.icon(
                            onPressed: () => context.pop(),
                            icon: const Icon(Icons.arrow_back_rounded),
                            label: Text(l10n.back),
                          ),
                        ] else ...[
                          _labeledField(
                            context,
                            title: l10n.wishlistFieldWishTitle,
                            hint: l10n.wishlistFieldWishHint,
                            controller: _wishCtrl,
                          ),
                          const SizedBox(height: 14),
                          _labeledField(
                            context,
                            title: l10n.wishlistFieldLikesTitle,
                            hint: l10n.wishlistFieldLikesHint,
                            controller: _likesCtrl,
                          ),
                          const SizedBox(height: 14),
                          _labeledField(
                            context,
                            title: l10n.wishlistFieldAvoidTitle,
                            hint: l10n.wishlistFieldAvoidHint,
                            controller: _avoidCtrl,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Text(
                                l10n.wishlistFieldLinksTitle,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const Spacer(),
                              TextButton.icon(
                                onPressed:
                                    _links.length >= _maxLinks ? null : _addLink,
                                icon: const Icon(Icons.add_link, size: 18),
                                label: Text(l10n.wishlistAddLinkCta),
                              ),
                            ],
                          ),
                          Text(
                            l10n.wishlistLinksHelp(_maxLinks),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...List.generate(_links.length, (i) {
                            final row = _links[i];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: SecretCard(
                                padding: const EdgeInsets.all(14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            l10n.wishlistLinkRowTitle(i + 1),
                                            style: theme.textTheme.labelLarge
                                                ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () => _removeLink(i),
                                          icon: const Icon(Icons.close_rounded),
                                          tooltip: MaterialLocalizations.of(
                                            context,
                                          ).deleteButtonTooltip,
                                        ),
                                      ],
                                    ),
                                    TextField(
                                      controller: row.label,
                                      decoration: InputDecoration(
                                        labelText: l10n.wishlistLinkLabelOptional,
                                      ),
                                      textCapitalization: TextCapitalization.sentences,
                                    ),
                                    const SizedBox(height: 8),
                                    TextField(
                                      controller: row.url,
                                      decoration: InputDecoration(
                                        labelText: l10n.wishlistLinkUrlLabel,
                                        hintText: context.l10n.wishlistUrlHint,
                                      ),
                                      keyboardType: TextInputType.url,
                                      autocorrect: false,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                          const SizedBox(height: 8),
                          OutlinedButton.icon(
                            onPressed: () => context.pop(),
                            icon: const Icon(Icons.arrow_back_rounded),
                            label: Text(l10n.wishlistCancelCta),
                          ),
                        ],
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget _labeledField(
    BuildContext context, {
    required String title,
    required String hint,
    required TextEditingController controller,
  }) {
    final theme = Theme.of(context);
    return SecretCard(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            maxLines: 5,
            maxLength: _maxText,
            decoration: InputDecoration(
              hintText: hint,
              counterText: '',
            ),
          ),
        ],
      ),
    );
  }
}
