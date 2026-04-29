# DECISIONS_LOG — SecretSwap

Este registro captura decisiones técnicas cerradas para el proyecto.  
Formato recomendado: una entrada por decisión, con estado y rationale breve.

---

## D-0001 — Owner único en MVP

- **Fecha**: 2026-03-26
- **Estado**: Aceptada
- **Decisión**: Cada grupo tiene un único owner, responsable de gestión y operación del sorteo en el MVP.
- **Motivo**: Reducir complejidad de permisos y flujos, acelerando entrega del MVP.

## D-0002 — Sorteo solo backend

- **Fecha**: 2026-03-26
- **Estado**: Aceptada
- **Decisión**: El algoritmo de sorteo se ejecuta exclusivamente en backend (Cloud Functions).
- **Motivo**: Evitar manipulación por cliente, centralizar validaciones y garantizar integridad/idempotencia.

## D-0003 — Assignments privados por giver

- **Fecha**: 2026-03-26
- **Estado**: Aceptada
- **Decisión**: Las asignaciones se almacenan por giver y solo el giver puede leer su asignación.
- **Motivo**: Maximizar privacidad; minimizar exposición de información sensible.

## D-0004 — `requireDifferent` exige `subgroupId` en todos los miembros activos

- **Fecha**: 2026-03-26
- **Estado**: Aceptada
- **Decisión**: Si `requireDifferent` está activo, entonces **todo miembro activo** debe tener `subgroupId` definido.
- **Motivo**: Evitar sorteos inválidos o restricciones imposibles de evaluar.

## D-0005 — Rules versionadas e inmutables

- **Fecha**: 2026-03-26
- **Estado**: Aceptada
- **Decisión**: Las reglas se almacenan como versiones inmutables; cambios crean una nueva versión.
- **Motivo**: Trazabilidad y auditoría; los sorteos deben ser reproducibles por referencia a una versión.

## D-0006 — `executeDraw` con `idempotencyKey` obligatorio

- **Fecha**: 2026-03-26
- **Estado**: Aceptada
- **Decisión**: La operación `executeDraw` requiere `idempotencyKey` y debe ser idempotente.
- **Motivo**: Reintentos y fallos intermitentes no deben generar sorteos diferentes ni duplicados.

## D-0007 — `user_groups` como proyección

- **Fecha**: 2026-03-26
- **Estado**: Aceptada
- **Decisión**: `user_groups` existe como proyección derivada para lectura eficiente.
- **Motivo**: Mejorar UX (listar grupos por usuario) sin reestructurar lecturas; mantener fuente de verdad en membresías del grupo.

## D-0008 — Estados oficiales (grupo vs ejecución)

- **Fecha**: 2026-03-26
- **Estado**: Aceptada
- **Decisión**:
  - Estado agregado del grupo (`groups/{groupId}.drawStatus`): `idle | drawing | completed | failed`
  - Estado técnico de ejecución (`executions/{executionId}.status`): `running | success | failed`
- **Motivo**: Separar estado funcional agregado del grupo vs estado técnico de una ejecución, evitando ambigüedad y permitiendo reflejar fallos sin inventar “drawn” ambiguo.

## D-0009 — Contrato definitivo de `executeDraw` (MVP)

- **Fecha**: 2026-03-26
- **Estado**: Aceptada
- **Decisión**: `ExecuteDrawRequest` será `{ groupId, idempotencyKey }` y el backend usará siempre `groups/{groupId}.rulesVersionCurrent` como `rulesVersion` de la ejecución.
- **Motivo**: Minimiza complejidad y riesgos de desalineación en cliente; asegura que el sorteo use la versión vigente sin depender de lecturas previas del cliente.

## D-0010 — Modelo definitivo de miembros (MVP)

- **Fecha**: 2026-03-26
- **Estado**: Aceptada
- **Decisión**: El documento de miembro usa modelo rico: `role + memberState + nickname + subgroupId`.
- **Motivo**: Evita ambigüedad de estados, soporta owner vs member en datos, y mantiene `subgroupId` para reglas (`requireDifferent`) sin depender de campos implícitos.

## D-0011 — Modelo definitivo de assignments (MVP)

- **Fecha**: 2026-03-26
- **Estado**: Aceptada
- **Decisión**: `assignments/{giverUid}` usa snapshots explícitos (`receiverUid`, `receiverNicknameSnapshot`, `receiverSubgroupIdSnapshot`) en lugar de objeto `receiver { ... }`.
- **Motivo**: Mantiene el resultado inmutable/auditable aunque el receiver cambie su nickname/subgrupo; reduce ambigüedad y “mutaciones silenciosas” en el histórico del sorteo.

## D-0012 — Modelo de invitaciones por código (MVP)

- **Fecha**: 2026-03-26
- **Estado**: Aceptada
- **Decisión**:
  - Configuración por grupo: `groups/{groupId}/invites/current` con `codeHash`, `active`, `expiresAt?`, `rotatedAt`, `rotatedByUid`
  - Índice de lookup: `invite_codes/{codeHash}` → `{ groupId, active, expiresAt, createdAt }`
  - `joinGroupByCode` hace lookup por `codeHash` solo en backend; nunca se guarda el código en claro.
- **Motivo**: Lookup O(1) sin queries ni scans, evita persistir secretos en claro y permite rotación futura sin complejidad adicional.

