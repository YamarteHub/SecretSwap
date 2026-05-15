# Tarci Secret — Fase 9B.3 — Push al completar dinámicas

**Tipo:** notificaciones FCM transversales (Amigo Secreto + Sorteo + Equipos).  
**Documento:** `docs/tarci_phase_9b3_push_notifications.md`  
**Extensión Equipos:** `docs/tarci_phase_10b1_teams_push_notifications.md`

---

## 1. Objetivo

Avisar por push a miembros activos con app cuando:

- `executeDraw` completa con éxito (Amigo Secreto);
- `executeRaffle` completa con éxito (Sorteo público);
- `executeTeams` completa con éxito (Equipos) — **Fase 10B.1**.

Al tocar la notificación, la app abre `/groups/{groupId}` y `GroupDetailScreen` resuelve la UI por `dynamicType`.

---

## 2. Arquitectura de tokens

```text
users/{uid}
  preferredLocale?: "es" | "en" | "pt" | "it" | "fr"
  createdAt, updatedAt

users/{uid}/pushTokens/{tokenId}
  token: string
  platform: "android" | "ios" | "web" | "unknown"
  enabled: boolean
  createdAt, updatedAt, lastSeenAt
  disabledAt?, disabledReason?   // si FCM marca token inválido
```

- **tokenId** = SHA-256 del token FCM (deduplicación por dispositivo).
- Varios documentos por UID = varios dispositivos.
- `onTokenRefresh` en Flutter re-registra el token.

**Decisión de escritura:** callable **`registerPushToken`** (patrón Functions del proyecto). El cliente no escribe directamente en Firestore; reglas deniegan lectura/escritura de `users/*` y `pushTokens/*` al cliente.

---

## 3. UX de permisos

- Tarjeta discreta en el dashboard (`PushActivationCard`) si el usuario no activó push y no descartó la promo.
- CTA «Activar» → permiso Android 13+ (`POST_NOTIFICATIONS` + `permission_handler`) + `FirebaseMessaging.requestPermission` (iOS).
- Si deniega: snackbar y `tarci.push.promoDismissed` para no insistir en cada rebuild.
- Si acepta: registro vía callable y `tarci.push.activated = true`.

---

## 4. Flujo de registro (Flutter)

1. `PushNotificationsService.initialize()` tras el primer frame (`main.dart` → `_Bootstrap`).
2. Escucha `getInitialMessage`, `onMessageOpenedApp`, `onMessage` (foreground → SnackBar con acción).
3. `requestPermissionAndRegister` obtiene token y llama `registerPushToken` con `preferredLocale` del idioma activo.
4. Cambio de idioma en home sincroniza `preferredLocale` en backend si push ya está activado.

---

## 5. Envío tras `executeDraw`

- Solo en la ruta de **éxito nuevo** al final de la callable (tras persistir assignments y estado `completed`).
- **No** se llama en rutas idempotentes que reutilizan `returnSuccessfulDrawWithChat` (doble tap / re-sync).
- Helper: `notifyGroupDynamicCompleted` en `groupNotifications.ts`.
- El **UID que ejecuta** (`triggeredByUid`) se excluye de destinatarios (ya está en la app).
- Fallos de FCM → `logger.warn`; la callable sigue devolviendo éxito.

---

## 6. Envío tras `executeRaffle`

- Solo tras transacción exitosa **nueva** (no en retorno por `idempotencyKey` duplicado).
- Mismo helper con `dynamicType: "simple_raffle"`.
- Copy de notificación **genérico** (nombre del grupo + invitación a abrir la app); **no** lista nombres de ganadores en el body.
- El ejecutor se excluye vía `triggeredByUid`.

---

## 6b. Envío tras `executeTeams` (10B.1)

- Solo tras transacción exitosa **nueva** (no en retorno idempotente).
- `dynamicType: "teams"`, `eventKind: "teams_completed"`.
- Copy genérico (equipos listos); **no** lista integrantes ni reparto en la push.
- El ejecutor se excluye vía `triggeredByUid`.

---

## 7. Payload FCM

**notification:** título y cuerpo localizados (backend).

**data:**

| Campo | Valor |
|--------|--------|
| `type` | `group_dynamic_completed` |
| `groupId` | ID del grupo |
| `dynamicType` | `secret_santa` \| `simple_raffle` \| `teams` |
| `destination` | `group_detail` |
| `eventKind` | `secret_santa_completed` \| `raffle_completed` \| `teams_completed` |

Navegación: `context.go('/groups/$groupId')`.

---

## 8. Foreground / background / terminated

| Estado | Comportamiento |
|--------|----------------|
| Terminated | `getInitialMessage` → navegación post-frame |
| Background | `onMessageOpenedApp` → navegación |
| Foreground | SnackBar con título/cuerpo y acción → detalle del grupo |

No se usa `flutter_local_notifications` en esta fase.

---

## 9. Tokens inválidos

Si `sendEachForMulticast` devuelve `messaging/registration-token-not-registered`, `messaging/invalid-registration-token` o `messaging/invalid-argument`:

- `pushTokens/{tokenId}.enabled = false`
- `disabledReason` = código de error

---

## 10. i18n de push

- **UI app:** claves `pushActivation*` en 5 ARB.
- **Texto de notificación:** resuelto en backend según `users/{uid}.preferredLocale` (registrado al activar push o al cambiar idioma en home).
- Si no hay locale guardado → fallback **es**.
- La preferencia de idioma solo en `SharedPreferences` no basta para push sin sincronizar; esta fase persiste `preferredLocale` en `users/{uid}` vía `registerPushToken`.

---

## 11. Limitaciones del emulador

- Auth / Firestore / Functions: emulables.
- **FCM no se emula** en Emulator Suite.
- En emulador se puede validar: registro de token (con Google Play Services), persistencia en Firestore, que `executeDraw` / `executeRaffle` invocan el helper sin romper la operación.
- Entrega real de push: **proyecto Firebase real + dispositivo o emulador Android con Play Services**.

---

## 12. iOS / APNs (pendiente operativo)

Configuración manual en Apple Developer + Firebase Console:

- Push Notifications capability
- Background Modes → Remote notifications
- Subir clave APNs a Firebase
- Probar en dispositivo físico iOS

---

## 13. Checklist de validación manual

### Emulador / desarrollo

- [ ] Activar notificaciones desde tarjeta del home
- [ ] Ver documento en `users/{uid}/pushTokens/{hash}`
- [ ] Ejecutar sorteo AS o Sorteo → logs Functions sin error de negocio
- [ ] Foreground: SnackBar al recibir (dispositivo real con FCM)

### Firebase real

- [ ] Android físico o emulador con Play Services
- [ ] Miembro B recibe push cuando A (organizador) completa draw/raffle/teams
- [ ] Tap abre detalle correcto (AS vs Sorteo vs Equipos)
- [ ] Token inválido se deshabilita en Firestore
