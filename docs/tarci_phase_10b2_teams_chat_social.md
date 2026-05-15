# Fase 10B.2 — Chat social post-Equipos + Tarci Auto Chat

## Alcance

- Chat grupal en grupos `dynamicType == teams` tras `teamStatus == completed`.
- Mensaje de sistema idempotente al formar equipos (`chat.system.teamsCompleted.v1`).
- Catálogo Tarci Auto para Equipos: 50 plantillas (20 playful, 12 challenge, 8 quiet, 10 countdown).
- Automatización en `tarciChatAutomation.ts` con barrido dedicado a equipos.
- UI Flutter: tarjeta «Conversación del grupo» en detalle de Equipos + pantalla de chat reutilizada.

## Fuera de alcance

- Chat en Sorteo (`simple_raffle`).
- Parejas (Fase 10C).
- Push por mensajes de chat.
- Wishlist en automatización de equipos.

## Backend

| Archivo | Cambio |
|---------|--------|
| `executeTeams.ts` | `appendGroupChatSystemMessageIfNew` tras ejecución nueva |
| `tarciAutoCatalogTeams.ts` | Metadatos de 50 plantillas |
| `tarciChatAutomation.ts` | Ventana de engagement equipos, decisión sin wishlist, sweep teams |
| `firestore.indexes.json` | Índice `dynamicType + teamStatus + lifecycleStatus` |

## Flutter

| Archivo | Cambio |
|---------|--------|
| `teams_group_detail_screen.dart` | Tarjeta chat para miembros activos |
| `group_chat_screen.dart` | Chip «Equipos listos», sistema `teamsCompleted` |
| `tarci_auto_chat_l10n.dart` | Resolver 50 claves teams |
| `app_*.arb` | i18n UI + mensajes (generado con `scripts/gen-teams-tarci-i18n.mjs`) |

## Regenerar i18n teams

```bash
node scripts/gen-teams-tarci-i18n.mjs
cd src/flutter_app && flutter gen-l10n
```

## Validación manual

1. Crear grupo Equipos, unir miembros, ejecutar formación de equipos.
2. Ver mensaje sistema «equipos listos» en chat (solo en ejecución nueva).
3. Ver tarjeta «Conversación del grupo» en detalle con equipos completados.
4. Abrir chat, enviar mensaje de usuario, ver chip «Equipos listos».
5. Emulador: `devRunTarciChatAutomation` con `groupId` de equipo completado — publicar auto mensaje teams.
6. Verificar que Sorteo no muestra chat y que Amigo Secreto no cambió.
