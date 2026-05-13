import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Convierte errores de Functions / Firebase en textos legibles (sin stacktraces).
String userVisibleErrorMessage(Object error) {
  if (error is FirebaseFunctionsException) {
    final reason = _reasonCodeFromDetails(error.details);
    final msg = (error.message ?? '').toLowerCase();

    switch (reason) {
      case 'ALREADY_MEMBER':
        return 'Ya perteneces a este grupo.';
      case 'CODE_NOT_FOUND':
        return 'No encontramos un grupo con ese código.';
      case 'CODE_EXPIRED':
        return 'Este código ha expirado.';
      case 'GROUP_ARCHIVED':
        return 'Este grupo ya está cerrado.';
      case 'USER_REMOVED':
        return 'No puedes volver a unirte a este grupo.';
      case 'DRAW_IN_PROGRESS':
        return 'El sorteo está en curso. Inténtalo más tarde.';
      case 'DRAW_ALREADY_COMPLETED':
        return 'Este sorteo ya se había completado.';
      case 'DRAW_COMPLETED_INVITES_CLOSED':
        return 'Este sorteo ya fue realizado y ya no admite nuevos participantes.';
      case 'SUBGROUP_IN_USE':
        return 'Antes de eliminar este subgrupo, mueve o deja sin subgrupo a sus participantes.';
      case 'SUBGROUP_NOT_FOUND':
        return 'El subgrupo ya no existe o fue eliminado.';
      case 'NOT_OWNER':
        return 'Solo el organizador puede realizar esta acción.';
      case 'DRAW_LOCKED':
        return 'No puedes modificar subgrupos o participantes cuando el sorteo está en curso o completado.';
    }

    if (msg.contains('user already member') || msg.contains('already member')) {
      return 'Ya perteneces a este grupo.';
    }
    if (msg.contains('not found') && (msg.contains('invite') || msg.contains('code'))) {
      return 'No encontramos un grupo con ese código.';
    }
    if (msg.contains('expired')) {
      return 'Este código ha expirado.';
    }
    if (msg.contains('archived')) {
      return 'Este grupo ya está cerrado.';
    }
    if (msg.contains('removed')) {
      return 'No puedes volver a unirte a este grupo.';
    }
    if (msg.contains('draw') && msg.contains('progress')) {
      return 'El sorteo está en curso. Inténtalo más tarde.';
    }

    return 'No se pudo completar la acción. Inténtalo de nuevo en un momento.';
  }

  if (error is FirebaseException) {
    if (error.code == 'permission-denied') {
      return 'No se pudo cambiar la regla del sorteo. Revisa que el sorteo no esté en curso ni finalizado.';
    }
  }

  return 'Algo salió mal. Inténtalo de nuevo en unos momentos.';
}

/// Mensaje guiado para debug cuando el error sugiere entorno/Functions/sesión.
String userVisibleActionErrorMessage(Object error) {
  if (kDebugMode && _isLikelyEnvironmentOrSessionIssue(error)) {
    return 'No se pudo completar la acción. Revisa si estás usando emuladores o Firebase real, si las Functions están desplegadas y si la sesión está activa.';
  }
  return userVisibleErrorMessage(error);
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
