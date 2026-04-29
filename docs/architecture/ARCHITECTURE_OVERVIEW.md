# ARCHITECTURE_OVERVIEW — SecretSwap (MVP)

## Resumen

Arquitectura orientada a Firebase:

- **Cliente**: Flutter (`src/flutter_app`)
- **Backend**: Firebase Cloud Functions (`src/firebase_functions`)
- **Identidad**: Firebase Authentication
- **Persistencia**: Cloud Firestore

El sorteo se ejecuta exclusivamente en backend para preservar integridad, privacidad y control.

## Componentes

### Flutter App

- Autenticación (Firebase Auth)
- Gestión de grupos (vistas del owner y del miembro)
- Lectura de “mi asignación” (privada por giver)

### Firebase Functions (API)

Funciones HTTP/Callable (a definir en implementación) con contratos documentados en `spec/DTO_SCHEMA.md`.

Puntos clave:

- `executeDraw` exige `idempotencyKey` obligatorio.
- `executeDraw` usa siempre `groups/{groupId}.rulesVersionCurrent` como `rulesVersion` de la ejecución (MVP).
- El backend materializa asignaciones en Firestore con un modelo que soporta reglas y auditoría.

### Firestore (modelo lógico)

Colecciones sugeridas (ver detalle en `spec/DTO_SCHEMA.md`):

- `groups/{groupId}`
- `groups/{groupId}/members/{uid}`
- `groups/{groupId}/rules/{version}` (inmutables)
- `groups/{groupId}/executions/{executionId}`
- `groups/{groupId}/executions/{executionId}/assignments/{giverUid}` (privado por giver)
- `user_groups/{uid}/groups/{groupId}` (proyección)

## Invariantes arquitectónicos (MVP)

- **Owner único** por grupo.
- **Sorteo en backend** (no se permite cálculo de asignaciones en cliente).
- **Asignaciones privadas por giver** (cada giver solo accede a su documento).
- **Rules versionadas e inmutables**: cada ejecución referencia una versión concreta (`rulesVersion`).
- **Idempotencia**: `executeDraw` no puede generar dos ejecuciones distintas ante reintentos con la misma clave.
- **Estado y lock en `groups`**: `drawStatus` y `drawingLock` gobiernan ejecución en curso / concurrencia.
- **Proyección `user_groups`**: derivada para lectura eficiente; no es fuente de verdad.

