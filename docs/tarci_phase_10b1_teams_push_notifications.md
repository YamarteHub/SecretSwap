# Tarci Secret — Fase 10B.1 — Push «Equipos listos»

**Tipo:** extensión backend de la infra FCM de Fase 9B.3.  
**Referencia:** `docs/tarci_phase_9b3_push_notifications.md`

---

## 1. Objetivo

Notificar por push a miembros activos con app cuando `executeTeams` completa con **éxito nuevo**, con paridad respecto a Amigo Secreto y Sorteo.

---

## 2. Archivos tocados

| Archivo | Cambio |
|---------|--------|
| `src/firebase_functions/src/shared/groupNotifications.ts` | `dynamicType: teams`, copy 5 idiomas, `eventKind: teams_completed` |
| `src/firebase_functions/src/functions/executeTeams.ts` | `notifyGroupDynamicCompleted` tras transacción nueva |
| `docs/tarci_phase_9b3_push_notifications.md` | Sección Equipos |
| `docs/tarci_phase_10b1_teams_push_notifications.md` | Este documento |

**No se modificó Flutter** (navegación ya usa solo `groupId` → `GroupDetailScreen` despacha a Equipos).

---

## 3. Integración en `executeTeams`

1. Si `idempotencyKey` ya existe → **return temprano sin push**.
2. Transacción persiste `teamExecutions` + `teamStatus: completed`.
3. Tras commit: `notifyGroupDynamicCompleted({ dynamicType: "teams", triggeredByUid: uid })`.
4. Helper en `try/catch` interno → fallo FCM = `logger.warn`, **no** falla la callable.

---

## 4. Payload FCM

| Campo | Valor |
|-------|--------|
| `type` | `group_dynamic_completed` |
| `groupId` | ID del grupo |
| `dynamicType` | `teams` |
| `destination` | `group_detail` |
| `eventKind` | `teams_completed` |

Navegación: `/groups/{groupId}` → `TeamsGroupDetailScreen`.

---

## 5. Copy (no revela reparto)

| Locale | Título | Cuerpo (plantilla) |
|--------|--------|-------------------|
| **es** | ¡Los equipos ya están listos! | «{name}» ya tiene reparto. Entra para ver cómo quedaron los equipos. |
| **en** | Your teams are ready! | “{name}” has been arranged. Open Tarci Secret to see the teams. |
| **pt** | As equipas já estão prontas! | «{name}» já tem reparto. Entra para ver como ficaram as equipas. |
| **it** | Le squadre sono pronte! | «{name}» è stato ripartito. Apri Tarci Secret per vedere le squadre. |
| **fr** | Les équipes sont prêtes ! | « {name} » a été réparti. Ouvre Tarci Secret pour voir les équipes. |

Sin listado de integrantes ni equipos en la notificación.

---

## 6. Exclusión del actor

`triggeredByUid` = UID que ejecuta `executeTeams` → excluido de destinatarios (misma política 9B.3.1).

---

## 7. Validación técnica

| Comando | Resultado |
|---------|-----------|
| `npm run build` | (ejecutar tras commit) |

---

## 8. Checklist manual (Firebase real)

- [ ] A (owner) forma equipos; B (miembro) recibe push; A no.
- [ ] Tap en B abre detalle Equipos con resultado.
- [ ] Solo actor con token → sin error, log informativo.
- [ ] Token inválido → `enabled: false` en Firestore; `executeTeams` OK.
- [ ] Reintento misma `idempotencyKey` → sin segundo push.

---

*Fin Fase 10B.1.*
