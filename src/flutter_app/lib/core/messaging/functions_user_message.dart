import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../../l10n/app_localizations.dart';

/// Convierte errores de Functions / Firebase en textos legibles (sin stacktraces).
String userVisibleErrorMessage(Object error, AppLocalizations l10n) {
  if (error is FirebaseFunctionsException) {
    final reason = _reasonCodeFromDetails(error.details);
    final msg = (error.message ?? '').toLowerCase();

    switch (reason) {
      case 'ALREADY_MEMBER':
        return l10n.functionsErrorAlreadyMember;
      case 'CODE_NOT_FOUND':
        return l10n.functionsErrorCodeNotFound;
      case 'CODE_EXPIRED':
        return l10n.functionsErrorCodeExpired;
      case 'GROUP_ARCHIVED':
        return l10n.functionsErrorGroupArchived;
      case 'USER_REMOVED':
        return l10n.functionsErrorUserRemoved;
      case 'DRAW_IN_PROGRESS':
        return l10n.functionsErrorDrawInProgress;
      case 'DRAW_ALREADY_COMPLETED':
        return l10n.functionsErrorDrawAlreadyCompleted;
      case 'DRAW_COMPLETED_INVITES_CLOSED':
        return l10n.functionsErrorDrawCompletedInvitesClosed;
      case 'SUBGROUP_IN_USE':
        return l10n.functionsErrorSubgroupInUse;
      case 'SUBGROUP_NOT_FOUND':
        return l10n.functionsErrorSubgroupNotFound;
      case 'NOT_OWNER':
        return l10n.functionsErrorNotOwner;
      case 'GROUP_DELETE_FORBIDDEN':
        return l10n.functionsErrorGroupDeleteForbidden;
      case 'GROUP_DELETE_FAILED':
        return l10n.functionsErrorGroupDeleteFailed;
      case 'DRAW_LOCKED':
        return l10n.functionsErrorDrawLocked;
    }

    if (msg.contains('user already member') || msg.contains('already member')) {
      return l10n.functionsErrorAlreadyMember;
    }
    if (msg.contains('not found') && (msg.contains('invite') || msg.contains('code'))) {
      return l10n.functionsErrorCodeNotFound;
    }
    if (msg.contains('expired')) {
      return l10n.functionsErrorCodeExpired;
    }
    if (msg.contains('archived')) {
      return l10n.functionsErrorGroupArchived;
    }
    if (msg.contains('removed')) {
      return l10n.functionsErrorUserRemoved;
    }
    if (msg.contains('draw') && msg.contains('progress')) {
      return l10n.functionsErrorDrawInProgress;
    }

    return l10n.functionsErrorGenericAction;
  }

  if (error is FirebaseException) {
    if (error.code == 'permission-denied') {
      return l10n.functionsErrorPermissionDeniedDrawRule;
    }
  }

  return l10n.functionsErrorUnknown;
}

/// Mensaje guiado para debug cuando el error sugiere entorno/Functions/sesión.
String userVisibleActionErrorMessage(Object error, AppLocalizations l10n) {
  if (kDebugMode && _isLikelyEnvironmentOrSessionIssue(error)) {
    return l10n.functionsErrorDebugSession;
  }
  return userVisibleErrorMessage(error, l10n);
}

String? _reasonCodeFromDetails(Object? details) {
  if (details is Map) {
    final rc = details['reasonCode'];
    if (rc != null) return rc.toString();
    final nested = details['details'];
    if (nested is Map) {
      final rc2 = nested['reasonCode'];
      if (rc2 != null) return rc2.toString();
    }
  }
  return null;
}

/// `executeDraw` devolvió que el grupo ya estaba en estado completado (p. ej. doble tap).
bool executeDrawErrorIsAlreadyCompleted(Object error) {
  if (error is FirebaseFunctionsException) {
    final reason = _reasonCodeFromDetails(error.details);
    if (reason == 'DRAW_ALREADY_COMPLETED') return true;
    final msg = (error.message ?? '').toLowerCase();
    if (msg.contains('already completed') && msg.contains('draw')) {
      return true;
    }
  }
  return false;
}

bool _isLikelyEnvironmentOrSessionIssue(Object error) {
  if (error is FirebaseFunctionsException) {
    final code = error.code.toLowerCase();
    if (code == 'not-found' ||
        code == 'unavailable' ||
        code == 'internal' ||
        code == 'unauthenticated') {
      return true;
    }
    final msg = (error.message ?? '').toLowerCase();
    return msg.contains('function') ||
        msg.contains('not found') ||
        msg.contains('unavailable') ||
        msg.contains('unauthenticated') ||
        msg.contains('failed to fetch');
  }
  if (error is FirebaseException) {
    final code = error.code.toLowerCase();
    return code == 'unauthenticated' || code == 'network-request-failed';
  }
  return false;
}
