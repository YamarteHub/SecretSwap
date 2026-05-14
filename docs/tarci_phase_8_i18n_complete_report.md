# Tarci Secret — Fase 8 / 8B — Informe de internacionalización

## Checkpoint Git (Fase 8B)

Commit `29b3d3d` — `checkpoint antes de cerrar fase 8 selector errores y auditoria i18n`: creado con `--allow-empty` porque el árbol estaba **limpio** antes de aplicar los cambios de esta subfase.

**Commit de implementación:** `2dbef00` — `feat(8b): selector 5 idiomas, Functions en l10n y excepcion asignacion estable`.

## Objetivo

Cerrar la internacionalización **funcional** en cinco idiomas (es, en, pt, it, fr) con selector real, errores de Cloud Functions localizados, eliminación de lógica frágil basada en texto de error traducido, y documentación de cierre.

## Idiomas en runtime

Locales soportados por `AppLocalizations.supportedLocales`:

- `es` — Español (template ARB)
- `en` — Inglés
- `pt` — Portugués
- `it` — Italiano
- `fr` — Francés

ARB correspondientes: `app_es.arb`, `app_en.arb`, `app_pt.arb`, `app_it.arb`, `app_fr.arb` (misma estructura de claves; generación previa en commit `35c766f` + script `tool/build_phase8_arbs.py`).

## Selector de idioma (UI)

**Ubicación:** `groups_home_screen.dart` — bottom sheet del icono de idioma.

**Opciones visibles:**

1. **Sistema** — `languageSystem` (l10n).
2. **Español** — etiqueta fija nativa (requisito de producto).
3. **English** — etiqueta fija nativa.
4. **Português** — etiqueta fija nativa.
5. **Italiano** — etiqueta fija nativa.
6. **Français** — etiqueta fija nativa.

Las etiquetas de idioma en forma autónima evitan que “English” aparezca como “Inglés” cuando la UI está en español, alineado con la guía de la fase 8B.

**Persistencia:** sin cambios — `LocaleController` + `SharedPreferences` (`tarci.locale`), valores `system` | `es` | `en` | `pt` | `it` | `fr`.

**Detección “Sistema”:** `MaterialApp.router` con `locale: selectedLocale` y `localeResolutionCallback`: si no hay preferencia guardada, se elige el primer `supportedLocales` que coincida en `languageCode` con el dispositivo; si no hay coincidencia, fallback `es`.

## JSON previos consolidados (fase 8 previa)

Textos PT/IT/FR preparados en documentos bajo `docs/` se fusionaron en los ARB mediante `tool/build_phase8_arbs.py`, incluyendo entre otros:

- `tarci_chat_auto_messages_i18n.json` (50 mensajes Tarci automáticos).
- `tarci_phase_6c_chat_refresh_i18n.json`
- `tarci_phase_7a_delete_group_i18n.json`
- `tarci_phase_7b_about_author_i18n.json`

## Mensajes Tarci automáticos

Siguen resolviéndose vía `localizedTarciAutoMessage` y claves `chatSystemAuto*` en los cinco ARB (misma cobertura que el template ES).

## Errores de Cloud Functions localizados

**Archivo:** `lib/core/messaging/functions_user_message.dart`

**Firma anterior:**

```dart
String userVisibleErrorMessage(Object error);
String userVisibleActionErrorMessage(Object error);
```

**Firma nueva:**

```dart
String userVisibleErrorMessage(Object error, AppLocalizations l10n);
String userVisibleActionErrorMessage(Object error, AppLocalizations l10n);
```

**ReasonCodes cubiertos** (mapeados a `functionsError*` en ARB):

- `ALREADY_MEMBER`
- `CODE_NOT_FOUND`
- `CODE_EXPIRED`
- `GROUP_ARCHIVED`
- `USER_REMOVED`
- `DRAW_IN_PROGRESS`
- `DRAW_ALREADY_COMPLETED`
- `DRAW_COMPLETED_INVITES_CLOSED`
- `SUBGROUP_IN_USE`
- `SUBGROUP_NOT_FOUND`
- `NOT_OWNER`
- `GROUP_DELETE_FORBIDDEN`
- `GROUP_DELETE_FAILED`
- `DRAW_LOCKED`

**Heurísticas sobre `error.message` (inglés del backend):** se mantienen solo como respaldo; el mensaje mostrado al usuario sale siempre de **l10n** (mismas claves semánticas que los reason codes anteriores).

**Otros:**

- `FirebaseException` con `permission-denied` → `functionsErrorPermissionDeniedDrawRule`.
- Fallback → `functionsErrorGenericAction` o `functionsErrorUnknown`.
- Modo debug + patrón entorno/sesión → `functionsErrorDebugSession` (`userVisibleActionErrorMessage`).

**Llamadas actualizadas:** `groups_home_screen`, `group_detail_screen`, `join_by_code_screen`, `create_group_screen`, `wishlist_edit_screen`, `my_assignment_screen`.

## Errores estables (sin depender del idioma del mensaje)

- **Nuevo tipo:** `MyAssignmentNotFoundException` en `lib/features/draw/domain/draw_exceptions.dart`.
- **`draw_repository_impl`:** si no existe el documento de asignación, se lanza `MyAssignmentNotFoundException` en lugar de `StateError('No hay asignación…')`.
- **`my_assignment_screen`:** si el error es `MyAssignmentNotFoundException`, se muestra `myAssignmentNotAvailableMessage`; en caso contrario, `userVisibleErrorMessage(e, context.l10n)`.

Se elimina la comparación por subcadenas “asignación/asignacion” sobre texto ya traducido.

## Auditoría de hardcodes visibles

- Búsqueda orientativa de `Text('...')` / `SnackBar(content: Text('...')` en `features/groups`, `draw`, `wishlist`, `chat`: **sin coincidencias** de literales de producto en esas rutas (el flujo ya estaba muy alineado con l10n).
- **Selector de idioma:** se usan cadenas fijas **solo** para nombres de idioma en forma nativa (decisión explícita de producto 8B).
- **Otros:** mensajes técnicos en `ArgumentError` dentro de repositorios (p. ej. respuesta inesperada del backend) no se expusieron como copy de usuario en esta fase.

**Resumen:** hardcodes de producto corregidos en el ámbito Functions + asignación; residuo técnico aceptado en errores internos de repositorio no mapeados a pantalla.

## Nuevas claves ARB en 8B

Ninguna clave nueva en esta subfase: se reutilizaron `functionsError*` y `language*` ya presentes tras la fase 8 previa. Los cinco ARB siguen alineados.

## Validaciones ejecutadas

- `flutter gen-l10n` — OK.
- `flutter analyze` — **No issues found!**

## Riesgos residuales

1. **Calidad lingüística PT/IT/FR:** parte del contenido se generó automáticamente (script + traductor); conviene revisión nativa en hitos futuros.
2. **Etiquetas fijas del selector:** no pasan por l10n; si se quisieran localizar los *nombres* de idiomas según locale (poco habitual), habría que modelarlo con claves específicas.
3. **`executeDrawErrorIsAlreadyCompleted`:** sigue usando heurística en inglés sobre `error.message` del SDK; es independiente del idioma de la UI y solo detecta estado “ya completado”.

## Checklist manual recomendada (Stan)

### Persistencia e idioma

1. Abrir app → Ajustar idioma a **Português** → cerrar app por completo → reabrir → confirmar UI en PT.
2. Repetir con **Italiano** y **Français**.
3. Elegir **Sistema** → comprobar que sigue el idioma del dispositivo (o fallback `es` si el idioma no está en la lista).

### Pantallas clave (muestra por idioma)

Para cada uno de **es / en / pt / it / fr** (mínimo PT, IT, FR una vez):

- Home / lista de grupos.
- Wizard “Crear amigo secreto” (2–3 pasos).
- Detalle de grupo (owner y miembro si aplica).
- Acerca de (bloque información de app + versión).
- Chat grupal (entrada + un envío).
- Wishlist (lectura/edición rápida).

### Funciones y errores

1. **Unirse por código** con código inválido → snackbar debe salir **en el idioma activo** (p. ej. mensaje tipo “no encontramos grupo…”).
2. **Eliminar grupo** (owner, pre/post sorteo según caso de prueba) → textos de diálogo y snackbar localizados.
3. **Sorteo** con error simulado (si tienes emulador) → mensaje localizado, no español fijo.
4. **Mi amigo secreto** antes de que exista asignación → mensaje `myAssignmentNotAvailableMessage` en el idioma activo (sin depender de texto del `StateError`).

### Regresión rápida

- LinkedIn desde Acerca de.
- Cambio de idioma sin reiniciar: el bottom sheet marca la opción correcta y la UI se reconstruye.

---

*Documento generado como cierre de Fase 8B (selector 5 idiomas, Functions → l10n, excepción de asignación estable, auditoría acotada).*
