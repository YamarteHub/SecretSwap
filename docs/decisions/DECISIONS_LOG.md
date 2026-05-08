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

## D-0013 — El MVP prioriza completar amigo secreto

- **Fecha**: 2026-05-08
- **Estado**: Aceptada
- **Decisión**: El MVP prioriza cerrar de extremo a extremo la dinámica de amigo secreto antes de cualquier otra dinámica o expansión funcional.
- **Motivo**: Asegurar entrega útil, estable y publicable sin dispersar esfuerzo en alcance prematuro.

## D-0014 — No reescritura total del proyecto

- **Fecha**: 2026-05-08
- **Estado**: Aceptada
- **Decisión**: No se reescribe el proyecto desde cero en esta fase.
- **Motivo**: Preservar el núcleo funcional ya existente y reducir riesgo de retrasos/regresiones.

## D-0015 — No nuevas features fuera del flujo core

- **Fecha**: 2026-05-08
- **Estado**: Aceptada
- **Decisión**: No se implementan nuevas features fuera del flujo core del MVP actual.
- **Motivo**: Evitar crecimiento descontrolado del alcance y proteger la estabilidad de entrega.

## D-0016 — Alcance funcional congelado del MVP

- **Fecha**: 2026-05-08
- **Estado**: Aceptada
- **Decisión**: El alcance funcional del MVP queda limitado a:
  - Crear grupo.
  - Unirse por código.
  - Gestionar participantes con app.
  - Añadir participantes sin app.
  - Añadir niños gestionados.
  - Crear subgrupos.
  - Asignar participantes a subgrupos.
  - Configurar regla de sorteo: `ignore`, `preferDifferent`, `requireDifferent`.
  - Ejecutar sorteo desde backend.
  - Mostrar a cada usuario solo su asignación.
  - Mostrar al responsable solo resultados gestionados.
  - Permitir re-sortear cuando haga falta.
  - Mantener privacidad.
  - Mantener UI clara, cálida, simple y sin mezcla de idiomas.
- **Motivo**: Congelar alcance para cerrar un MVP pequeño, útil y funcional sin convertir el proyecto en un mega sistema.

## D-0017 — Fuera de alcance explícito en MVP

- **Fecha**: 2026-05-08
- **Estado**: Aceptada
- **Decisión**: Quedan fuera de alcance del MVP actual:
  - wishlist
  - chat
  - pistas
  - notificaciones push reales
  - WhatsApp/email automático
  - multi-organizador
  - historial complejo
  - monetización
  - nuevas dinámicas
  - torneos
  - equipos
  - pádel
  - arquitectura excesivamente compleja
  - reescritura completa del proyecto
- **Motivo**: Mantener foco en entrega incremental del flujo core, minimizando deuda y desviaciones.

## D-0018 — Privacidad de lectura por rol funcional

- **Fecha**: 2026-05-08
- **Estado**: Aceptada
- **Decisión**:
  - Cada usuario ve solo su asignación.
  - El responsable ve solo resultados gestionados.
- **Motivo**: Reforzar privacidad del sorteo y visibilidad mínima necesaria por tipo de actor.

## D-0019 — Separación usuario/participante

- **Fecha**: 2026-05-08
- **Estado**: Aceptada
- **Decisión**: Se mantiene la separación conceptual y funcional entre usuario autenticado y participante gestionado.
- **Motivo**: Soportar casos con participantes sin app y niños gestionados sin romper privacidad ni trazabilidad.

## D-0020 — Mínimo oficial para ejecutar sorteo

- **Fecha**: 2026-05-08
- **Estado**: Aceptada
- **Decisión**: El mínimo oficial para ejecutar sorteo será de 3 participantes efectivos.
- **Motivo**: Garantizar viabilidad práctica del juego y coherencia de UX en casos reales.

## D-0021 — `requireDifferent` exige subgrupo en todos los efectivos

- **Fecha**: 2026-05-08
- **Estado**: Aceptada
- **Decisión**: Si `requireDifferent` está activo, todos los participantes efectivos deben tener subgrupo asignado.
- **Motivo**: Evitar ejecuciones inválidas e imposibilidad de cumplir restricciones del sorteo.

## D-0022 — `user_groups` no es fuente de verdad

- **Fecha**: 2026-05-08
- **Estado**: Aceptada
- **Decisión**: `user_groups` se mantiene como proyección de lectura y no como fuente de verdad.
- **Motivo**: Proteger integridad del dominio manteniendo la verdad en la membresía del grupo.

## D-0023 — Dinámicas futuras como visión, no implementación actual

- **Fecha**: 2026-05-08
- **Estado**: Aceptada
- **Decisión**: Las dinámicas futuras se mantienen como visión de producto y no como implementación del MVP actual.
- **Motivo**: Preservar foco, reducir riesgo y cerrar publicación del MVP core.

