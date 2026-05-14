# Tarci Secret — Fase 9B — Dinámica pública «Sorteo» (`simple_raffle`)

**Tipo:** implementación de producto (backend Firebase, reglas Firestore, app Flutter, i18n).  
**Documento:** `docs/tarci_phase_9b_raffle_implementation.md` (este archivo).  
**Relación con 9A:** la Fase 9A (`docs/tarci_phase_9a_multi_dynamics_architecture.md`) define el marco multidinámica; la 9B materializa la primera dinámica adicional **sin** alterar el contrato semántico del Amigo Secreto.

---

## 1. Objetivo de producto

- Ofrecer un **sorteo simple con resultado público al grupo** (`resultVisibility: public_to_group`), distinto del sorteo secreto 1:1 con asignaciones privadas.
- Reutilizar el contenedor `groups/{groupId}` (miembros, códigos de invitación, fecha de evento, chat donde aplique), pero con **estado propio** para la fase del sorteo abierto y **subcolección propia** de ejecuciones.
- Mantener **Amigo Secreto** (`dynamicType: secret_santa`, `drawStatus`, `executions`, assignments, wishlist gestionada, participantes gestionados con semántica de regalo) **intacto** en rutas y comportamiento por defecto.

---

## 2. Modelo de datos (Firestore)

### 2.1 Documento de grupo

Campos relevantes añadidos o usados en sorteo:

| Campo | Valor (sorteo) | Notas |
|--------|------------------|--------|
| `dynamicType` | `simple_raffle` | Selector de rama en join, rotate, draw, managed CRUD, mensajería. |
| `resultVisibility` | `public_to_group` | Coherente con resultado visible para miembros. |
| `raffleStatus` | `idle` \| `drawing` \| `completed` \| `failed` | Paralelo conceptual a `drawStatus` pero **solo** para esta dinámica. |
| `lastRaffleExecutionId` / `lastRaffleCompletedAt` | según ejecución | Para dashboard e historial. |

Amigo Secreto sigue usando `drawStatus`, `rulesVersionCurrent`, `executions/{executionId}` y asignaciones bajo la ruta existente.

### 2.2 Subcolección `raffleExecutions/{executionId}`

- Cada ejecución guarda metadatos del sorteo, `winnersSnapshot` (lista ordenada de ganadores con `participantId`, `displayName`, `sourceType`, `memberUid` opcional) e **`idempotencyKey`** para idempotencia de red.
- **Índices:** la consulta de idempotencia es `where('idempotencyKey', '==', key)` sobre la subcolección de un grupo concreto; Firestore indexa por defecto campos escalares en subcolecciones para filtros de igualdad — **no** se añadió entrada explícita en `firestore.indexes.json` (misma situación que consultas análogas en `executions` si las hubiera con un solo `==`).

### 2.3 Participantes manuales

- Tipo de participante **`raffle_manual`** en la subcolección unificada de participantes del grupo (misma colección que usa el backend para unificar miembros + invitados; **sin** `deliveryMode` ni semántica de «gestionado para regalo»).
- Callables dedicadas: crear / actualizar / borrar display name (ver §3).

---

## 3. Cloud Functions (resumen)

Rutas compartidas en `src/firebase_functions/src/shared/firestorePaths.ts` (`raffleExecutionsCol`, `raffleExecutionDoc`, `participantsCol`).

| Función | Rol |
|---------|-----|
| `createRaffleGroup` | Crea grupo sorteo + owner + invite + estado inicial `raffleStatus: idle`. |
| `executeRaffle` | Transacción: elegibilidad, Fisher-Yates con `crypto.randomInt`, escritura de ejecución, actualización de grupo; idempotencia por `idempotencyKey` en `raffleExecutions`. |
| `createRaffleManualParticipant` / `updateRaffleManualParticipant` / `removeRaffleManualParticipant` | CRUD de filas `raffle_manual`. |

**Compatibilidad y guardas:**

- `executeDraw` rechaza `simple_raffle` (`DRAW_NOT_SUPPORTED_FOR_DYNAMIC`).
- Participantes **gestionados** (create/update/remove managed) rechazan grupos `simple_raffle`.
- `joinGroupByCode` ramifica por `dynamicType`; cierre de invitaciones cuando el sorteo está resuelto (`RAFFLE_RESOLVED_INVITES_CLOSED`); estado `RAFFLE_IN_PROGRESS` durante `drawing`.
- `rotateInviteCode` bloquea si `raffleStatus` es `drawing` o `completed` (`RAFFLE_ROTATE_LOCKED`).
- `deleteGroup` elimina también `raffleExecutions` tras borrar `executions` (y el resto del patrón existente).
- `sendGroupChatMessage`, `getWishlist`, `setWishlist`, `getManagedAssignments` incluyen guardas explícitas para no aplicar semántica de Amigo Secreto al sorteo donde no corresponde.

DTOs Zod en `src/firebase_functions/src/shared/dtos.ts` para payloads de sorteo y manuales.

---

## 4. Firestore Security Rules

- Lectura de `groups/{groupId}/raffleExecutions/{executionId}` para **miembros activos** del grupo (alineado con visibilidad pública al grupo post-sorteo).
- Escritura de `raffleExecutions` denegada a clientes (solo backend).

El archivo `firestore.rules` en la raíz del repo fue actualizado en esta fase.

---

## 5. Flutter

### 5.1 Dominio y datos

- `group_models.dart`: `TarciDynamicType`, `ResultVisibility`, `RaffleStatus`, modelos de ejecución / ganadores / resumen, `GroupParticipantType.raffleManual`, campos extra en `GroupSummary` / `GroupDetail`.
- `groups_repository.dart` + `groups_repository_impl.dart`: `createRaffleGroup`, `executeRaffle`, CRUD manual, `watchGroupRaffleStatus`, detalle con query de participantes adecuada al tipo, `listMyGroups` con `dynamicType` / `raffleStatus` / `lastRaffleCompletedAt`.
- `groups_repository_stub.dart` y `providers.dart` (`groupRaffleStatusStreamProvider`) alineados.

### 5.2 Navegación y pantallas

- `app_router.dart`: rutas selector de dinámica, wizard de sorteo, detalle con `GroupDetailRouteExtra` (p. ej. `initialInviteCode`).
- `group_detail_screen.dart`: si `dynamicType == simpleRaffle`, delega en **`RaffleGroupDetailScreen`**; en caso contrario mantiene el cuerpo clásico de Amigo Secreto.
- Nuevos: `dynamics_selector_screen.dart`, `create_raffle_wizard_screen.dart`, `raffle_group_detail_screen.dart`.
- `groups_home_screen.dart`: CTA hacia selector de dinámicas; tarjetas con chip de **tipo** (sorteo vs amigo secreto) y chip de **estado** unificado vía `_homeDynamicStatusChipLabel` / `_homeDynamicStatusChipIcon` / `_homeDynamicStatusChipColor`; historial con `completed: true` en tarjetas finalizadas.

### 5.3 i18n y errores

- Cinco ARB (`app_es`, `app_en`, `app_pt`, `app_it`, `app_fr`) con claves de wizard, detalle, home y errores de funciones.
- `functions_user_message.dart`: mapeo de `reasonCode` nuevos (sorteo, chat, wishlist, assignments, rotate, join, etc.).

---

## 6. Validación local recomendada

Desde `SecretSwap/src/flutter_app`:

```text
flutter gen-l10n
flutter analyze
```

Desde `SecretSwap/src/firebase_functions`:

```text
npm run build
```

En el momento de redactar este documento, `flutter analyze` y `npm run build` completan sin errores en el árbol de trabajo.

---

## 7. Despliegue y operación

1. Desplegar **rules** y **functions** tras revisión.
2. Verificar en consola la primera ejecución de `executeRaffle` en un grupo de prueba (idempotencia con la misma key).
3. Probar flujo app: crear sorteo → añadir manuales → unirse con código → ejecutar → compartir / historial.

---

## 8. Riesgos y mitigaciones

| Riesgo | Mitigación implementada |
|--------|-------------------------|
| Mezclar sorteo con `executeDraw` | Rechazo explícito en callable y UI que no invoca draw para `simple_raffle`. |
| Filtrar asignaciones / wishlist como Amigo Secreto | Guardas en functions y mensajes de error localizados. |
| Rotación de código tras resultado | Bloqueo en `rotateInviteCode`. |
| Doble clic en «Ejecutar» | Idempotencia por `idempotencyKey` + transacción. |

---

## 9. Próximos pasos posibles (fuera de alcance 9B)

- Métricas / logging estructurado por `dynamicType`.
- Pruebas automatizadas e2e sorteo (callable + rules emulator).
- Afinar copy y onboarding si el selector de dinámicas gana más modalidades.
