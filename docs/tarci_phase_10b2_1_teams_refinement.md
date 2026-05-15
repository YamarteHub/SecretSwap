# Fase 10B.2.1 — Refinamiento Equipos (UX, roles, nombres)

## Resumen

- Separación de vista **administrador** vs **miembro** en `teams_group_detail_screen.dart`.
- Rediseño visual post-formación (hero premium, tarjetas de equipo, acciones agrupadas).
- Renombrado de equipos vía callable `updateTeamLabel` (persistencia en `teamExecutions` snapshot).
- `TeamResultText.teamDisplayName()` para UI, share, correo y PDF con fallback localizado.

## Callable

`updateTeamLabel({ groupId, teamIndex, teamLabel })` — solo owner, equipos completados, máx. 40 caracteres.

## i18n nuevas

`teamsMemberWaiting*`, `teamsOrganizerByline`, `teamsResultActionsTitle`, `teamsRename*`, `teamsYouInTeam`, `teamsDetailRosterTitle`.
