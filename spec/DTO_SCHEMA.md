# DTO_SCHEMA — SecretSwap (MVP)

Este documento define el esquema de datos (Firestore) y los DTOs/contratos mínimos para el MVP usando el **modelo oficial NUEVO**:

- `groups/{groupId}/rules/{version}`
- `groups/{groupId}.rulesVersionCurrent`
- `groups/{groupId}/executions/{executionId}`
- `groups/{groupId}/executions/{executionId}/assignments/{giverUid}` (privado por giver)
- `groups/{groupId}.drawStatus` y `groups/{groupId}.drawingLock`

No es implementación; es el **contrato** que guiará `src/flutter_app` y `src/firebase_functions`.

## 1. Convenciones

- `uid`: UID de Firebase Auth.
- `groupId`, `executionId`: IDs de documentos Firestore.
- `version`: versión de reglas (entero positivo, monotónico por grupo).
- `code`: código de invitación en claro (solo transita cliente -> backend; nunca se persiste).
- `codeHash`: hash del código normalizado (clave de lookup).
- Timestamps: `createdAt`, `updatedAt`, `lockedAt`, `completedAt` como timestamp servidor.
- `drawStatus`: estado agregado del sorteo a nivel de grupo.
- `memberState`: estado funcional del miembro dentro del grupo.

## 2. Firestore — Colecciones y documentos

### 2.1. `groups/{groupId}`

```json
{
  "groupId": "string",
  "name": "string",
  "ownerUid": "string",
  "lifecycleStatus": "active|archived",
  "rulesVersionCurrent": 1,
  "drawStatus": "idle|drawing|completed|failed",
  "drawingLock": {
    "executionId": "string",
    "idempotencyKey": "string",
    "rulesVersion": 1,
    "lockedByUid": "string",
    "lockedAt": "timestamp",
    "expiresAt": "timestamp|null"
  },
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

Reglas:

- `lifecycleStatus`:
  - `active`: grupo operativo.
  - `archived`: no permite nuevas uniones ni operaciones MVP.
- `rulesVersionCurrent` referencia la versión “vigente” (no implica mutabilidad de la versión).
- `drawingLock` puede ser `null`/ausente cuando no hay ejecución en curso.
- **`drawingLock` (esquema congelado)**:
  - **Obligatorios**: `executionId`, `idempotencyKey`, `rulesVersion`, `lockedByUid`, `lockedAt`
  - **Opcional**: `expiresAt` (recomendado para recuperación si el proceso muere; puede ser `null`)

### 2.2. `groups/{groupId}/members/{uid}`

```json
{
  "uid": "string",
  "role": "owner|member",
  "memberState": "active|left|removed",
  "nickname": "string",
  "subgroupId": "string|null",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

Semántica:

- `active`: participa normalmente (elegible para sorteo si cumple precondiciones).
- `left`: dejó el grupo voluntariamente; **puede reingresar** con invitación.
- `removed`: fue expulsado; **no puede unirse** con invitación en MVP.

### 2.3. `groups/{groupId}/rules/{version}` (inmutable)

```json
{
  "version": 1,
  "subgroupMode": "ignore|different",
  "exclusions": [],
  "createdByUid": "string",
  "createdAt": "timestamp"
}
```

Reglas:

- **Inmutable**: una versión no se edita una vez creada.
- `subgroupMode`:
  - `ignore`: no aplica restricciones por subgrupo.
  - `different`: exige `giver.subgroupId != receiver.subgroupId` y requiere `subgroupId` en miembros activos.
- `exclusions`: lista de exclusiones explícitas (MVP: `[]` por defecto; se reserva para evolución sin cambiar schema).

### 2.4. `groups/{groupId}/executions/{executionId}`

```json
{
  "executionId": "string",
  "groupId": "string",
  "rulesVersion": 1,
  "idempotencyKey": "string",
  "status": "running|success|failed",
  "memberCount": 0,
  "createdAt": "timestamp",
  "completedAt": "timestamp|null",
  "errorCode": "string|null"
}
```

Reglas:

- `idempotencyKey` es obligatorio y permite reintentos seguros.
- Una ejecución referencia exactamente una `rulesVersion`.

### 2.5. `groups/{groupId}/executions/{executionId}/assignments/{giverUid}` (privado por giver)

```json
{
  "giverUid": "string",
  "receiverUid": "string",
  "receiverNicknameSnapshot": "string",
  "receiverSubgroupIdSnapshot": "string|null",
  "rulesVersion": 1,
  "executionId": "string",
  "createdAt": "timestamp"
}
```

Reglas:

- Documento ID = `giverUid`.
- Lectura: solo `request.auth.uid == giverUid`.
- Escritura: solo backend.

### 2.6. `user_groups/{uid}/groups/{groupId}` (proyección)

```json
{
  "groupId": "string",
  "name": "string",
  "role": "owner|member",
  "isActiveMember": true,
  "updatedAt": "timestamp"
}
```

Notas:

- Proyección derivada para listar grupos por usuario.
- Fuente de verdad: `groups/{groupId}` y `groups/{groupId}/members/{uid}`.

### 2.7. `groups/{groupId}/invites/current` (MVP: un solo código activo)

```json
{
  "codeHash": "string",
  "active": true,
  "expiresAt": "timestamp|null",
  "rotatedAt": "timestamp",
  "rotatedByUid": "string"
}
```

Reglas:

- Nunca se guarda el código en claro, solo `codeHash`.
- `expiresAt` es opcional; si existe y está en el pasado, el invite es inválido.
- MVP: no historial; el doc `current` representa el único código vigente.

### 2.8. `invite_codes/{codeHash}` (índice de lookup)

```json
{
  "groupId": "string",
  "active": true,
  "expiresAt": "timestamp|null",
  "createdAt": "timestamp"
}
```

Reglas:

- Doc id = `codeHash`.
- Este índice existe para lookup O(1) sin queries ni scans.
- Solo backend debe leer/escribir esta colección.

## 3. DTOs de backend (MVP)

### 3.0. `CreateGroupRequest`

```json
{
  "name": "string",
  "nickname": "string"
}
```

### 3.0.1. `CreateGroupResponse`

```json
{
  "groupId": "string",
  "inviteCode": "string",
  "group": {
    "groupId": "string",
    "name": "string",
    "ownerUid": "string",
    "lifecycleStatus": "active|archived",
    "drawStatus": "idle|drawing|completed|failed",
    "rulesVersionCurrent": 1
  }
}
```

Reglas:

- `inviteCode` se retorna **solo** en la respuesta; nunca se persiste en Firestore.

### 3.1. `ExecuteDrawRequest`

```json
{
  "groupId": "string",
  "idempotencyKey": "string"
}
```

Reglas:

- `idempotencyKey` es **obligatorio**.
- El backend usa siempre `groups/{groupId}.rulesVersionCurrent` como `rulesVersion` de la ejecución.
- Si existe una ejecución previa con el mismo `{groupId, idempotencyKey}`, se retorna el mismo `executionId` (idempotencia).

### 3.2. `ExecuteDrawResponse`

```json
{
  "executionId": "string",
  "status": "running|success|failed",
  "rulesVersion": 1,
  "createdAt": "timestamp"
}
```

### 3.3. `GetMyAssignmentRequest`

```json
{
  "groupId": "string",
  "executionId": "string"
}
```

### 3.4. `MyAssignmentResponse`

```json
{
  "giverUid": "string",
  "executionId": "string",
  "rulesVersion": 1,
  "receiverUid": "string",
  "receiverNickname": "string",
  "receiverSubgroupId": "string|null"
}
```

### 3.5. `JoinGroupByCodeRequest`

```json
{
  "code": "string",
  "nickname": "string|null"
}
```

Reglas:

- El código en claro **solo** existe en el request; no se persiste en Firestore.
- El backend normaliza el código y calcula `codeHash` para hacer lookup.
- `nickname` es opcional; si no se envía, el backend usa un fallback (p. ej. `displayName` del token o `"Miembro"`).

### 3.6. `JoinGroupByCodeResponse`

```json
{
  "groupId": "string"
}
```

## 4. Validaciones mínimas (normativas)

- **Owner único (MVP)**:
  - `groups.ownerUid` define el owner y controla operaciones administrativas.
- **`subgroupMode`**:
  - Si `subgroupMode = different` en la `rulesVersion` usada, todos los miembros activos deben tener `subgroupId`.
  - La ejecución debe garantizar `giver.subgroupId != receiver.subgroupId`.
- **Idempotencia**:
  - `executeDraw` debe registrar y reutilizar `{groupId, idempotencyKey}` devolviendo el mismo `executionId`.

- **Invitaciones (join by code)**:
  - El backend debe hacer lookup en `invite_codes/{codeHash}` y validar `active` y expiración.
  - No permitir join si existe miembro con `memberState = removed`.
  - Permitir rejoin si existe miembro con `memberState = left` (se reactiva a `active`).

