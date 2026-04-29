# PRODUCT_OVERVIEW — SecretSwap (MVP)

## Propósito

SecretSwap permite organizar un “amigo secreto” (intercambio de regalos) dentro de un grupo, ejecutando un sorteo que asigna a cada participante (giver) un destinatario (receiver).

## Alcance del MVP

- **Grupo con owner único** (una sola persona administra en MVP).
- Alta/baja de miembros por el owner (mecanismo exacto de invitación queda para implementación).
- Configuración de reglas del sorteo mediante un **RuleSet versionado**.
- Ejecución del sorteo **solo en backend**.
- Cada usuario ve **solo su propia asignación** (privacidad por giver).

## Principios del producto (MVP)

- **Privacidad por defecto**: el sistema minimiza quién puede ver asignaciones.
- **Trazabilidad**: reglas y sorteos quedan referenciados y auditables por versión.
- **Repetibilidad segura**: un sorteo debe ser idempotente ante reintentos.

## Historias de usuario (mínimas)

- Como **owner**, quiero crear un grupo y gestionar miembros para preparar el sorteo.
- Como **owner**, quiero definir reglas del sorteo y “congelarlas” para evitar cambios silenciosos.
- Como **owner**, quiero ejecutar el sorteo una vez y que reintentos no generen resultados distintos.
- Como **miembro**, quiero ver mi destinatario asignado, y que otros no puedan verlo.

## No objetivos (por ahora)

- Múltiples admins / roles avanzados.
- Chat, recordatorios automáticos, pagos, logística, catálogo.
- Sorteo ejecutado en el cliente.

