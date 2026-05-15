# Fase 13 — Auditoría Release Candidate (QA integral)

## Objetivo

Auditar Tarci Secret como **Release Candidate** de la v1 pública: cinco modalidades cerradas, capacidades transversales documentadas en fases 9–12, sin ampliar alcance ni rediseñar por capricho.

## Estado Git al inicio

| Campo | Valor |
|-------|--------|
| Rama | `main` |
| Commits por delante de `origin/main` | 36 |
| Árbol de trabajo | Limpio |
| Checkpoint | **No creado** (árbol ya limpio) |

## Estado del producto (contrato)

| Modalidad | `dynamicType` / preset | Estado documentado |
|-----------|------------------------|-------------------|
| Amigo Secreto | `secret_santa` | Fases 8–9, push 9B.3, retención 12 |
| Sorteo | `simple_raffle` | Fase 9B |
| Equipos | `teams` / `standard` | Fase 10B |
| Parejas | `teams` / `pairings` | Fase 10C |
| Duelos | `teams` / `duels` | Fase 11 |

**No en alcance v1:** Debate como dinámica creable (solo plantillas de chat auto con palabra “debate” en copy social).

## Validaciones automáticas ejecutadas

| Comando | Resultado |
|---------|-----------|
| `flutter pub get` | OK |
| `flutter gen-l10n` | OK |
| `flutter analyze` | **Sin issues** |
| `npm run build` (firebase_functions) | **OK** |
| Tests Flutter | Solo `test/widget_test.dart` (smoke `1+1`); **no hay suite de integración** |

## Matriz de modalidades (inspección técnica)

| Bloque | AS | Sorteo | Equipos | Parejas | Duelos |
|--------|:--:|:------:|:-------:|:-------:|:------:|
| Wizard propio | ✓ | ✓ | ✓ | ✓ | ✓ |
| Detalle dedicado | ✓ | ✓ | ✓ (preset) | ✓ | ✓ |
| Join por código | ✓ | ✓ | ✓ | ✓ | ✓ |
| Chat social | ✓ | ✗ | ✓ | ✓ | ✓ |
| Push completado | ✓ | ✓ | ✓ | ✓ | ✓ |
| Retención 90d | ✓ | ✓ | ✓ | ✓ | ✓ |
| PDF/email/share | ✓ | ✓ | ✓ | ✓ | ✓ |
| SnackBars éxito redundantes (12.1) | ✓ | ✓ | ✓ | ✓ | ✓ |

**Enrutado:** `GroupDetailScreen` → `simpleRaffle` → `RaffleGroupDetailScreen`; `teams` → `TeamsGroupDetailScreen`; resto → cuerpo Amigo Secreto. `app_router.dart` sin rutas muertas detectadas.

---

## Hallazgos

### P0 — Bloqueantes publicación

| ID | Tipo | Descripción | Estado |
|----|------|-------------|--------|
| — | — | Ninguno confirmado por inspección estática en esta pasada | — |

### P1 — Importantes (corregidos en fase)

| ID | Tipo | Descripción | Estado |
|----|------|-------------|--------|
| P1-01 | UX/i18n | Chip dashboard equipos/parejas/duelos en `teamStatus.generating` mostraba “Sorteo en curso” | **Corregido** — `TeamsUiCopy.homeStateGenerating` + claves ARB 5 idiomas |
| P1-02 | Copy | Subtítulo selector dinámicas prometía “más modos pronto” con 5 modalidades activas | **Corregido** — `dynamicsSelectSubtitle` en ES/EN/PT/IT/FR |
| P1-03 | Backend | Retención se recalculaba en raffle/teams sin guard de primera finalización (draw sí lo tenía) | **Corregido** — `retentionPatchIfFirstRaffleCompletion` / `retentionPatchIfFirstTeamsCompletion` |
| P1-04 | Push | Repair de `executeDraw` completaba sorteo sin `notifyGroupDynamicCompleted` | **Corregido** — push tras repair exitoso |

### P1 — Pendientes (no corregidos)

| ID | Tipo | Descripción | Motivo |
|----|------|-------------|--------|
| P1-05 | Push | Reintento idempotente tras crash post-commit no reenvía push | Diseño intencional (no duplicar); riesgo si el primer envío nunca ocurrió — validar en QA manual |
| P1-06 | Purge | `purgeGroupFully` puede dejar estado parcial si falla a mitad | Requiere job de reconciliación / reintentos; volumen bajo en beta |

### P2 — Recomendables / no bloqueantes

| ID | Tipo | Descripción | Estado |
|----|------|-------------|--------|
| P2-01 | UX | Historial dashboard oculta chip de tipo dinámico en tarjetas completadas | Pendiente |
| P2-02 | UX | Grupos completados sin `eventDate` no pasan a sección “Completados” | Pendiente (producto) |
| P2-03 | i18n | `dynamicsComingSoonBadge` sin uso en UI | Pendiente (limpieza ARB opcional) |
| P2-04 | Datos | `dynamicType` inválido → fallback `secretSanta` en parser | Pendiente — solo datos corruptos/legacy |
| P2-05 | Modelo | `ManagedParticipantDeliveryMode.inApp` / `ownerDelegated` persisten como `verbal` | Pendiente — comportamiento conocido |
| P2-06 | Push | Nombre de grupo visible en cuerpo de notificación (lock screen) | Aceptado por diseño |
| P2-07 | Purge | Límites 40 backfill / 50 purge por run | Documentado fase 12 |
| P2-08 | Doc | Docs push antiguos listan 3 `eventKind`; código tiene 5 | Doc desactualizada, no runtime |

---

## Bugs corregidos en esta fase

1. **Dashboard:** etiqueta correcta al formar equipos/parejas/duelos (`home*StateGenerating`).
2. **Selector:** subtítulo alineado con las 5 dinámicas activas.
3. **Retención:** guard unificado en `retention.ts` para draw/raffle/teams.
4. **Push AS:** notificación tras repair de sorteo atascado.
5. **Rutas:** `groups_home_screen` usa `AppRoutes.groupDetailFor` en lugar de strings hardcodeadas.

**Archivos tocados:** `retention.ts`, `executeDraw.ts`, `executeRaffle.ts`, `executeTeams.ts`, `teams_ui_copy.dart`, `groups_home_screen.dart`, `dynamics_selector_screen.dart`, `app_*.arb` (×5), generados l10n.

---

## Estado por bloque transversal

| Bloque | Veredicto técnico |
|--------|-------------------|
| **Amigo Secreto** | Flujo completo; privacidad assignments en rules; chat + Tarci auto |
| **Sorteo** | Sin chat; resultado público; push `raffle_completed` |
| **Equipos** | Preset `standard`; copy `TeamsUiCopy` |
| **Parejas** | Preset `pairings`; no mezcla “Equipos” en labels principales |
| **Duelos** | Preset `duels`; VS / rival en copy dedicado |
| **Chat** | Sorteo excluido en `tarciChatAutomation`; catálogos por preset |
| **Push** | 5 `eventKind`; actor excluido; `data` sin asignaciones |
| **Retención** | Scheduler + backfill; notice UI si `retentionDeleteAt` |
| **i18n** | 5 idiomas runtime; sin hardcodes visibles en `features/` |
| **About** | 5 dinámicas + retención + LinkedIn |
| **Splash** | Android 12 isotipo safe; Flutter splash vertical intacto |
| **Feedback UX** | Fase 12.1 aplicada (sin snackbars éxito redundantes) |

---

## Inconsistencias documentación ↔ código

| Documento | Código | Notas |
|-----------|--------|-------|
| Fase 9A “debates futuro” | 5 dinámicas activas en selector | Doc histórica; producto evolucionó |
| Fase 9B.3 (3 event kinds) | 5 en `groupNotifications.ts` | Actualizar doc en fase posterior |
| Fase 12.1 splash vertical Android 12 | 12.1.1 isotipo Android 12 | Doc 12.1 actualizado; 12.1.1 es la verdad operativa |

---

## Riesgos residuales

1. **QA manual obligatorio** en dispositivo real (push FCM, splash visual, flujos owner/miembro).
2. **Sesión anónima:** pérdida de dispositivo = pérdida de acceso (sin recuperación de cuenta).
3. **Purge masivo** inicial en producción limitado por batch.
4. **Grupos legacy** sin `dynamicType` o sin timestamps de cierre → backfill gradual del scheduler.
5. **No hay tests E2E** automatizados de modalidades.

---

## Recomendación final

| Pregunta | Respuesta |
|----------|-----------|
| ¿Listo para QA manual intensivo? | **Sí** — tras esta pasada y las correcciones P1 |
| ¿Listo para `git push`? | **Sí** (36+ commits locales); conviene push a rama de staging antes de stores |
| ¿Listo para beta pública / stores? | **No todavía** — completar checklist manual Stan + push en dispositivos reales |
| ¿Qué queda antes de beta? | Checklist secciones A–O; validar splash Android 12+ en hardware; 1 ciclo completo por modalidad con 3+ usuarios; revisar purge en entorno staging |

---

## Checklist manual para Stan

### A. Arranque / idioma / dashboard

- [ ] Cold start: splash nativo → splash Flutter (logo vertical, tagline, autoría).
- [ ] Cambiar idioma ES → EN → PT → IT → FR; reiniciar app; textos coherentes.
- [ ] Dashboard: hero menciona las 5 dinámicas; sin “próximamente” engañoso.
- [ ] Selector dinámicas: 5 tarjetas navegan a wizard correcto.
- [ ] Crear una dinámica de cada tipo; chips de tipo en tarjetas activas correctos.

### B. Amigo Secreto

- [ ] Crear con/sin owner participante; subgrupos; regla diferente subgrupo.
- [ ] Invitar por código; join con apodo.
- [ ] Participante sin app + niño gestionado; responsable ve solo gestionados.
- [ ] Ejecutar sorteo; bloqueo post-sorteo; “Mi amigo secreto” privado.
- [ ] Owner **no** ve asignaciones globales.
- [ ] Wishlist; chat; mensaje system al completar; push en dispositivo B (A = owner excluido).
- [ ] Aviso retención si `retentionDeleteAt` en Firestore.

### C. Sorteo

- [ ] Wizard; owner participa + apodo; manuales; mínimo participantes; N ganadores.
- [ ] Ejecutar; resultado público; **sin** entrada de chat en detalle.
- [ ] Share / PDF / correo si aplica; push completado.
- [ ] Invitado no ve herramientas admin.

### D. Equipos

- [ ] Wizard team_count o team_size; formar equipos; reparto equilibrado.
- [ ] Renombrar equipo; admin vs miembro; chat + Tarci auto.
- [ ] Export PDF/email/share; copy dice “Equipo”, no Parejas/Duelos.
- [ ] Chip dashboard “Formando equipos” durante ejecución (no “Sorteo en curso”).

### E. Parejas

- [ ] Número par obligatorio; resultado “Parejas”; preset correcto en home.
- [ ] Chat, push `pairings_completed`, exportaciones.

### F. Duelos

- [ ] Número par; layout VS; copy duelo/rival; push `duels_completed`.
- [ ] No parece Parejas renombrado.

### G. Chat y Tarci auto

- [ ] SS: plantillas wishlist/debate OK; equipos: sin wishlist.
- [ ] Parejas vs duelos: chips system distintos al completar.
- [ ] Sorteo: sin chat en UI.

### H. Push

- [ ] Activar tarjeta push; denegado → snackbar error; OK → tarjeta desaparece.
- [ ] Tap notificación abre detalle del grupo correcto.
- [ ] Cuerpo de notificación sin nombres de asignados/ganadores secretos.

### I. PDF / email / share

- [ ] Por modalidad: generar PDF, enviar correo, compartir texto; logo legible.

### J. Retención

- [ ] Completar dinámica → campos `retentionDeleteAt` / `retentionBasisAt` en Firestore.
- [ ] `eventDate` futura → borrado = eventDate + 90d.
- [ ] Aviso en detalle solo con fecha real.

### K. Eliminación manual

- [ ] Owner borra grupo; vuelve a home **sin** snackbar éxito; datos eliminados (invite_codes, user_groups).

### L. About / LinkedIn / versión

- [ ] About lista 5 dinámicas; retención; privacidad; LinkedIn abre; versión visible.

### M. Splash Android / iOS

- [ ] Android 12+: isotipo centrado, sin wordmark recortado.
- [ ] Android &lt; 12 / iOS: marca vertical razonable.
- [ ] Transición a splash Flutter sin parpadeo grave.

### N. Cambio de idioma en flujo

- [ ] Cambiar idioma con grupo abierto; volver; labels de estado coherentes.

### O. Modo anónimo / sesión

- [ ] Primera apertura: login anónimo automático.
- [ ] Cerrar sesión (debug o flujo): nueva sesión = grupos anteriores no visibles (esperado).
- [ ] Documentar para usuarios: sin cuenta recuperable.

---

## Commit sugerido

```
chore(qa): auditoria integral release candidate y correcciones de consistencia
```
