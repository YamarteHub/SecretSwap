# Fase 12 — Retención automática y privacidad

## Objetivo

Profesionalizar el modelo de conservación de datos: las dinámicas completadas se eliminan automáticamente **90 días** después de su fecha efectiva de cierre, con transparencia en UI y copy de privacidad.

## Decisión de producto

```text
retentionBasisAt =
  si existe eventDate y eventDate > completedAt → eventDate
  si no → completedAt

retentionDeleteAt = retentionBasisAt + 90 días
```

| Dinámica | Condición de completado |
|----------|-------------------------|
| Amigo Secreto | `drawStatus == completed` |
| Sorteo | `raffleStatus == completed` |
| Equipos / Parejas / Duelos | `teamStatus == completed` |

La retención se fija **solo en la primera finalización real** (no en reintentos idempotentes ni repair que dejen el grupo ya completado).

## Campos Firestore (`groups/{groupId}`)

| Campo | Obligatorio | Descripción |
|-------|-------------|-------------|
| `retentionPolicyVersion` | Sí | `1` |
| `retentionBasisAt` | Sí | Timestamp base |
| `retentionDeleteAt` | Sí | Timestamp de borrado programado |
| `retentionScheduledAt` | No | Cuando se calculó la retención |
| `retentionLastEvaluatedAt` | No | Última pasada del scheduler |
| `retentionStatus` | No | `scheduled` \| `deleting` \| `delete_failed` |
| `retentionDeleteFailedAt` | No | Último fallo de purge |
| `retentionDeleteFailureCount` | No | Contador de fallos |

## Backend

| Archivo | Rol |
|---------|-----|
| `shared/retention.ts` | Cálculo de fechas y helpers de backfill |
| `shared/deleteGroupTree.ts` | Borrado completo del árbol (extraído de `deleteGroup`) |
| `functions/deleteGroup.ts` | Usa `purgeGroupFully` (owner manual) |
| `functions/purgeExpiredCompletedGroups.ts` | Scheduler diario 04:30 UTC |
| `functions/executeDraw.ts` | Escribe retención al completar sorteo |
| `functions/executeRaffle.ts` | Escribe retención al resolver sorteo |
| `functions/executeTeams.ts` | Escribe retención (standard / pairings / duels) |

### Scheduler `purgeExpiredCompletedGroups`

1. **Backfill** (hasta 40 grupos/run): completados sin `retentionDeleteAt` → calcula y escribe campos (no borra en la misma pasada salvo que ya estén vencidos).
2. **Purge** (hasta 50 grupos/run): `retentionDeleteAt <= now` → `purgeGroupFully`.

Fallos: marca `delete_failed`, incrementa contador, continúa el batch.

### Grupos antiguos

No hay script callable separado: el **backfill del scheduler** cubre grupos pre-fase 12 en emulador/producción de forma segura y gradual.

### Validación en emulador

El scheduler **no se ejecuta solo** en el emulador local. Opciones:

- Desplegar y esperar Cloud Scheduler en staging.
- Invocar manualmente la función programada desde Firebase Console / gcloud.
- Completar un grupo con `retentionDeleteAt` en el pasado (solo dev) y ejecutar el job.

## Flutter

| Área | Cambio |
|------|--------|
| `group_models.dart` | `retentionDeleteAt` en `GroupDetail` |
| `groups_repository_impl.dart` | Lectura del campo |
| `retention_auto_delete_notice.dart` | Widget de aviso en detalle |
| Detalle SS / Sorteo / Equipos-Parejas-Duelos | Aviso si hay fecha real |
| `about_tarci_screen.dart` | Sección «Retención limitada» + privacidad ampliada |

**Sin fecha:** no se muestra aviso inventado (grupos en migración hasta el backfill).

## i18n

Claves: `retentionAutoDeleteNotice`, `retentionAutoDeleteBody`, `aboutRetentionTitle`, `aboutRetentionBody`, `aboutSectionPrivacyBody` (ampliado) en ES/EN/PT/IT/FR.

## Qué NO hace esta fase

- Borrado por inactividad de grupos no completados
- Papelera / recuperación
- Opt-out del borrado
- Emails o push de aviso previo
- Panel admin de retención

## Checklist manual (Stan)

- [ ] A–C: Completar SS / Sorteo / Equipos-Parejas-Duelos → `retentionDeleteAt` en Firestore + aviso en detalle
- [ ] D: `eventDate` futura → `retentionDeleteAt = eventDate + 90d`
- [ ] E: Sin `eventDate` → `completedAt + 90d`
- [ ] F: `deleteGroup` manual sigue funcionando
- [ ] G: Purge de grupo vencido (dev) borra árbol + `user_groups` + `invite_codes`
- [ ] H: Fallo simulado no detiene todo el batch
- [ ] I–J: About + 5 idiomas

## Riesgos residuales

- Grupos completados sin timestamp de cierre (`last*CompletedAt`) no reciben backfill hasta tener fecha.
- Purge masivo en producción inicial: limitado a 50/run.
- Índice compuesto no requerido para query simple por `retentionDeleteAt`.

## Commit sugerido

```
feat(retention): eliminar dinamicas completadas tras 90 dias y transparentar privacidad
```
