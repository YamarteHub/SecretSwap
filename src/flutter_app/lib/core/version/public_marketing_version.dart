/// Formato de versión pública para UI de producto (Acerca de, etc.).
///
/// Regla: `X.0.0` se muestra como `vX.0`; en cualquier otro caso se respeta
/// el valor completo con prefijo `v` (p. ej. `1.2.3` → `v1.2.3`).
String formatPublicMarketingVersion(String raw) {
  final t = raw.trim();
  if (t.isEmpty) return '—';
  final parts = t.split('.');
  if (parts.length >= 3 &&
      parts[0].isNotEmpty &&
      parts[1] == '0' &&
      parts[2] == '0') {
    return 'v${parts[0]}.0';
  }
  return 'v$t';
}
