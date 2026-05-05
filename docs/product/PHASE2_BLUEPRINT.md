# PHASE2_BLUEPRINT — Tarci Secret

Blueprint técnico de Fase 2 para introducir participantes gestionados (sin app / niños sin móvil) con bajo riesgo y transición incremental.

## 1. Modelo Firestore definitivo para Fase 2A

### Colección nueva

- `groups/{groupId}/participants/{participantId}`

### Esquema de documento `Participant`

| Campo | Tipo | Required | Nullable | Default | Valores permitidos / reglas |
|---|---|---:|---:|---|---|
| `participantId` | string | Sí | No | `doc.id` | Debe coincidir con id del doc |
| `displayName` | string | Sí | No | — | `trim().length > 0`, max recomendado 80 |
| `participantType` | enum string | Sí | No | — | `app_member` \| `managed` \| `child_managed` |
| `linkedUid` | string | Condicional | Sí | `null` | Requerido para `app_member`; `null` en gestionados |
| `managedByUid` | string | Condicional | Sí | `null` | Opcional en `managed`; recomendado para `child_managed` |
| `roleInGroup` | enum string | Sí | No | `member` | `owner` \| `member` |
| `state` | enum string | Sí | No | `active` | `active` \| `removed` |
| `subgroupId` | string | No | Sí | `null` | Debe existir si viene informado |
| `deliveryMode` | enum string | Sí | No | según tipo | `inApp` \| `ownerDelegated` \| `verbal` \| `printed` |
| `canReceiveDirectResult` | boolean | Sí | No | derivado | `true` app members; `false` gestionados |
| `source` | enum string | Sí | No | — | `members_migrated` \| `managed_created` |
| `createdAt` | timestamp | Sí | No | serverTimestamp | Inmutable |
| `updatedAt` | timestamp | Sí | No | serverTimestamp | Actualizable |

### Valores permitidos

- `participantType`: `app_member` | `managed` | `child_managed`
- `roleInGroup`: `owner` | `member`
- `state`: `active` | `removed`
- `deliveryMode`: `inApp` | `ownerDelegated` | `verbal` | `printed`
- `source`: `members_migrated` | `managed_created`

## 2. Contratos de payload

## createManagedParticipant

### Input

- `groupId`
- `displayName`
- `participantType`
- `subgroupId` optional
- `deliveryMode`

### Validaciones

- caller autenticado;
- caller owner;
- group exists;
- `drawStatus` en `idle | failed | null`;
- `displayName` no vacío;
- `participantType` en `managed | child_managed`;
- `deliveryMode` en `verbal | printed | ownerDelegated`;
- `subgroupId` existe si viene informado.

### Output

- `participantId`
- `displayName`
- `participantType`
- `subgroupId`
- `deliveryMode`

## updateManagedParticipant

Campos editables pre-sorteo por owner:

- `displayName`
- `subgroupId`
- `deliveryMode`
- `state`

Validaciones:

- owner;
- grupo y participante existen;
- sorteo no completado;
- `subgroupId` válido si se informa.

## removeManagedParticipant

Soft delete:

- `state = removed`
- `updatedAt = serverTimestamp`

## 3. Reglas de deduplicación futura

Cuando convivan `members` y `participants`:

- si existe `participant` con `linkedUid == member.uid`, usar `participant`;
- si no existe, crear representación temporal desde `member`;
- `managed` y `child_managed` siempre vienen de `participants`.

Shape interno recomendado: `DrawParticipant`

- `participantId`
- `displayName`
- `linkedUid`
- `subgroupId`
- `participantType`
- `deliveryMode`
- `canReceiveDirectResult`

## 4. Preparación del sorteo en UI

### Fase 2A

- puede seguir contando `members` si el sorteo aún no integra `participants`.

### Fase 2B

- debe contar fuente unificada:
  - app members
  - managed active
  - child_managed active

Mostrar:

- participantes activos totales
- participantes con app
- participantes gestionados
- niños gestionados
- sin subgrupo

## 5. Cambios futuros en executeDraw (Fase 2C)

Objetivo:

- leer fuente unificada;
- hacer matching por `participantId`;
- respetar reglas de subgrupos;
- escribir assignments compatibles.

Shape recomendado de assignment:

- `giverParticipantId`
- `giverUid` nullable
- `giverDisplayNameSnapshot`
- `giverType`
- `receiverParticipantId`
- `receiverUid` nullable
- `receiverDisplayNameSnapshot`
- `receiverType`
- `receiverSubgroupIdSnapshot`
- `receiverSubgroupNameSnapshot`
- `deliveryMode`
- `canReceiverSeeDirectly`
- `createdAt`

Documento:

- para app members: mantener `assignments/{giverUid}` por compatibilidad;
- para managed: usar `assignments/{giverParticipantId}`.

## 6. Lectura de asignaciones

### MyAssignmentScreen actual

- sigue leyendo por uid autenticado.

### Futuro owner/delegado

- lectura solo de asignaciones delegadas de `managed/child_managed` con deliveryMode permitido;
- no lectura global de assignments.

## 7. Política objetivo de Firestore Rules

Sin escribir rules aún, política objetivo:

- owner crea/edita/remueve participants gestionados antes del sorteo;
- member normal no crea participants gestionados;
- `completed` bloquea cambios de participantes/subgrupos/reglas;
- assignments: solo propias o delegadas;
- no listado global de assignments.

## 8. UI mínima Fase 2A

En `GroupDetailScreen`, owner-only:

Sección:

- `Participantes sin app`

Botón:

- `Añadir participante sin app`

Formulario:

- nombre
- tipo:
  - adulto sin app
  - niño gestionado
- subgrupo
- entrega:
  - verbal
  - impresa
  - gestionada por mí

Lista:

- nombre
- etiqueta `Sin app` o `Niño`
- subgrupo
- modo de entrega

Miembros con app:

- pueden ver lista conjunta con etiqueta informativa;
- no deben ver datos sensibles.

## 9. Plan de implementación incremental

## 2A.1

Modelo, repository y callable para crear participants gestionados.

- Archivos probables:
  - `src/firebase_functions/src/shared/dtos.ts`
  - `src/firebase_functions/src/functions/createManagedParticipant.ts`
  - `src/firebase_functions/src/index.ts`
  - repositorio Flutter de grupos (fase de implementación)
- Riesgo: bajo/medio
- Prueba manual:
  - crear gestionado;
  - validar subgroup;
  - validar bloqueo en completed.
- Criterio de aceptación:
  - participant se crea con esquema válido.

## 2A.2

UI owner para listar/crear/editar/remover gestionados.

- Archivos probables:
  - `groups_repository.dart` / impl
  - `group_detail_screen.dart`
  - modelos de dominio
- Riesgo: medio
- Prueba manual:
  - owner gestiona participantes;
  - member no accede a acciones owner.
- Criterio de aceptación:
  - sección usable sin romper flujo actual.

## 2B

Preparación del sorteo cuenta participants + members.

- Archivos probables:
  - providers y pantallas de detalle
- Riesgo: medio
- Prueba manual:
  - conteos correctos por categoría.
- Criterio de aceptación:
  - tarjetas de preparación coherentes en casos mixtos.

## 2C

`executeDraw` usa fuente unificada.

- Archivos probables:
  - `executeDraw.ts`
  - utilidades de matching/normalización
- Riesgo: alto
- Prueba manual:
  - regresión con solo app members;
  - mixto app + managed;
  - reglas de subgrupo.
- Criterio de aceptación:
  - sorteo estable y assignments compatibles.

## 2D

Vista de asignaciones delegadas.

- Archivos probables:
  - endpoint/callable de lectura delegada
  - pantalla owner/delegado
- Riesgo: alto (privacidad)
- Prueba manual:
  - owner solo delegadas;
  - member no ve delegadas de otros.
- Criterio de aceptación:
  - privacidad preservada, sin lectura global.

## 10. Riesgos y decisiones pendientes

Decisiones críticas que no deben improvisarse:

- cuándo `participants` pasa a fuente principal;
- reglas exactas de deduplicación member/participant;
- obligatoriedad de `managedByUid` en `child_managed`;
- estrategia final de ids en assignments;
- alcance exacto de permisos delegados;
- bloqueo definitivo post-completed;
- plan de pruebas de regresión obligatorio antes de habilitar 2C.
