# SECURITY_RULES_OVERVIEW — SecretSwap (MVP)

## Objetivo

Definir criterios de seguridad y acceso para el MVP, priorizando:

- privacidad de asignaciones,
- control del owner,
- y reglas inmutables y trazables.

## Principios

- **Autenticación obligatoria**: toda operación relevante requiere usuario autenticado.
- **Autorización por pertenencia**: acceso condicionado a pertenecer al grupo.
- **Mínimo privilegio**: cada usuario solo lee lo estrictamente necesario.
- **Integridad del sorteo**: solo backend puede crear asignaciones.

## Reglas de acceso (alto nivel)

### Grupos y miembros

- Lectura de grupo: solo miembros activos del grupo.
- Escritura de configuración/membresía: **solo owner** en MVP.

### Asignaciones (privacidad por giver)

- Documentos de asignación viven en:
  - `groups/{groupId}/executions/{executionId}/assignments/{giverUid}`
- **Lectura**: solo `giverUid` (el usuario autenticado coincide con el id del documento).
- **Escritura**: solo backend (Functions con privilegios administrativos) durante la ejecución del sorteo.

### Rules versionadas e inmutables

- Cada versión de reglas (`rules/{version}`) se crea una vez.
- Una vez creada, no se modifica; cualquier cambio crea una nueva versión.
- Las ejecuciones referencian explícitamente `rulesVersion`.

### `user_groups` como proyección

- `user_groups/{uid}/groups/{groupId}` es **proyección** (denormalización) para listar grupos por usuario.
- No es fuente de verdad; se deriva de `groups/{groupId}/members/{uid}`.
- Debe evitarse que el cliente la use para “autoconcederse” membresía.

## Controles específicos del MVP

- **`requireDifferent`**: si está activo, exige que todos los miembros activos tengan `subgroupId` definido (para validar la restricción).
- **`executeDraw` con `idempotencyKey`**: previene duplicación y estados inconsistentes ante reintentos.
- **Contrato de `executeDraw` (MVP)**: el backend usa `groups/{groupId}.rulesVersionCurrent`; el cliente no envía `rulesVersion` en el request.
- **Concurrencia**: `drawStatus` y `drawingLock` en `groups/{groupId}` reducen carreras y ejecuciones simultáneas.

