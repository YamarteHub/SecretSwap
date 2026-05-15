import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/premium_ui.dart';
import '../../domain/group_chat_message.dart';
import '../tarci_auto_chat_l10n.dart';
import '../providers.dart';

/// Extra opcional al navegar al chat (nombre, fecha de entrega, estado sorteo).
class GroupChatRouteExtra {
  const GroupChatRouteExtra({
    required this.groupName,
    this.eventDate,
    this.drawCompleted = false,
    this.teamsCompleted = false,
  });

  final String groupName;
  final DateTime? eventDate;
  final bool drawCompleted;
  final bool teamsCompleted;
}

class GroupChatScreen extends ConsumerStatefulWidget {
  const GroupChatScreen({
    super.key,
    required this.groupId,
    required this.groupName,
    this.eventDate,
    this.drawCompleted = false,
    this.teamsCompleted = false,
  });

  final String groupId;
  final String groupName;
  final DateTime? eventDate;
  final bool drawCompleted;
  final bool teamsCompleted;

  @override
  ConsumerState<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends ConsumerState<GroupChatScreen> {
  static const int _maxChars = 500;
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _sending = false;

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  String _systemText(BuildContext context, String templateKey) {
    final l10n = context.l10n;
    final auto = localizedTarciAutoMessage(l10n, templateKey);
    if (auto != null && auto.isNotEmpty) return auto;
    switch (templateKey) {
      case 'chat.system.groupCreated.v1':
        return l10n.chatSystemGroupCreatedV1;
      case 'chat.system.drawCompleted.v1':
        return l10n.chatSystemDrawCompletedV1;
      case 'chat.system.teamsCompleted.v1':
        return l10n.chatSystemTeamsCompletedV1;
      default:
        return l10n.chatSystemUnknownTemplate(templateKey);
    }
  }

  Future<void> _send() async {
    final raw = _textController.text;
    final text = raw.trim();
    if (text.isEmpty || _sending) return;
    FocusScope.of(context).unfocus();
    setState(() => _sending = true);
    try {
      await ref.read(groupChatRepositoryProvider).sendUserMessage(
            groupId: widget.groupId,
            text: text,
          );
      if (mounted) {
        _textController.clear();
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.chatSendError)),
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final loc = Localizations.localeOf(context).toString();
    final uid = FirebaseAuth.instance.currentUser?.uid;

    ref.listen(groupChatMessagesProvider(widget.groupId), (previous, next) {
      next.whenOrNull(data: (_) => _scrollToBottom());
    });

    final messagesAsync = ref.watch(groupChatMessagesProvider(widget.groupId));

    final eventLine = widget.eventDate != null
        ? l10n.chatGroupEventLine(DateFormat.yMMMd(loc).format(widget.eventDate!))
        : null;

    return Scaffold(
      backgroundColor: AppTheme.warmIvory,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.groupName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            if (eventLine != null)
              Text(
                eventLine,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
        actions: [
          if (widget.teamsCompleted)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Center(
                child: Chip(
                  label: Text(
                    l10n.chatTeamsCompletedChip,
                    style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  visualDensity: VisualDensity.compact,
                  backgroundColor: AppTheme.sageGreen.withValues(alpha: 0.2),
                  side: BorderSide(color: AppTheme.sageGreen.withValues(alpha: 0.45)),
                ),
              ),
            )
          else if (widget.drawCompleted)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Center(
                child: Chip(
                  label: Text(
                    l10n.chatDrawCompletedChip,
                    style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  visualDensity: VisualDensity.compact,
                  backgroundColor: AppTheme.sageGreen.withValues(alpha: 0.2),
                  side: BorderSide(color: AppTheme.sageGreen.withValues(alpha: 0.45)),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              data: (messages) {
                if (messages.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline_rounded,
                            size: 48,
                            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.35),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.chatEmptyTitle,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.chatEmptyBody,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final m = messages[index];
                    if (m.kind == GroupChatMessageKind.system) {
                      final key = m.templateKey ?? '';
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: SecretCard(
                          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const BrandMark(variant: BrandAsset.icon, height: 28),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.chatTarciLabel,
                                      style: theme.textTheme.labelMedium?.copyWith(
                                        fontWeight: FontWeight.w800,
                                        color: AppTheme.deepPlum,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _systemText(context, key),
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        height: 1.4,
                                        color: theme.colorScheme.onSurface.withValues(alpha: 0.88),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    final isMine = m.senderUid != null && m.senderUid == uid;
                    final bubbleColor = isMine
                        ? AppTheme.deepPlum.withValues(alpha: 0.12)
                        : theme.colorScheme.surfaceContainerHighest;
                    final align = isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Column(
                        crossAxisAlignment: align,
                        children: [
                          if (!isMine && (m.senderDisplayName ?? '').isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(left: 4, bottom: 4),
                              child: Text(
                                m.senderDisplayName!,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.sizeOf(context).width * 0.82,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: bubbleColor,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(16),
                                topRight: const Radius.circular(16),
                                bottomLeft: Radius.circular(isMine ? 16 : 4),
                                bottomRight: Radius.circular(isMine ? 4 : 16),
                              ),
                              border: Border.all(
                                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
                              ),
                            ),
                            child: Text(
                              m.text ?? '',
                              style: theme.textTheme.bodyMedium?.copyWith(height: 1.35),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cloud_off_outlined, size: 44, color: theme.colorScheme.error),
                      const SizedBox(height: 12),
                      Text(
                        l10n.chatLoadError,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () {
                          ref.invalidate(groupChatMessagesProvider(widget.groupId));
                        },
                        child: Text(l10n.retry),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Material(
            elevation: 8,
            color: AppTheme.softCream,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        minLines: 1,
                        maxLines: 4,
                        maxLength: _maxChars,
                        onChanged: (_) => setState(() {}),
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          counterText: '',
                          hintText: l10n.chatInputHint,
                          filled: true,
                          fillColor: theme.colorScheme.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Builder(
                      builder: (context) {
                        final theme = Theme.of(context);
                        final canSend =
                            !_sending && _textController.text.trim().isNotEmpty;
                        return IconButton.filled(
                          tooltip: l10n.chatSendCta,
                          style: IconButton.styleFrom(
                            elevation: canSend ? 2.5 : 0,
                            shadowColor: canSend
                                ? AppTheme.deepPlum.withValues(alpha: 0.38)
                                : Colors.transparent,
                            backgroundColor: canSend
                                ? AppTheme.deepPlum
                                : theme.colorScheme.surfaceContainerHighest,
                            foregroundColor: canSend
                                ? Colors.white
                                : theme.colorScheme.onSurfaceVariant
                                    .withValues(alpha: 0.48),
                            disabledBackgroundColor:
                                theme.colorScheme.surfaceContainerHighest,
                            disabledForegroundColor: theme
                                .colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.42),
                            shape: const CircleBorder(),
                            fixedSize: const Size(48, 48),
                          ),
                          onPressed: canSend ? _send : null,
                          icon: _sending
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.send_rounded, size: 22),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
