# Tarci Secret — Fase 10B — Implementación dinámica «Equipos»

**Tipo:** implementación completa de runtime.  
**Referencia diseño:** `docs/tarci_phase_10a_teams_pairings_architecture.md`

---

## 1. Objetivo

Tercera dinámica pública: **Equipos** (`dynamicType: teams`), con reparto aleatorio equilibrado, resultado visible, share, correo preparado (`mailto:`) y PDF imprimible. Base preparada para preset **Parejas** (Fase 10C).

---

## 2. Decisiones aplicadas (10A)

| Decisión | Implementado |
|----------|--------------|
| `teamStatus` propio | Sí |
| Modos `team_count` y `team_size` | Sí |
| Algoritmo shuffle + round-robin | Sí (`crypto.randomInt`) |
| Snapshot en `teamExecutions` | Sí |
| `teams_manual` (no `raffle_manual`) | Sí |
| Join/bloqueos simétricos a Sorteo | Sí |
| Sin chat | Sí |
| Sin push (10B.1) | Sí |
| Máx. 100 elegibles | Sí (`TEAMS_MAX_ELIGIBLE`) |
| CTA «Formar equipos» / estado «Equipos listos» | Sí (i18n) |

---

## 3. Modelo Firestore

### `groups/{groupId}`

- `dynamicType: "teams"`
- `resultVisibility: "public_to_group"`
- `teamStatus`, `groupingMode`, `requestedTeamCount` | `requestedTeamSize`
- `ownerParticipatesInTeams`
- `lastTeamExecutionId`, `lastTeamCompletedAt`
- `drawStatus` / `raffleStatus` en `idle` (compatibilidad rules/UI)

### `groups/{groupId}/teamExecutions/{executionId}`

- `teamsSnapshot[]` con `teamIndex`, `teamLabel`, `members[]`
- `idempotencyKey`, `status`, contadores

### Participantes sin app

- `participantType: "teams_manual"`

---

## 4. Cloud Functions nuevas

| Callable | Archivo |
|----------|---------|
| `createTeamsGroup` | `createTeamsGroup.ts` |
| `executeTeams` | `executeTeams.ts` |
| `createTeamsManualParticipant` | `teamsManualParticipants.ts` |
| `updateTeamsManualParticipant` | idem |
| `removeTeamsManualParticipant` | idem |

## 5. Functions modificadas

- `joinGroupByCode.ts` — ramas `teams` (in progress / resolved)
- `rotateInviteCode.ts` — `TEAMS_ROTATE_LOCKED`
- `deleteGroup.ts` — borra `teamExecutions`
- `executeDraw.ts` — rechaza `teams`
- `dtos.ts`, `firestorePaths.ts`, `index.ts`

---

## 6. Algoritmo

1. Pool elegibles (members activos + `teams_manual`, owner opcional).
2. Deduplicar por `participantId`.
3. Validar ≥2 y ≤100.
4. `numTeams` = `requestedTeamCount` o `ceil(n / requestedTeamSize)`.
5. Fisher-Yates con `randomInt`.
6. Round-robin: `teams[i % numTeams].push(participant)`.
7. Persistir `teamsSnapshot` y `teamStatus: completed`.

---

## 7. Flutter

### Feature

```
lib/features/teams/
  presentation/screens/
    create_teams_wizard_screen.dart
    teams_group_detail_screen.dart
  services/
    team_result_text.dart
    team_result_pdf.dart
```

### Integración

- `group_models.dart` — `TarciDynamicType.teams`, `TeamStatus`, snapshots
- `groups_repository` + impl + stub
- `groupTeamStatusStreamProvider`
- `GroupDetailScreen` → `TeamsGroupDetailScreen`
- `DynamicsSelectorScreen` — card Equipos activa
- `groups_home_screen` — chips tipo/estado
- `join_by_code_screen` — modal equipos
- `app_router` — `/groups/dynamics/teams/create`

### Share / email / PDF

- **Share:** `share_plus` + `TeamResultText.buildShareBody`
- **Email:** `ManagedDeliveryLauncher.openEmailComposer` + texto plano
- **PDF:** `pdf` + `printing` — `TeamResultPdf` (etiqueta `teamsUnitLabel` preparada para Parejas en 10C)

---

## 8. Firestore rules

```text
match /teamExecutions/{executionId} {
  allow read: if isActiveMember(groupId);
  allow write: if false;
}
```

---

## 9. i18n

Claves nuevas en `app_es/en/pt/it/fr.arb` (wizard, detalle, share, email, PDF, errores Functions, join).

---

## 10. Validación técnica

| Comando | Resultado |
|---------|-----------|
| `flutter pub get` | OK |
| `flutter gen-l10n` | OK |
| `flutter analyze` | OK (sin issues) |
| `npm run build` (functions) | OK |

---

## 11. Pendiente

| Fase | Contenido |
|------|-----------|
| **10B.1** | Push FCM «Equipos listos» (`teams_completed`) |
| **10C** | Tarjeta Parejas + preset `team_size=2` + validación par |

---

## 12. Checklist manual (Stan)

- [ ] Crear equipos por N equipos y por K personas
- [ ] Owner participa sí/no + apodo
- [ ] Join, manuales, reactividad roster
- [ ] Formar equipos (≥2), equilibrio visual
- [ ] Bloqueo post-formación
- [ ] Share, mailto, PDF preview/share
- [ ] Dashboard chips + historial
- [ ] Regresión AS + Sorteo
- [ ] ES / EN / PT / IT / FR

---

*Fin documento Fase 10B.*
