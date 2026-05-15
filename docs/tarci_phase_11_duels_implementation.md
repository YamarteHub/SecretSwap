# Fase 11 — Duelos (implementación)

## Resumen

Modalidad **Duelos** sobre el motor de Equipos (`dynamicType: teams`, `teamsPreset: duels`).

- Agrupación fija: `team_size` con tamaño 2 (misma lógica que Parejas).
- Regla de ejecución: participantes elegibles **≥ 2 y par**.
- UX orientada a enfrentamientos **1 vs 1** (cruces VS), no a «pareja A + B».
- Reutiliza: detalle de equipos, chat, push, share/email/PDF, renombrado.

## Backend

| Archivo | Cambio |
|---------|--------|
| `shared/dtos.ts` | `TeamsPresetSchema` incluye `duels` |
| `functions/createTeamsGroup.ts` | Fuerza `team_size` + size 2 para `pairings` y `duels` |
| `functions/executeTeams.ts` | Paridad, mensaje `chat.system.duelsCompleted.v1`, doc `system_duelsCompleted_*` |
| `shared/groupNotifications.ts` | Copy push duels; `eventKind: duels_completed`; `teamsPreset: duels` en FCM |
| `shared/tarciAutoCatalogDuels.ts` | 50 mensajes auto (metadatos) |
| `shared/tarciChatAutomation.ts` | Rama `duels` en decisión de mensajes |

## Flutter

| Área | Archivo |
|------|---------|
| Modelos | `group_models.dart` — `TeamsPreset.duels`, `parseTeamsPreset` |
| Repositorio | `groups_repository_impl.dart` — `teamsPreset: 'duels'` en create |
| UI copy | `teams_ui_copy.dart` — ramas `duels` / `pairings` / `standard` |
| Wizard | `create_duels_wizard_screen.dart`, ruta `/groups/dynamics/duels/create` |
| Selector | `dynamics_selector_screen.dart` — tarjeta Duelos activa |
| Detalle | `teams_group_detail_screen.dart` — `_DuelsVsMatchCard`, validación par |
| Home / join / chat | `groups_home_screen`, `join_by_code_screen`, `group_chat_screen` |
| Export | `team_result_text.dart`, `team_result_pdf.dart` — formato `A vs B` |

## Copy producto (ES)

| Contexto | Texto |
|----------|-------|
| Modalidad | Duelos |
| Wizard CTA | Crear duelos |
| Acción detalle | Generar duelos |
| Estado listo | Duelos listos |
| Resultado | ¡Duelos listos! |

## i18n

- Claves UI `duels*` y `homeDynamicTypeDuels` en 5 ARB.
- 50 mensajes `chatSystemAutoDuels*` generados con `scripts/gen-duels-tarci-i18n.mjs`.
- `chat.system.duelsCompleted.v1` en chat y `tarci_auto_chat_l10n.dart`.
- `aboutSectionWhatBody` actualizado en 5 idiomas (parejas + duelos).

## Scripts

```bash
node scripts/gen-duels-tarci-i18n.mjs
cd src/flutter_app && flutter gen-l10n
cd src/firebase_functions && npm run build
```

## Checklist manual sugerido

- [ ] Crear duelos con número par de participantes
- [ ] Error claro con participantes impares
- [ ] Detalle muestra cruces VS y no lista tipo pareja
- [ ] Chat: mensaje sistema al completar duelos
- [ ] Push con copy de duelos (organizador / miembros)
- [ ] Compartir / email / PDF con formato `Nombre vs Nombre`
- [ ] Unirse por código → diálogo de éxito duelos
- [ ] Selector dinámicas: tarjeta Duelos sin «Próximamente»

## Commit sugerido

```
feat(duels): modalidad Duelos con cruces 1vs1, chat, push y exportaciones
```

## Riesgos / notas

- Los 50 mensajes Tarci auto se adaptan desde el catálogo de equipos (no son textos literales del brief de fase 11).
- Tras regenerar i18n, verificar casing `chatSystemAutoDuels*` en `tarci_auto_chat_l10n.dart` (no `Autoduels`).
