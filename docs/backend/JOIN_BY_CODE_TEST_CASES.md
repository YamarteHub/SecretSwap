# JOIN_BY_CODE_TEST_CASES — MVP

Este documento define una tabla de casos para probar `joinGroupByCode` y cada `reasonCode` usando datos reales en Firestore.

## Script de seed (solo creación/actualización de docs)

Ubicación: `src/firebase_functions/tools/seed_join_by_code.js`

Ejemplo (emulador):

```bash
set FIRESTORE_EMULATOR_HOST=127.0.0.1:8080
cd src/firebase_functions
npm run seed:join -- --scenario all --uid U_TEST --ownerUid U_OWNER --projectId secretswap-dev
```

El script imprimirá los `code` y `groupId` por escenario.

## Tabla de casos (reasonCode)

| Caso | Escenario seed | Input esperado | Resultado esperado | reasonCode esperado | Notas |
|------|----------------|----------------|-------------------|---------------------|------|
| INVALID_CODE_FORMAT | N/A | `code="ab cd"` o `code="ABCD-123"` | Error | `INVALID_CODE_FORMAT` | No requiere seed. |
| CODE_NOT_FOUND | N/A | `code="SOMETHING"` | Error | `CODE_NOT_FOUND` | No requiere seed; el `codeHash` no existirá en `invite_codes`. |
| CODE_EXPIRED | `code_expired` | code del seed + `nickname?` | Error | `CODE_EXPIRED` | Seed crea `invite_codes/{codeHash}.expiresAt` en el pasado. |
| GROUP_ARCHIVED | `group_archived` | code del seed + `nickname?` | Error | `GROUP_ARCHIVED` | Seed crea `groups/{groupId}.lifecycleStatus="archived"`. |
| DRAW_IN_PROGRESS | `draw_in_progress` | code del seed + `nickname?` | Error | `DRAW_IN_PROGRESS` | Seed crea `groups/{groupId}.drawStatus="drawing"`. |
| USER_REMOVED | `user_removed` | code del seed + `nickname?` | Error | `USER_REMOVED` | Seed crea `members/{uid}.memberState="removed"`. |
| ALREADY_MEMBER | `already_member` | code del seed + `nickname?` | Error | `ALREADY_MEMBER` | Seed crea `members/{uid}.memberState="active"`. |
| OK rejoin | `ok_rejoin_left` | code del seed + `nickname?` | OK | N/A | Seed crea `members/{uid}.memberState="left"`; debe reactivar a `active`. |
| OK new member | N/A | code válido seed + `uid` nuevo | OK | N/A | Usa seed de cualquier grupo activo (p. ej. `ok_rejoin_left`) pero pasa un `--uid` distinto que no exista en `members`. |

## Notas de consistencia con la spec

- `invite_codes/{codeHash}` es el lookup O(1). No hay queries.
- El código en claro **nunca** se persiste.
- `nickname` es opcional: si no se envía, el backend usa fallback (`displayName` o `"Miembro"`).

