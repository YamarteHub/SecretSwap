# Tarci Secret — Fase 9A — Arquitectura multidinámica formal

**Tipo:** análisis y diseño arquitectónico / producto — **sin cambios de runtime** (solo documentación).  
**Checkpoint Git:** `fc57b4c` — `checkpoint antes de arquitectura multidinamica Tarci Secret` (árbol limpio en el momento del checkpoint; commit creado con `--allow-empty`).  
**Documento:** `docs/tarci_phase_9a_multi_dynamics_architecture.md` (este archivo).

---

## 1. Contexto y propósito

Tarci Secret tiene **Amigo Secreto** cerrado y validado: flujo completo (grupo, participantes, subgrupos, reglas, sorteo backend, asignaciones privadas, wishlist, entregas gestionadas, chat post-sorteo, automatización Tarci, i18n en cinco idiomas, borrado seguro, etc.). Ese módulo **es el activo de negocio** y **no debe romperse**.

La **Fase 9A** formaliza cómo escalar hacia **múltiples dinámicas sociales** (sorteos simples, equipos, emparejamientos, duelos, debates…) **sin** tratar Amigo Secreto como plantilla universal ni contaminar privacidad, estados ni UX de otras modalidades.

**Alcance 9A:** lectura de código y backend existentes, separación común vs específico, definiciones de dominio, matriz de capacidades, visibilidad de resultados, evolución de `groups`, estados, chat y participantes, priorización y **plan de Fase 9B** — todo documentado; **ninguna** implementación de producto nueva en esta fase.

---

## 2. Estado actual (auditoría resumida)

### 2.1 Flutter — dominio y rutas

- **`group_models.dart`:** `DrawStatus` (idle / drawing / completed / failed), `DrawSubgroupRule`, miembros (`MemberRole`, `MemberState`), participantes (`GroupParticipantType`, `GroupParticipantState`, `ManagedParticipantDeliveryMode`, `canReceiveDirectResult`), `GroupSummary` / `GroupDetail` / `Subgroup` / `GroupParticipant`. El modelo está **fuertemente acoplado** a la semántica de sorteo con reglas de subgrupo y entrega gestionada.
- **Rutas (`app_router.dart`):** todo bajo prefijo `/groups/…` — home, crear, join, detalle, `my-assignment`, `managed-assignments`, wishlist, chat. La navegación habla de **grupo**, no aún de **dinámica** como concepto de producto.
- **Pantallas clave:** `groups_home_screen` (dashboard activo/historial con `eventDate`), `group_detail_screen` (cuerpo masivo, estados pre/post sorteo), `create_group_screen`, `join_by_code_screen`, flujos draw / wishlist / chat enlazados al `groupId`.

### 2.2 Firebase — rutas de datos

- **`firestorePaths.ts`:** contenedor `groups/{groupId}` con subcolecciones `members`, `invites/current`, `rules/{version}`, `executions/{executionId}`, `executions/.../assignments/{giverUid}`, `chatMessages`, `chatAutomation/tarciState`. **`user_groups/{uid}/groups/{groupId}`** e **`invite_codes/{codeHash}`** como índices auxiliares.
- **`createGroup.ts`:** crea documento de grupo con `drawStatus: idle`, `rulesVersionCurrent`, regla inicial `subgroupMode: ignore`, miembro owner, invite actual.
- **`executeDraw.ts`:** carga participantes unificados (miembros + `participants`), valida subgrupos según modo, usa **`drawMatching`**, escribe ejecución y **asignaciones por `giverUid`**, actualiza estado del grupo; integración con chat del sistema. Es el **núcleo del Amigo Secreto** (asignación secreta 1:1 con restricciones).

### 2.3 Firestore Rules

- Reglas enlazan **edición de subgrupos en miembros** y **versiones de reglas** al **`drawStatus`** del grupo (`idle` / `failed` vs bloqueo en `drawing` / `completed`). Esa política es **específica de una dinámica con fase de sorteo bloqueante**, no universal.

### 2.4 Chat

- **`group_chat_screen`:** recibe `drawCompleted`; la UI condiciona comportamiento al sorteo completado (p. ej. acceso / copy). El chat está **acoplado al ciclo de vida del draw de Amigo Secreto**, no modelado hoy como “capacidad configurable genérica”.

---

## 3. Principio rector

**Amigo Secreto no es un “sorteo genérico”.** Es una dinámica con:

- resultado **por participante oculto al resto**;
- organizador **sin** visión global de emparejamientos por diseño;
- **wishlist** y lectura solo para quien regala;
- **entregas** multimodo para gestionados;
- **chat** post-revelación para no filtrar pistas pre-sorteo;
- reglas de subgrupo **semánticas** (ignorar / preferir / exigir distinto).

Cualquier nueva modalidad que necesite resultados **públicos**, equipos visibles o chat **antes** de la resolución **no debe reutilizar** el mismo modelo mental ni los mismos defaults de UI/backend que Amigo Secreto.

---

## 4. Entregable 1 — Mapa: común vs específico

### 4.1 Infraestructura común potencialmente reutilizable

| Capacidad | Reutilizable | Límites y notas |
|-----------|--------------|-----------------|
| **Firebase Auth (anónimo / sesión)** | Sí | Transversal a cualquier dinámica. |
| **Usuario con app vs participante “sin app” / gestionado** | Sí, como **patrón de membership** | La semántica de “gestionado” + `deliveryMode` + `canReceiveDirectResult` es **Amigo Secreto**; otras dinámicas pueden usar solo `app_member` + invitados opcionales. |
| **Invitaciones por código + `invite_codes`** | Sí | Genérico para unir personas a un contenedor. Rotación y cierre post-evento pueden variar por tipo. |
| **Subgrupos** | Sí como **opción** | Útiles en equipos, sorteos por cohorte, debates por bando; **no** obligatorios. Reglas `preferDifferent` / `requireDifferent` son **específicas** del sorteo secreto cruzado. |
| **Fecha de evento (`eventDate`) + historial en dashboard** | Sí | Fecha de “momento del grupo” (entrega, partido, sesión) es transversal; la regla de “historial = después de eventDate” puede parametrizarse por tipo. |
| **Dashboard activo / finalizados** | Sí a nivel de **lista de contenedores** | Criterios de bucketing hoy mezclan `drawStatus` + `eventDate` → acoplados al draw; futuro: estrategia por `dynamicType` + estado genérico. |
| **Eliminación segura por owner** | Sí | Patrón de gobernanza; la política de qué se borra (assignments, wishlist, chat…) depende del tipo. |
| **Chat grupal** | Sí como **módulo** | Momento y permisos deben ser **configuración por dinámica**, no global. |
| **Mensajes automáticos Tarci** | Sí como **motor** | Plantillas y triggers deben filtrarse por `dynamicType` / fase. |
| **i18n, branding, Acerca de** | Sí | Transversal. |
| **Índice `user_groups`** | Sí | Sigue siendo el enlace usuario ↔ contenedor sea cual sea el tipo. |
| **WhatsApp / email / PDF** | Parcial | Ideal para compartir resultados **públicos** o instrucciones; el PDF “bonito de asignación secreta” es específico; el **canal** es reutilizable. |

### 4.2 Componentes específicos de Amigo Secreto (no generalizar de forma ingenua)

- **`drawStatus`** y transiciones idle → drawing → completed / failed **tal cual** ligadas a reglas de edición en Rules.
- **Pipeline `executeDraw` + `drawMatching` + assignments por `giverUid`** como **definición de resultado secreto**.
- Pantallas y copy **“Mi amigo secreto”**, **“Secretos que gestionas”**, candados, privacidad emocional.
- **Wishlist** ligada a participante y permiso de lectura solo para el regalador.
- **`ManagedParticipantDeliveryMode`** y flujos de entrega delegada.
- **`canReceiveDirectResult`**, proyección miembro/participante para el sorteo unificado.
- **Chat solo post-sorteo** como decisión de producto actual.
- **Reglas de subgrupo** del tipo “exigir subgrupo distinto” **solo** donde el resultado sea emparejamiento oculto.

---

## 5. Entregable 2 — Definición formal de “dinámica”

### 5.1 Cadena conceptual

**Tarci Secret → Dinámica → Participantes → Resultado** (y opcionalmente **Capacidades**: chat, wishlist, entregas, automatización).

### 5.2 Definición propuesta

Una **dinámica** es una experiencia social creada dentro de la app, con:

1. **Tipo** (`dynamicType` conceptual): determina reglas de negocio, visibilidad y fases.  
2. **Participantes** (miembros con app, invitados, gestionados según el tipo).  
3. **Reglas y configuración** (subconjunto dependiente del tipo).  
4. **Estado** (ciclo de vida: borrador → preparación → lista → resuelta → archivada…).  
5. **Resultado** (estructura y visibilidad acordes al tipo).  
6. **Capacidades opcionales** (chat, wishlist, compartir, PDF, automatización Tarci).

### 5.3 Término de producto: “Dinámica” vs otros

| Término | Pros | Contras |
|---------|------|---------|
| **Dinámica** | Corto, activo, encaja con “grupo que hace algo”; en español suena natural en producto social. | En algunos contextos puede sonar abstracto; en inglés hace falta pareja (“group dynamic” / “activity”). |
| **Experiencia** | Muy centrado en usuario. | Vago; choca con “experiencia de app” y marketing. |
| **Actividad** | Neutro. | Menos distintivo; en i18n puede solaparse con “actividad reciente”. |

**Conclusión:** mantener **“Dinámica”** como concepto principal en ES; en EN/otros idiomas usar equivalente claro (**“activity”**, **“group activity”** o **“dynamic”** según tono de marketing) definido en glosario i18n cuando se exponga en UI. No sustituir el vocablo interno de dominio (`dynamicType`) por “experience”.

---

## 6. Entregable 3 — Matriz de capacidades por dinámica

Leyenda: **●** central / default · **○** opcional · **—** no aplica o contradictorio con el modelo típico.

| Dimensión | Amigo Secreto | Sorteo simple | Equipos | Emparejamientos | Duelos / batallas | Debates |
|-----------|---------------|---------------|---------|-----------------|---------------------|---------|
| Participantes con app | ● | ● | ● | ● | ● | ● |
| Sin app / manual | ● | ○ | ○ | ○ | ○ | ○ |
| Gestión adulto / menor | ● | ○ | ○ | ○ | — | ○ |
| Invitaciones por código | ● | ● | ● | ● | ● | ● |
| Subgrupos | ● (reglas fuertes) | ○ | ● | ○ | ○ | ● (bandos) |
| Fecha de evento | ● | ○ | ● | ○ | ● | ● |
| Presupuesto | ○ (si producto lo tiene) | ○ | — | — | — | — |
| Resultado privado por participante | ● | — | — | — | — | — |
| Resultado público al grupo | — | ● | ● | ● | ● | ○ |
| Organizador ve resultado completo | — (por diseño) | ● típico | ● típico | ● típico | ● | ○ |
| Wishlist | ● | — | — | — | — | — |
| Chat | ● post-sorteo | ○ antes/después | ○ | ○ | ● antes/después | ● |
| Compartir / PDF / WhatsApp | ● (gestionados) | ● | ● | ● | ● | ○ |
| Reglas específicas complejas | ● (subgrupos, exclusión) | ○ | ● | ○ | ● | ● |
| Backend de resolución | ● (matching secreto) | ● (sorteo) | ● (partición) | ● (matching) | ● | ● |
| Reutilizar infra actual | **Alta** (base) | **Media-alta** | **Media** | **Media** | **Media-baja** | **Baja-media** |

---

## 7. Entregable 4 — Modelos de visibilidad de resultado

Definiciones formales (para diseño de API y UI; no implementadas en 9A):

| Clave | Descripción |
|-------|-------------|
| **`private_per_participant`** | Cada participante autorizado ve solo su pieza del resultado; el resto no ve asignaciones ajenas. **Amigo Secreto.** |
| **`public_to_group`** | Tras resolución, todos los miembros activos ven el mismo resultado agregado (ganadores, equipos, emparejamientos). **Sorteo simple, equipos, muchos emparejamientos.** |
| **`organizer_only`** | Solo el owner (o rol staff) ve el resultado completo; miembros ven un subconjunto o nada hasta “publicar”. **Sorteos controlados, verificación.** |
| **`mixed`** | Combinación explícita (ej.: organizador ve todo; participantes ven solo su parte). **Transiciones o modos híbridos.** |
| **`role_scoped`** | Visibilidad por rol (owner, capitán, moderador, público). **Debates, torneos, equipos con capitanes.** |

**Asignación sugerida:**

- Amigo Secreto → `private_per_participant` (+ delegación gestionada = variante scoped a responsable).  
- Sorteo simple / equipos / emparejamientos típicos / duelos → `public_to_group` por defecto.  
- Debates / torneos con moderación → `role_scoped` o `mixed`.

**Objetivo:** impedir que un “sorteo público” reutilice rutas o copy de “asignación secreta” sin un **contrato de visibilidad** explícito.

---

## 8. Entregable 5 — Propuesta de modelo de dominio futuro (solo diseño)

### 8.1 Ejes conceptuales

- **`dynamicType`:** enum de producto (`secretSanta` | `simpleRaffle` | `teams` | …) — **no** añadir en 9B sin diseño de migración.  
- **`resultVisibility`:** uno de los modos de la sección 7 (o composición documentada).  
- **`lifecycleStatus`:** ya existe `lifecycleStatus` en grupo; alineable con draft / active / archived.  
- **`resolutionStatus`:** separar “vida del contenedor” de “fase de resolución” (hoy mezclado en `drawStatus` para el único tipo).  
- **Capacidades:** flags o subdocumento `capabilities: { chat: ChatCapability, wishlist: bool, … }`.

### 8.2 Evolución de Firestore sin “big bang”

**Opción recomendada a medio plazo (compatible con hoy):**

- Mantener **`groups/{groupId}`** como documento raíz del contenedor social.  
- Añadir en el futuro campos explícitos: `dynamicType`, `resultVisibility`, `resolutionStatus` (o equivalente), sin renombrar colección.  
- Subdocumentos **por tipo** para configuración que no debe mezclarse:

  - Ej.: `groups/{groupId}/config/secretSanta` vs `groups/{groupId}/config/simpleRaffle`  
  - O nombres equivalentes (`secretSantaConfig`, …) si se prefiere subcolección vs mapa.

**Por qué no `dynamics/` separada aún:** duplica índices, join con `user_groups`, migración costosa y riesgo operativo **sin** beneficio mientras el producto siga siendo “un grupo hace una cosa a la vez”.

**Por qué no renombrar `groups`:** rompe mental model, SDKs, rules, URLs y documentación de usuario.

### 8.3 Qué preserva compatibilidad

- Mismo `groupId`, mismas rutas Flutter `/groups/...`, mismas Functions entrypoints **extendidas** por tipo (o nuevas Functions paralelas con routing interno por `dynamicType`).  
- Amigo Secreto = `dynamicType == secretSanta` (implícito hoy; luego explícito con default en migración suave).

---

## 9. Entregable 6 — Decisión: colección `groups` vs `dynamics`

### Escenario A — `groups` como contenedor técnico común

- **Pros:** cero migración inmediata; `user_groups` y `invite_codes` siguen válidos; mental model “un grupo = un espacio”.  
- **Contras:** el nombre “group” es ambiguo vs “dinámica”; reglas Firestore y nombres de campos (`drawStatus`) pueden confundir a nuevos tipos.  
- **Riesgos:** acoplar nuevas features a campos legacy sin `dynamicType` explícito.

### Escenario B — Nueva colección `dynamics/{id}`

- **Pros:** nombre alineado con producto; limpieza semántica.  
- **Contras:** migración grande; duplicar patrones de seguridad; rehacer índices y app links.  
- **Riesgos:** alto coste y regresiones.

### Escenario C — `groups` solo Amigo Secreto + otra estructura para el resto

- **Pros:** aislamiento máximo del legado.  
- **Contras:** dos sistemas en paralelo indefinidamente; dashboard y deep links duplicados.

### Recomendación final

**Confirmar intuición:** **no renombrar ni migrar colección ahora.** Evolucionar **Escenario A**: `groups` permanece como **contenedor de dinámica**, introduciendo cuando toque **`dynamicType` + config por tipo + visibilidad** sin mover datos históricos. Si en el futuro el producto exige “un usuario gestiona 50 dinámicas cross-product”, reevaluar partición (B) con migración planificada.

---

## 10. Entregable 7 — Estados: generales vs específicos

### 10.1 Estado general del contenedor (reutilizable)

Ejemplos: `draft` | `preparing` | `ready` | `live` | `completed` | `archived` | `canceled`.

- Hoy `lifecycleStatus` + `drawStatus` cubren parte de esto de forma **implícita**.  
- **Recomendación:** a medio plazo **normalizar** un `containerPhase` (nombre a acordar) **por encima** del estado de resolución, sin borrar `drawStatus` hasta migrar Amigo Secreto.

### 10.2 Estado específico por tipo

- **`drawStatus`** (o `resolutionPhase`): solo dinámicas con **fase de sorteo/matching bloqueante** tipo secreto o sorteo con lock.  
- **Equipos:** `formationStatus` (borrador de equipos → publicado).  
- **Debates:** `debatePhase` (inscripción → argumentación → votación → cierre).  
- **Duelos:** `round` / `bracketState`.

**Regla:** generalizar **patrones** (fases, locks, idempotencia), no **nombres de campos** de un tipo en otro.

---

## 11. Entregable 8 — Chat como capacidad configurable

| Dinámica | Chat recomendado |
|----------|-------------------|
| Amigo Secreto | Post-resolución (como hoy) para no filtrar. |
| Sorteo simple | Opcional; **antes** si el sorteo no revela pistas (ej. solo logística); **después** para celebración. |
| Equipos | Opcional; a menudo **después** de publicar equipos; puede ser **antes** para coordinar nombres. |
| Duelos / debates | Con frecuencia **central** y **antes** durante la fase activa. |

**Conclusión:** modelar **ChatCapability** con: `enabled`, `opensAtPhase`, `rolesWhoCanPost` (futuro). No asumir “chat = post draw” global.

---

## 12. Entregable 9 — Participantes, subgrupos, responsables

- **Participante como entidad** (app / manual / gestionado): **común** como patrón de datos; campos como `deliveryMode` y `canReceiveDirectResult` son **específicos** de dinámicas con entrega delegada y secreto.  
- **Subgrupos:** **comunes como opción** de partición del grupo; reglas de sorteo secreto **no** son universales.  
- **Responsable que ve resultado ajeno:** **específico** de Amigo Secreto (y similares con menor a cargo); no extrapolar a “organizador ve todo”.

---

## 13. Entregable 10 y 14 — Priorización y primera nueva dinámica

### Criterios

Valor de usuario, complejidad, reutilización, viralidad, riesgo de contaminar arquitectura, tiempo al mercado.

### Comparación breve

| Candidata | Valor | Complejidad | Reuso infra | Riesgo arquitectura | Time-to-value |
|-----------|-------|-------------|-------------|---------------------|-----------------|
| **Sorteo simple** | Alto (universal) | Media | Alto (código, invites, miembros) | **Bajo** si se define `resultVisibility` público | Alto |
| Equipos | Alto | Media-alta | Medio (subgrupos) | Medio (formación, regeneración) | Medio |
| Emparejamientos | Alto | Media-alta | Medio | Medio (no confundir con secreto) | Medio |
| Duelos / batallas | Medio-alto | Alta | Bajo-medio | Mayor (estados, rondas) | Medio-bajo |
| Debates | Alto en nicho | Muy alta | Bajo | Alto | Bajo |

### Conclusión profesional

**La primera nueva dinámica debería ser Sorteo simple** (alineado con tu intuición): máximo reuso de **invites, miembros, participantes opcionales, fecha de evento, chat opcional, compartir resultado, Functions de aleatoriedad genérica**, y separación clara de **assignments secretos** y wishlist. Fuerza a introducir **`dynamicType` + `resultVisibility`** sin replicar el monolito emocional de Amigo Secreto.

---

## 15. Entregable 11 — Plan de Fase 9B (primera dinámica nueva)

**Nombre tentativo:** Fase 9B — Sorteo simple (nombre de producto a acordar: “Sorteo del grupo”, “Ganador al azar”, etc.).

### Objetivo

Permitir crear una dinámica donde el resultado (uno o N ganadores) sea **visible para el grupo** (o según `public_to_group` / `organizer_only` en v1), sin asignaciones 1:1 secretas ni wishlist obligatoria.

### UX (alto nivel)

- Flujo paralelo al wizard actual **o** paso inicial “tipo de dinámica” (solo cuando se implemente; puede ser entrada dedicada “Nuevo sorteo” en dashboard).  
- Lista de participantes reutilizable; sorteo con botón claro “Ejecutar sorteo”; resultado en pantalla compartida + opción compartir.

### Qué reutiliza

- `groups`, `members`, `invite_codes`, `user_groups`, callable pattern, auth.  
- Posiblemente subcolección `executions` con **otro shape de resultado** (ganadores) en lugar de `assignments` por giver.

### Qué no reutiliza

- `assignments` como documento por giver con secreto.  
- Wishlist, managed delivery como flujo principal.  
- Reglas `requireDifferent` del secreto (salvo producto quiera “sin repetir subgrupo” en sorteo simple — evaluar aparte).

### Backend

- Nueva callable o extensión condicionada por `dynamicType` con validación estricta.  
- Reglas Firestore: lectura de resultado acorde a `resultVisibility`.  
- Índices si nuevas consultas.

### Pantallas / impacto dashboard

- Tipo visible en tarjeta; bucketing activo/historial sin depender solo de `drawStatus` del secreto.  
- i18n: nuevas cadenas por idioma.

### Riesgos

- Mezclar en UI “sorteo” con “amigo secreto” sin etiqueta clara.  
- Reutilizar ruta `executeDraw` sin bifurcar → **prohibido** sin diseño; mejor **callable dedicada** o **router interno** por tipo.

---

## 16. Riesgos de crecer mal (y cómo evitarlos)

1. **Reutilizar `assignments` y pantalla “Mi amigo secreto”** para sorteos públicos → confusión legal/emocional de privacidad.  
2. **Un solo `drawStatus` para todos los tipos** sin mapa de fases → reglas Firestore imposibles de mantener.  
3. **Chat siempre post-sorteo** → fricción en dinámicas sociales que viven del debate en vivo.  
4. **Subgrupos obligatorios** en modos que no los necesitan.  
5. **Migración prematura** a colecciones nuevas sin presión real.

---

## 17. Decisiones cerradas (Fase 9A)

1. Amigo Secreto es **una dinámica**, no el modelo universal.  
2. **`groups/{groupId}`** se mantiene como raíz técnica en el horizonte planificado; evolución por **campos y subconfig**, no renombre masivo.  
3. Introducir **tipo + visibilidad + capacidades** antes de apilar features incompatibles.  
4. **Sorteo simple** como primera expansión funcional recomendada (Fase 9B).  
5. Chat = **capacidad configurable**, no invariante global.

---

## 18. Preguntas abiertas para Stan (antes de programar 9B)

1. **Nombre de producto** en ES/EN para “sorteo simple” y siempre mostrar `dynamicType` en UI o solo iconografía.  
2. **Sorteo simple:** ¿un ganador, N ganadores, o ambos en v1?  
3. ¿El organizador debe poder **ocultar** resultado hasta “publicar” (`organizer_only`) en v1 o solo `public_to_group`?  
4. ¿**Misma entrada** “Crear grupo” con selector de tipo, o **CTAs separados** (menor riesgo de confusión en v1)?  
5. **Historial:** ¿misma regla `eventDate` que Amigo Secreto o solo “completed + tiempo”?  
6. ¿Participantes sin app en sorteo simple en **v1** o solo miembros con app para reducir alcance?

---

## 19. Resumen ejecutivo

- La base actual es un **contenedor `groups` + sorteo secreto acoplado** (`drawStatus`, `executeDraw`, assignments, wishlist, chat post-draw).  
- La escalabilidad sana pasa por **tipar la dinámica**, **separar visibilidad de resultado**, **parametrizar capacidades** (chat, wishlist, entregas) y **estados general vs específicos**, **sin** migrar Firestore ni romper Amigo Secreto.  
- **“Dinámica”** es el término adecuado en ES; en otros idiomas definir equivalente en glosario.  
- **Primera implementación:** **Sorteo simple** con plan 9B que bifurque backend y UI sin contaminar flujos secretos.

---

## 20. Validación técnica (Fase 9A)

Solo se añade / actualiza este documento en `docs/`. **No** es obligatorio ejecutar `flutter analyze` ni `npm run build` para validar esta fase.

---

## 21. Checklist manual sugerida (post 9B, cuando se implemente)

- Crear sorteo simple y ejecutar en **es / en / pt**.  
- Verificar que Amigo Secreto existente sigue: sorteo, assignment privada, wishlist, chat.  
- Probar invitación y join cruzado (usuario en ambos tipos).  
- Revisar reglas Firestore en emulador para lecturas de resultado público vs secreto.

---

*Fin del documento Fase 9A.*
