# Tarci Secret — Fase 10A — Arquitectura «Equipos» y reutilización para «Parejas / Emparejamientos»

**Tipo:** diseño de dominio y arquitectura de producto — **sin implementación de runtime**.  
**Checkpoint Git:** árbol limpio en `d583f8c` (no se creó commit de checkpoint; sin cambios pendientes).  
**Documento:** `docs/tarci_phase_10a_teams_pairings_architecture.md` (este archivo).

**Referencias obligatorias:**

- `docs/tarci_phase_9a_multi_dynamics_architecture.md`
- `docs/tarci_phase_9b_raffle_implementation.md`
- `docs/tarci_phase_9b3_push_notifications.md`

---

## 1. Objetivo de la fase

Definir con rigor la **tercera dinámica pública** de Tarci Secret — **Equipos** — y decidir si **Parejas / Emparejamientos** puede entrar en la primera salida como variante del mismo motor, **sin escribir código** en esta fase.

**Entregables de diseño:**

- Definición de producto y alcance v1 / no-v1.
- Modelo Firestore y estados propios.
- Algoritmo de agrupación recomendado.
- Política de imparidades y sobrantes.
- Reutilización concreta del patrón **Sorteo** (9B) y de la infra común.
- Plan ejecutable **Fase 10B** (implementación Equipos) y, si aplica, **Fase 10C** (capa Parejas).

---

## 2. Estado actual del producto (auditoría post-9B / 9B.3)

### 2.1 Dinámicas en producción de código

| `dynamicType` (Firestore) | Estado | Patrón técnico |
|---------------------------|--------|----------------|
| `secret_santa` (default) | Completo | `drawStatus`, `executeDraw`, assignments privadas, wishlist, chat post-draw, subgrupos con reglas |
| `simple_raffle` | Completo (9B+) | `raffleStatus`, `raffleExecutions`, participantes `raffle_manual`, resultado público, share |

### 2.2 Infra común ya validada (reutilizable para Equipos)

| Capacidad | Implementación actual |
|-----------|------------------------|
| Contenedor `groups/{groupId}` | Sí |
| `members` + `participants` | Sí |
| `user_groups`, `invite_codes` | Sí |
| Join por código ramificado por `dynamicType` | Sí (`joinGroupByCode.ts`) |
| Selector de dinámica | `dynamics_selector_screen.dart` — AS y Sorteo activos; Equipos/Parejas «próximamente» |
| Dispatcher de detalle | `group_detail_screen.dart` → `RaffleGroupDetailScreen` si `simpleRaffle` |
| Dashboard multidinámica | Chips tipo + estado (`drawStatus` / `raffleStatus`) |
| Wizard dedicado por dinámica | `create_raffle_wizard_screen.dart` |
| Participantes sin app | `raffle_manual` + callables CRUD |
| Owner participa sí/no + apodo | Wizard sorteo + detalle |
| Ejecución backend + snapshot | `executeRaffle` + `raffleExecutions` |
| Idempotencia | `idempotencyKey` en subcolección de ejecución |
| Borrado seguro | `deleteGroup` borra `raffleExecutions` tras `executions` |
| Push al completar | `groupNotifications.ts` + `triggeredByUid` excluido |
| Stream roster reactivo | `watchGroupRosterSignature` (Sorteo) |
| i18n 5 idiomas | ARB + `functions_user_message` |

### 2.3 Lo que Equipos NO debe tocar

- `executeDraw`, assignments, wishlist, managed participants con semántica de regalo.
- `drawStatus` / reglas de subgrupo de Amigo Secreto.
- Pantallas y copy de «Mi amigo secreto».

### 2.4 Huecos respecto a Equipos (esperados en 10B)

- No existe `dynamicType: teams`.
- No hay `teamStatus`, `teamExecutions`, ni callables `createTeamsGroup` / `executeTeams`.
- Selector y home muestran Equipos/Parejas como coming soon (`dynamicsCardTeamsTitle`, `dynamicsCardPairingsTitle` en ARB).

---

## 3. Definición de producto: ¿Qué es «Equipos»?

### 3.1 Definición cerrada

**Equipos** es una dinámica pública en la que el organizador reúne participantes (con o sin app) y Tarci Secret los **reparte automáticamente en grupos visibles para todos** los miembros con app.

Sirve para:

- partidos informales y actividades;
- clases y talleres;
- juegos de mesa o dinámicas familiares;
- dividir un grupo grande en equipos equilibrados **sin discutir** quién va con quién.

### 3.2 Terminología visible (recomendación)

| Nivel | ES (recomendado) | Notas |
|-------|-------------------|--------|
| Modalidad en selector | **Equipos** | Ya existe clave `dynamicsCardTeamsTitle` |
| CTA crear | **Crear equipos** | Acción clara; coherente con «Crear amigo secreto» / wizard sorteo |
| Estado preparación | **Preparando equipos** | Paralelo a «Preparando» del sorteo |
| Estado resuelto | **Equipos listos** / **Equipos creados** | Evitar «sorteo» para no confundir con Sorteo/ganador |
| Ejecutar | **Formar equipos** / **Generar equipos** | No «sortear» |

**Conclusión:** modalidad **Equipos**, CTA **Crear equipos**. En EN: *Teams* / *Create teams*.

**No usar** «Dividir en equipos» como nombre de modalidad (mejor como subtítulo del wizard).

---

## 4. Alcance funcional Equipos v1 (recomendado)

### 4.1 Sí entra en v1

| Capacidad | Detalle |
|-----------|---------|
| Crear dinámica Equipos | Callable `createTeamsGroup` (nombre tentativo) |
| Invitar por código | Reutilizar patrón join; ramas por `dynamicType` |
| Participantes con app | `members` activos |
| Participantes sin app | Tipo `teams_manual` (análogo `raffle_manual`) |
| Owner participa sí/no | Campo `ownerParticipatesInTeams` |
| Apodo del owner si participa | Mismo patrón que sorteo (wizard paso 1) |
| **Dos modos de generación** | Por **número de equipos** y por **tamaño de equipo** |
| Generación en backend | Callable `executeTeams` |
| Resultado público | `resultVisibility: public_to_group` |
| Snapshot inmutable | `teamExecutions/{id}.teamsSnapshot` |
| Compartir resultado | `share_plus` (texto formateado por equipos) |
| Bloqueo post-generación | Sin editar roster ni config; sin regenerar en v1 |
| Eliminar dinámica (owner) | Extender `deleteGroup` |
| Dashboard + historial | Chips y bucketing por `teamStatus` + `eventDate` |
| i18n | 5 idiomas (obligatorio en 10B) |
| Modal join sorteo-equipos | Sin subgrupos/casas (patrón 9B.1) |

### 4.2 No entra en Equipos v1

| Exclusión | Motivo |
|-----------|--------|
| Chat grupal | No esencial; alcance controlado (ver §12) |
| Regenerar equipos | Complejidad y discusión de fairness; owner borra y recrea si error |
| Subgrupos / casas AS | Semántica distinta; no mezclar |
| Capitanes / roles por equipo | `role_scoped` — futuro |
| Restricciones «no repetir X con Y» | Algoritmo distinto; post-v1 |
| Torneos, rondas, votaciones | Fuera de alcance estratégico |
| Wishlist / entregas gestionadas | Amigo Secreto |
| PDF bonito de equipos | Opcional post-v1; share texto sí |

### 4.3 ¿Ambos modos (team count y team size) en v1?

**Sí — recomendación cerrada.**

| Modo | Input usuario | Ejemplo |
|------|---------------|---------|
| `team_count` | `requestedTeamCount = N` | 12 personas → 3 equipos → ~4+4+4 |
| `team_size` | `requestedTeamSize = K` | 12 personas → equipos de 3 → 4 equipos de 3 |

**Razones:**

1. Misma implementación de motor (§9): solo cambia cómo se calcula `numTeams` antes del reparto round-robin.
2. Habilita **Parejas** como `team_size = 2` sin motor nuevo (§8).
3. Coste UX acotado: wizard con paso «¿Cuántos equipos o cuántas personas por equipo?» (radio + contador).

**Validación mínima común:**

- Participantes elegibles ≥ 2.
- `team_count`: 2 ≤ N ≤ elegibles.
- `team_size`: 2 ≤ K ≤ elegibles.
- Tras calcular `numTeams = ceil(n/K)` o `N` directo: `numTeams` ≥ 2 (si no, error claro).

---

## 5. Relación Equipos ↔ Parejas / Emparejamientos

### 5.1 Hipótesis evaluada

> Parejas = variante de Equipos con `groupingMode = team_size` y `requestedTeamSize = 2`.

### 5.2 Conclusión formal

| Pregunta | Respuesta |
|----------|-----------|
| ¿Reutiliza el motor de Equipos? | **Sí (~95 %)**. Misma pool de elegibles, shuffle, reparto round-robin en `ceil(n/2)` equipos de tamaño objetivo 2. |
| ¿Misma `dynamicType` en Firestore? | **Sí.** No crear `dynamicType: pairings` en v1. |
| ¿Qué añade Parejas? | **Capa UX + validación + copy + share** orientados a parejas. |
| ¿Edge cases extra? | **Número impar** de participantes (política §7). |
| ¿Entra en primera salida pública? | **Sí, como preset (Opción C)**, no como fase grande separada. |

### 5.3 Recomendación de producto: **Opción C** (preset dentro de Equipos)

**Fase 10B — Equipos:** modalidad completa con ambos modos y copy genérico de equipos.

**Fase 10C — Parejas (pequeña):**

- Tarjeta activa en selector: **«Parejas»** (o «Emparejamientos»).
- Navega al **mismo wizard** con parámetros iniciales: `groupingMode=team_size`, `requestedTeamSize=2`.
- Copy específico («Formar parejas», «Participantes en parejas»).
- Validación extra: **número par** de elegibles (v1).
- Share con plantilla «Pareja 1: A y B».

**No recomendado en v1:**

- **Opción A** — `dynamicType` separado `pairings`: duplica callables, rules, dashboard, push, sin beneficio real.
- **Opción B** — Postergar Parejas: pierde time-to-value cuando el motor ya existe; el coste marginal de 10C es bajo (~1–2 días) si 10B dejó el wizard parametrizable.

### 5.4 Porcentaje de lógica compartida (Parejas vs Equipos)

| Capa | Compartido |
|------|------------|
| Firestore grupo + ejecución | 100 % |
| Callables create/execute/delete/join | 100 % (ramas) |
| Algoritmo de reparto | 100 % |
| Repositorio + streams | ~90 % |
| Wizard | ~70 % (pasos condicionales / query params) |
| Detalle post-formación | ~60 % (layout distinto: «Pareja» vs «Equipo N») |
| i18n | ~40 % claves nuevas para parejas |

---

## 6. Política de imparidades y sobrantes (v1)

### 6.1 Equipos generales (team_count y team_size)

**Política cerrada: reparto equilibrado con diferencia máxima de 1 persona entre el equipo más grande y el más pequeño.**

**Método:** lista global barajada → asignación **round-robin** a `numTeams` equipos (ver §9). Con esto:

| Caso | n | Config | Resultado típico |
|------|---|--------|------------------|
| 12 | 12 | 3 equipos | 4+4+4 |
| 10 | 10 | 3 equipos | 4+3+3 |
| 10 | 10 | equipos de 3 | 4 equipos → 3+3+2+2 |
| 7 | 7 | 3 equipos | 3+2+2 |
| 5 | 5 | equipos de 2 | 3 equipos → 2+2+1 |

**No hacer en v1:**

- Tríos forzados por defecto en equipos generales.
- Bloquear siempre que no sea divisible exacto (frustra uso real).

### 6.2 Preset Parejas (`team_size = 2`)

**Política cerrada v1: exigir número par de participantes elegibles (≥ 2).**

| n | Resultado |
|---|-----------|
| 8 | 4 parejas |
| 10 | 5 parejas |
| 9 | **Error** `TEAMS_ODD_COUNT_FOR_PAIRS` — mensaje: añade o quita una persona |

**Alternativas postergadas (no v1):**

- Permitir 1 «sin pareja» + mensaje en resultado.
- Crear un trío automático.

**Razón:** mensaje simple, UX predecible, evita debates de producto en la primera salida.

---

## 7. Resultado y visibilidad

### 7.1 Visibilidad

- `resultVisibility: public_to_group` (igual que Sorteo).
- Todos los **miembros activos con app** ven la misma lista de equipos e integrantes.
- El **organizador** ve lo mismo (no hay secreto organizador).
- Participantes **sin app** aparecen en snapshot y en share; no abren la app.

### 7.2 Snapshot (recomendación: sí)

Persistir en `teamExecutions/{executionId}`:

```typescript
teamsSnapshot: [
  {
    teamIndex: 0,
    teamLabel: "Equipo 1",  // o "Pareja 1" en preset
    members: [
      { participantId, displayName, sourceType, memberUid? }
    ]
  }
]
```

**Motivos:** mismos que Sorteo (`winnersSnapshot`): historial estable si alguien cambia nickname después; share y pantalla leen la ejecución, no el roster vivo.

---

## 8. Estado de la dinámica: `teamStatus`

### 8.1 Valores (no reutilizar `drawStatus` ni `raffleStatus`)

| Valor | Significado |
|-------|-------------|
| `idle` | Roster/config editables; invitaciones abiertas |
| `generating` | Transacción de formación en curso (breve) |
| `completed` | Equipos formados; snapshot guardado |
| `failed` | Error recuperable (paridad con otras dinámicas) |

### 8.2 Transiciones

```text
idle → generating → completed
idle → generating → failed → idle (solo si no se persistió completed; patrón raffle)
```

### 8.3 Dashboard

- Chip tipo: **Equipos**
- Chip estado: **Preparando** (`idle`) / **Formando…** (`generating`) / **Equipos listos** (`completed`)
- Historial: `completed` + `eventDate` pasada (misma lógica que Sorteo en `groups_home_screen`)

### 8.4 Impacto en join / invitaciones / edición

| Fase | Comportamiento (simétrico a Sorteo) |
|------|-------------------------------------|
| `idle` | Join permitido; CRUD manuales; rotar código; editar config de formación |
| `generating` | Join rechazado (`TEAMS_IN_PROGRESS`) |
| `completed` | Join cerrado para nuevos (`TEAMS_RESOLVED_INVITES_CLOSED`); sin edición de roster |
| `failed` | Tratar como `idle` para edición |

---

## 9. Modelo Firestore propuesto

### 9.1 Documento `groups/{groupId}`

```text
dynamicType: "teams"
resultVisibility: "public_to_group"
teamStatus: "idle" | "generating" | "completed" | "failed"

groupingMode: "team_count" | "team_size"
requestedTeamCount?: number      // si groupingMode === team_count
requestedTeamSize?: number       // si groupingMode === team_size

ownerParticipatesInTeams: boolean
lastTeamExecutionId?: string | null
lastTeamCompletedAt?: Timestamp | null

// Campos transversales existentes
name, ownerUid, lifecycleStatus, eventDate?, eventDateDayKey?, eventTimeZone?
rulesVersionCurrent: 1          // regla ignore fija al crear (paridad raffle)
drawStatus: "idle"              // inerte; no usar para lógica teams
raffleStatus: "idle"            // inerte
```

**Nota:** mantener `drawStatus`/`raffleStatus` en `idle` al crear evita reglas Firestore legacy que asumen presencia del campo; **toda** la lógica de Equipos usa `teamStatus`.

### 9.2 Subcolección `teamExecutions/{executionId}`

```text
executionId: string
idempotencyKey: string
groupingMode: "team_count" | "team_size"
requestedTeamCount?: number
requestedTeamSize?: number
eligibleParticipantCount: number
teamCount: number
teamsSnapshot: TeamSnapshot[]   // ver §7.2
status: "success" | "failed"
createdAt, createdByUid
```

### 9.3 Participantes

| Origen | `participantType` | Notas |
|--------|-------------------|--------|
| Miembro con app | (vía members, no fila participants obligatoria) | Como raffle: elegibles desde `members` |
| Sin app | `teams_manual` | CRUD callables dedicadas |

**Decisión:** **no** reutilizar `raffle_manual` como tipo único; añadir `teams_manual` para claridad en queries y deleteGroup.

### 9.4 Índices

- `teamExecutions` where `idempotencyKey ==` (mismo patrón que `raffleExecutions`).
- Sin índice compuesto adicional previsto en v1.

---

## 10. Algoritmo de agrupación v1 (especificación para 10B)

### 10.1 Principios

- Aleatoriedad: **Fisher-Yates** sobre lista de elegibles (semilla: `crypto.randomInt`, no `Math.random`).
- Sin duplicados: cada `participantId` en exactamente un equipo.
- Equilibrio: round-robin sobre lista barajada → tamaños difieren como máximo en 1.
- Determinismo de idempotencia: misma `idempotencyKey` → misma ejecución guardada (no re-ejecutar shuffle).

### 10.2 Pseudocódigo

```text
1. Cargar elegibles (members activos según ownerParticipates + teams_manual activos)
2. Deduplicar por participantId
3. Si preset parejas: if count % 2 !== 0 → error
4. Calcular numTeams:
   - si team_count: numTeams = requestedTeamCount
   - si team_size: numTeams = ceil(count / requestedTeamSize)
5. Validar numTeams >= 2 y count >= 2
6. shuffle(elegibles)
7. teams = array de numTeams listas vacías
8. for i in 0..count-1:
     teams[i % numTeams].push(elegibles[i])
9. Asignar teamLabel (Equipo 1..N o Pareja 1..N)
10. Persistir teamsSnapshot + teamStatus completed
```

### 10.3 Complejidad

O(n) tiempo, O(n) espacio — trivial para tamaños de producto (< 100 participantes).

---

## 11. Participantes, owner y reutilización del patrón Sorteo

| Aspecto | ¿Reutilizar de Sorteo? | Notas |
|---------|------------------------|--------|
| Pool elegibles (members + manual) | **Sí, patrón idéntico** | Excluir owner si `ownerParticipatesInTeams === false` |
| `teams_manual` CRUD | **Copiar estructura** `raffleManual*` | Nuevos callables + DTOs |
| Wizard pasos nombre / apodo / fecha | **Sí** | Sustituir «ganadores» por modo de agrupación |
| Paso owner participa | **Sí** | |
| Detalle invitación + código | **Sí** | |
| `groupRosterSignatureStreamProvider` | **Sí** | Invalidar detalle al join remoto |
| `_memberBomboDisplayName` / no «Organizador» | **Sí** | Misma lección 9B.2 |
| Mínimo 2 elegibles antes de CTA | **Sí** | Mensaje bajo botón deshabilitado |
| Modal join sin subgrupos | **Sí** | Rama `dynamicType == teams` |
| `executeDraw` / wishlist / managed | **No** | Guardas |

**Extracción futura (no en 10B):** módulo compartido `public_dynamic_participants` en backend/Flutter — solo si el tercer tipo lo justifica; **no** refactorizar Sorteo en 10B.

---

## 12. Join, invitaciones y bloqueos

**Simetría con Sorteo — recomendación cerrada: sí.**

| Acción | Pre-formación (`idle`) | Post-formación (`completed`) |
|--------|------------------------|------------------------------|
| Join por código | Permitido | Denegado a no-miembros |
| Añadir/editar/borrar manual | Owner | Denegado |
| Rotar código | Permitido | Bloqueado |
| Cambiar team count/size | Permitido | Bloqueado |
| Volver a formar equipos | — | **No** en v1 |
| Eliminar grupo | Owner | Owner |

---

## 13. Chat y push notifications

### 13.1 Chat

**Recomendación: NO en Equipos v1.**

| A favor | En contra |
|---------|-----------|
| Coordinación pre-partido | No esencial para «ver equipos» |
| | Aumenta alcance (rules, pantalla, copy AS) |
| | 9A ya marca chat como configurable por tipo |

**Futuro:** activar chat post-formación si hay demanda (capacidad flag).

### 13.2 Push notifications

**Recomendación: sí, pero en Fase 10B.1** (inmediatamente después del núcleo 10B).

| Fase | Contenido |
|------|-----------|
| 10B | Motor + UI + share sin push |
| 10B.1 | Extender `notifyGroupDynamicCompleted` con `dynamicType: teams`, copy «Tus equipos ya están listos», `eventKind: teams_completed` |

**Razón:** infra FCM ya existe; desacoplar reduce riesgo en la primera entrega de UI. Mismo patrón que se podría haber hecho con Sorteo.

---

## 14. Dashboard y selector

### 14.1 Selector (`dynamics_selector_screen`)

| Tarjeta | Fase | Acción |
|---------|------|--------|
| Amigo Secreto | Actual | `createGroup` |
| Sorteo | Actual | `createRaffle` |
| **Equipos** | **10B** | Activar card → `createTeams` (ruta nueva) |
| Parejas | **10C** | Activar card → wizard con preset `team_size=2` |
| Duelos | Futuro | Coming soon |

### 14.2 Home

Extender `_homeDynamicStatusChipLabel` / iconos / colores para `TarciDynamicType.teams` (patrón raffle).

---

## 15. i18n (anticipación 10B / 10C)

Grupos de claves (no traducir en 10A):

- Wizard: título, modos (por N equipos / por K personas), validaciones, CTA crear.
- Detalle: invitación, roster, formar equipos, equipos listos, share.
- Errores Functions: `TEAMS_*` paralelos a `RAFFLE_*`.
- Preset parejas: título «Parejas», error impar, labels «Pareja N».
- Home / selector: `homeDynamicTypeTeams`, estados.

---

## 16. Plan de implementación — Fase 10B (Equipos)

### 16.1 Backend

1. `firestorePaths`: `teamExecutionsCol`, `teamExecutionDoc`.
2. DTOs: `CreateTeamsGroup`, `ExecuteTeams`, manual CRUD, enums.
3. `createTeamsGroup.ts` (espejo `createRaffleGroup`).
4. `executeTeams.ts` (espejo `executeRaffle` + algoritmo §10).
5. `teamsManualParticipants.ts` (espejo raffle manual).
6. Actualizar: `joinGroupByCode`, `rotateInviteCode`, `deleteGroup`, guardas en draw/wishlist/managed/chat.
7. `firestore.rules`: lectura `teamExecutions` miembros activos.

### 16.2 Flutter

1. `TarciDynamicType.teams`, `TeamStatus`, modelos snapshot.
2. `groups_repository` + impl + stub + `watchGroupTeamStatus`.
3. `create_teams_wizard_screen.dart`.
4. `teams_group_detail_screen.dart`.
5. `group_detail_screen` dispatcher.
6. `dynamics_selector` + rutas + home chips.
7. Join modal rama teams.
8. i18n 5 ARB + `functions_user_message`.
9. Tests manuales checklist (§18).

### 16.3 Estimación de esfuerzo relativo

~**1.2×** el esfuerzo de Sorteo (9B), al aprovechar plantillas; el algoritmo es más simple que Fisher-Yates de ganadores.

---

## 17. Plan Fase 10C (Parejas) — opcional primera salida

**Solo si 10B dejó wizard parametrizable.**

1. Activar tarjeta Parejas en selector → ruta con query `?preset=pairs` o extra de ruta.
2. Pre-rellenar `groupingMode=team_size`, `requestedTeamSize=2`.
3. Validación par en `executeTeams` cuando `creationPreset=pairs` (campo opcional en grupo o inferido por size=2 + flag UI-only — **preferir campo `creationPreset: "teams" | "pairs"` en grupo** solo si hace falta validar en backend; alternativa: validar `requestedTeamSize===2` + `groupingMode===team_size` y paridad).
4. Copy y share específicos.
5. i18n adicional (~15–20 claves).

**Esfuerzo:** ~15–25 % de 10B si 10B se diseñó bien.

---

## 18. Checklist de validación manual (post-10B)

- [ ] Crear equipos por N y por K; 12 personas casos conocidos.
- [ ] Preset parejas (10C): 8 → 4 parejas; 9 → error par.
- [ ] Join remoto actualiza roster (stream).
- [ ] Post-formación: join cerrado, no editar.
- [ ] Share legible en WhatsApp.
- [ ] Amigo Secreto y Sorteo sin regresión.
- [ ] i18n ES + EN mínimo.

---

## 19. Riesgos de arquitectura

| Riesgo | Mitigación |
|--------|------------|
| Contaminar `executeDraw` / assignments | Callables dedicadas + guardas |
| Un solo estado para todo | `teamStatus` exclusivo |
| Confundir Equipos con subgrupos AS | Copy claro; no usar subgrupos en teams |
| Parejas como dynamicType separado | Preset sobre teams (10C) |
| Regenerar equipos pedido por usuarios | v2; borrar grupo en v1 |
| Push rompe execute | try/catch + warn (patrón 9B.3) |
| `teams_manual` vs `raffle_manual` en delete | Actualizar `deleteGroup` explícitamente |

---

## 20. Decisiones cerradas (Fase 10A)

1. Tercera dinámica: **`dynamicType: teams`**, producto **Equipos**, CTA **Crear equipos**.
2. **Ambos** modos `team_count` y `team_size` en v1.
3. Algoritmo: **shuffle + round-robin** con equilibrio ±1.
4. Parejas: **mismo motor**; entrada en **10C como preset**, no dynamicType separado.
5. Parejas v1: **solo número par** de elegibles.
6. Resultado **público** con **snapshot** en `teamExecutions`.
7. Estado **`teamStatus`** propio.
8. Participantes manuales: **`teams_manual`**.
9. **Sin chat** en v1; **push en 10B.1**.
10. Join/bloqueos **simétricos a Sorteo**.

---

## 21. Preguntas abiertas para Stan

1. ¿Etiquetas de equipo por defecto **«Equipo 1»** o permitir nombres custom del owner pre-formación (v2)?
2. ¿Preset Parejas en **misma release** que Equipos (10B+10C) o release siguiente?
3. ¿Límite máximo de participantes por grupo en v1 (p. ej. 50) para copy de rendimiento?
4. ¿Share incluye emoji / branding Tarci igual que sorteo?
5. ¿Push en 10B.1 es obligatorio antes de publicar en stores?

---

## 22. Validación técnica (Fase 10A)

Solo documentación. **No** es obligatorio `flutter analyze` ni `npm run build`.

---

*Fin del documento Fase 10A — Equipos y Parejas.*
