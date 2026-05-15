# Fase 10C — Parejas (implementación)

## Resumen

Modalidad **Parejas** sobre el motor de Equipos (`dynamicType: teams`, `teamsPreset: pairings`).

- Agrupación fija: `team_size` con tamaño 2.
- Regla de ejecución: participantes elegibles **≥ 2 y par**.
- Permite una sola pareja (2 personas); no exige `numTeams >= 2`.
- Reutiliza: detalle de equipos, chat, push, share/email/PDF, renombrado.

## Backend

| Archivo | Cambio |
|---------|--------|
| `shared/dtos.ts` | `TeamsPresetSchema`, validación pairings → `team_size` + size 2 |
| `functions/createTeamsGroup.ts` | Persiste `teamsPreset`; fuerza modo/tamaño en pairings |
| `functions/executeTeams.ts` | Paridad, skip `numTeams < 2`, mensaje sistema y push pairings |
| `shared/groupNotifications.ts` | Copy y `eventKind` pairings; `teamsPreset` en payload FCM |
| `shared/tarciAutoCatalogPairings.ts` | 50 mensajes auto (metadatos) |
| `shared/tarciChatAutomation.ts` | Rama pairings en decisión de mensajes |

## Flutter

| Área | Archivo |
|------|---------|
| Modelos | `group_models.dart` — `TeamsPreset`, `parseTeamsPreset` |
| Repositorio | `groups_repository*.dart` — create/list/detail con preset |
| UI copy | `teams_ui_copy.dart` |
| Wizard | `create_pairings_wizard_screen.dart`, ruta `/groups/dynamics/pairings/create` |
| Selector | `dynamics_selector_screen.dart` — tarjeta activa |
| Detalle | `teams_group_detail_screen.dart` — variant-aware |
| Home / join / chat | `groups_home_screen`, `join_by_code_screen`, `group_chat_screen` |
| Export | `team_result_text.dart`, `team_result_pdf.dart` |

## i18n

- Claves UI `pairings*` y `homeDynamicTypePairings` en 5 ARB.
- 50 mensajes `chatSystemAutoPairings*` generados con `scripts/gen-pairings-tarci-i18n.mjs`.
- `chat.system.pairingsCompleted.v1` en chat y `tarci_auto_chat_l10n.dart`.

## Scripts

```bash
node scripts/gen-pairings-tarci-i18n.mjs
cd src/flutter_app && flutter gen-l10n
cd src/firebase_functions && npm run build
```

## Commit sugerido

```
feat(pairings): modalidad Parejas sobre motor de Equipos con chat, push y exportaciones
```
