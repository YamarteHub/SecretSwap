# SPEC — SecretSwap (MVP)

## 1. Resumen

SecretSwap gestiona grupos para realizar un sorteo tipo “amigo secreto”, generando una asignación 1:1 entre miembros activos del grupo (cada giver obtiene exactamente un receiver), bajo un conjunto de reglas versionadas e inmutables.

## 2. Objetivos del MVP

- Permitir crear y administrar un grupo (owner único).
- Mantener miembros activos y sus atributos mínimos para reglas.
- Definir reglas (RuleSet) con **versionado e inmutabilidad** (`rules/{version}`).
- Ejecutar sorteo **solo en backend**.
- Entregar asignaciones con **privacidad por giver**.
- Soportar reintentos seguros con **idempotencia** (`idempotencyKey`).

### 2.1. Alcance simplificado del MVP

La documentación técnica de SecretSwap existe para guiar desarrollo y operación, pero la implementación inmediata debe ser incremental y enfocada en cerrar bien el flujo de amigo secreto.

Para este MVP, el alcance queda congelado al núcleo funcional definido en `docs/product/MVP_SCOPE.md`; no debe derivar en una arquitectura innecesariamente grande en esta fase.

Toda propuesta de cambio de modelo o backend debe justificarse por:

- un bug real detectado, o
- una necesidad directa del MVP actual.

## 3. Suposiciones y decisiones cerradas (referencia)

Ver `docs/decisions/DECISIONS_LOG.md` (D-0001 en adelante).

## 4. Terminología

- **Owner**: usuario que administra el grupo en MVP.
- **Miembro activo**: miembro con `memberState = active`, elegible para el sorteo.
- **RuleSet / rulesVersion**: configuración de reglas del sorteo, guardada como versión inmutable (`rules/{version}`).
- **Execution**: ejecución del sorteo (resultado materializado) en `groups/{groupId}/executions/{executionId}`.
- **Assignment**: documento privado por giver que indica su receiver.
- **Projection**: datos denormalizados derivados para lecturas eficientes (p. ej. `user_groups`).

## 5. Reglas del sorteo (MVP)

### 5.1. Restricciones generales

- No se permite auto-asignación: `giverUid != receiverUid`.
- Cada miembro activo aparece **exactamente una vez** como giver y **exactamente una vez** como receiver.

### 5.2. Reglas por subgrupo (`subgroupMode`)

La versión de reglas (`groups/{groupId}/rules/{version}`) define `subgroupMode`:

- `ignore`: no aplica restricciones por subgrupo.
- `preferDifferent`: intenta priorizar asignaciones entre subgrupos distintos, pero no bloquea el sorteo si no se puede cumplir al 100%.
- `requireDifferent`: exige que giver y receiver pertenezcan a subgrupos distintos.

Si `subgroupMode = requireDifferent`:

- Todo miembro activo debe incluir `subgroupId`.
- La asignación debe cumplir: `giver.subgroupId != receiver.subgroupId`.

## 6. Flujos funcionales (MVP)

### 6.1. Gestión de grupo (owner)

- Crear grupo con owner único.
- Agregar/quitar miembros (o activar/desactivar) por owner.
- Mantener por miembro: `nickname`, `memberState`, `role` y opcionalmente `subgroupId`.
- El grupo mantiene `lifecycleStatus` (`active|archived`). En MVP, `archived` bloquea uniones por código.

### 6.1.1. Unirse a un grupo por código (MVP)

Operación: `joinGroupByCode`

Entrada mínima (cliente → backend):

- `code` (en claro, **nunca** se persiste)
- `nickname` (opcional; fallback a `displayName` o `"Miembro"`)

Modelo de datos (ver `spec/DTO_SCHEMA.md`):

- Configuración por grupo: `groups/{groupId}/invites/current`
- Índice de lookup: `invite_codes/{codeHash}`

Flujo paso a paso:

1. El cliente envía `code` + `nickname`.
2. El backend normaliza el `code` y calcula `codeHash` (p. ej. SHA-256 del código normalizado).
3. Lookup en `invite_codes/{codeHash}`.
4. Valida `active = true` y `expiresAt` (si existe).
5. Obtiene `groupId` desde el índice.
6. Valida estado del grupo (MVP: no permitir join si `drawStatus = drawing`).
7. Crea o actualiza el member:
   - Si no existe: crea `groups/{groupId}/members/{uid}` con `role = member`, `memberState = active`, `nickname`, `subgroupId = null`.
   - Si existe con `memberState = left`: permite rejoin → setea `memberState = active` y actualiza `nickname` si aplica.
   - Si existe con `memberState = removed`: **no permitir join**.
8. Actualiza proyección `user_groups/{uid}/groups/{groupId}`.

Reglas importantes:

- El `code` en claro nunca se guarda en Firestore; solo se guarda `codeHash`.
- El lookup en `invite_codes` es **solo backend** (no desde cliente).
- MVP: solo un código activo por grupo (`invites/current`), sin historial y sin múltiples invitaciones.

### 6.2. Versionado de reglas

- El owner crea una nueva versión de reglas (RuleSet) cuando desea cambiar configuración.
- Una vez creada una versión, no se modifica.
- El grupo mantiene `rulesVersionCurrent` para indicar la versión vigente.
- Cada ejecución referencia explícitamente `rulesVersion`.

### 6.3. Ejecución del sorteo (backend)

Operación: `executeDraw`

Entrada mínima:

- `groupId`
- `idempotencyKey` (**obligatorio**)

Comportamiento:

- Valida precondiciones:
  - suficientes participantes efectivos (mínimo 3),
  - si `subgroupMode = requireDifferent`, todos tienen `subgroupId`,
  - factibilidad de restricciones (si no hay solución, falla sin parcialidades).
- Ejecuta el algoritmo en backend.
- Materializa un `execution` y los `assignments` bajo esa ejecución.
- La ejecución usa como `rulesVersion` el valor actual de `groups/{groupId}.rulesVersionCurrent`.
- Idempotencia:
  - Si se reintenta con el mismo `idempotencyKey` para el mismo `groupId`, retorna el mismo `executionId`/resultado (sin regenerar).
- Estado agregado en grupo:
  - `drawStatus` refleja el estado actual (`idle|drawing|completed|failed`).
  - `drawingLock` evita ejecuciones concurrentes y vincula la ejecución en curso.

#### 6.3.1. `drawingLock` (esquema y ciclo de vida — congelado)

Ubicación: `groups/{groupId}.drawingLock`

Campos:

- **Obligatorios**:
  - `executionId`
  - `idempotencyKey`
  - `rulesVersion` (la versión efectiva usada por la ejecución)
  - `lockedByUid` (uid del usuario que disparó `executeDraw` en MVP)
  - `lockedAt`
- **Opcional**:
  - `expiresAt` (timestamp o `null`; recomendado para recuperación)

Creación:

- Se crea **al inicio** de `executeDraw`, dentro de una transacción.
- En ese mismo paso el grupo pasa a `drawStatus = drawing`.
- `rulesVersion` se fija al valor actual de `groups/{groupId}.rulesVersionCurrent`.

Limpieza:

- Se limpia (se elimina o se setea a `null`) al finalizar la ejecución en estado terminal (success/failed).

Éxito:

- Se escriben assignments y se marca `executions/{executionId}.status = success`.
- El grupo queda en `drawStatus = completed`.
- Se limpia `drawingLock`.

Fallo:

- Se marca `executions/{executionId}.status = failed` y se registra `errorCode` si aplica.
- El grupo queda en `drawStatus = failed`.
- Se limpia `drawingLock`.

Retry idempotente:

- Si `drawStatus = drawing` y existe `drawingLock` con el **mismo** `idempotencyKey`, `executeDraw` debe ser idempotente y **retornar el mismo `executionId`** sin crear nueva ejecución ni modificar el lock.
- Si el grupo no está en `drawing`, el backend debe buscar una ejecución existente por `{groupId, idempotencyKey}` y retornarla si existe; si no existe, procede a crear una nueva ejecución (y su lock).

### 6.4. Lectura de asignación (miembro)

- Un usuario autenticado puede leer **solo** su documento de asignación como giver.
- No se expone el conjunto completo de asignaciones al cliente.

## 7. Modelo de datos y contratos

El modelo (Firestore + DTOs de funciones) está definido en `spec/DTO_SCHEMA.md`.

## 8. Proyección `user_groups`

- Existe una proyección por usuario para listar grupos eficientemente.
- Es derivada de la membresía real del grupo.
- Debe mantenerse consistente mediante backend (o triggers), y no debe permitir escalamiento de privilegios desde cliente.

## 9. Requisitos no funcionales

- **Seguridad**: reglas de acceso coherentes con privacidad por giver (ver `docs/security/SECURITY_RULES_OVERVIEW.md`).
- **Trazabilidad**: cada ejecución referencia `rulesVersion` y registra timestamps/metadata.
- **Idempotencia**: `executeDraw` debe ser seguro ante reintentos.

