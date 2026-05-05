# FUNCTIONAL_CONTRACT_V1 — Tarci Secret

Contrato funcional V1 para guiar la evolución del producto sin ambigüedad, preservando privacidad del sorteo y compatibilidad con el MVP actual.

## 1. Conceptos principales

### Identity (usuario de app)

Persona que inicia sesión en la app y opera desde un dispositivo.

Tipos previstos:

- anónimo/invitado;
- registrado con Google;
- registrado con Apple (futuro);
- registrado con email (futuro).

### Participant (participante de sorteo)

Persona que participa en un grupo de amigo secreto.  
Puede o no tener `Identity` vinculada.

### Por qué Identity y Participant no deben ser lo mismo

- permite participantes sin móvil o sin cuenta;
- permite niños gestionados por un adulto;
- evita acoplar login con lógica del sorteo;
- permite migración anónimo -> registrado sin romper grupos;
- soporta continuidad multi-dispositivo en futuro.

## 2. Tipos de participante

| participantType | Descripción | linkedUid | Puede entrar a app | Puede elegir subgrupo | Ve resultado directo | Quién entrega/ve resultado | Limitaciones |
|---|---|---|---|---|---|---|---|
| `app_anonymous` | Participante con sesión anónima | Opcional | Sí | Sí | Sí (si conserva sesión) | Solo él | Puede perder acceso al cambiar dispositivo/reinstalar |
| `app_registered` | Participante con cuenta registrada | Sí | Sí | Sí | Sí | Solo él | Requiere login registrado |
| `managed` | Participante sin cuenta app, gestionado | No | No | No directo | No | Owner/delegado | Entrega fuera de app |
| `child_managed` | Niño gestionado por adulto | No (normalmente) | No (normalmente) | No directo | No | Adulto responsable/delegado | Privacidad reforzada |
| `manual_owner_added` | Participante agregado manualmente por owner | No inicial | No inicial | No directo | No | Owner/delegado | Puede vincularse luego a cuenta app |

## 3. Roles dentro del grupo

Roles funcionales:

- `owner`
- `member`
- `managed_participant`
- `guardian_delegate` (si aplica en fase de gestionados)

Matriz de permisos (V1 funcional):

| Acción | owner | member | managed_participant | guardian_delegate |
|---|---:|---:|---:|---:|
| Crear grupo | Sí | No | No | No |
| Editar configuración de grupo | Sí | No | No | No |
| Crear subgrupos | Sí | No | No | No |
| Asignar subgrupo propio | Sí | Sí (solo propio) | No | No |
| Asignar subgrupo de otros | Sí | No | No | Sí (solo delegados) |
| Invitar | Sí | No (MVP) | No | Opcional |
| Ejecutar sorteo | Sí | No | No | No |
| Ver su asignación | Sí (solo propia) | Sí (solo propia) | No directo | Sí (solo delegadas) |
| Ver asignaciones delegadas | Sí (solo delegadas) | No | No | Sí |
| Wishlist futura | Sí (propia) | Sí (propia) | No directo | Sí (delegadas) |
| Responder preguntas futuras | Sí (propias) | Sí (propias) | No directo | Sí (delegadas) |

## 4. Modelo de datos recomendado

### Estado actual

- `groups/{groupId}/members/{uid}` funciona para participantes con app.
- Limitado para participantes sin cuenta/dispositivo.

### Evolución recomendada

Entidad principal futura:

- `groups/{groupId}/participants/{participantId}`

Campos sugeridos:

- `participantId`
- `displayName`
- `participantType`
- `linkedUid` (nullable)
- `managedByUid` (nullable)
- `managedByParticipantId` (nullable)
- `roleInGroup`
- `state` (`active|left|removed`)
- `subgroupId` (nullable)
- `deliveryMode` (`inApp|ownerDelegated|printed|verbal`)
- `canReceiveDirectResult` (bool)
- `createdAt`
- `updatedAt`

### Migración incremental (sin romper lo actual)

1. Mantener `members` como fuente activa en MVP actual.
2. Introducir `participants` en paralelo para nuevas capacidades.
3. Escribir ambos nodos temporalmente donde aplique.
4. Mover gradualmente lecturas críticas (ejecución/privacidad) a `participants`.
5. Deprecar dependencia de `members` cuando la paridad esté validada.

### Otros nodos

- `user_groups/{uid}/groups/{groupId}`: índice de navegación por usuario app.
- `assignments`: evolucionar a ids de participante + snapshots legibles.
- wishlist futura: `groups/{groupId}/wishlists/{participantId}`.

## 5. Entrega del resultado

### Usuario con app

Ve solo su asignación.

### Usuario registrado

Ve solo su asignación y puede recuperarla en otro dispositivo.

### Invitado anónimo

Ve solo su asignación mientras conserve sesión.

### Participante sin móvil

No ve resultado in-app. Lo entrega owner/delegado según `deliveryMode`.

### Niño gestionado

Resultado visible al adulto responsable/delegado, no al grupo completo.

## 6. Privacidad

Reglas de producto V1:

- owner no ve todas las asignaciones por defecto;
- cada participante ve solo su asignación;
- owner solo ve asignaciones delegadas explícitamente;
- no existe modo “ver todo” en MVP;
- códigos en claro no se persisten permanentemente;
- asignaciones se generan en backend;
- cualquier modo de emergencia futuro debe ser explícito y trazable.

## 7. Flujos funcionales

### Flujo A — Sorteo rápido anónimo

Crear grupo -> invitar -> unirse -> elegir subgrupo -> preparar -> ejecutar sorteo -> ver resultado propio.

### Flujo B — Grupo registrado

Login -> crear grupo -> invitar -> (futuro wishlist/preguntas) -> ejecutar -> resultado persistente multi-dispositivo.

### Flujo C — Participante sin móvil

Owner añade participante -> asigna subgrupo -> define entrega -> ejecuta sorteo -> owner/delegado entrega resultado.

### Flujo D — Niño gestionado

Adulto gestiona niño -> niño participa -> sorteo -> adulto recibe/gestiona entrega.

### Flujo E — Empresa/clase

Owner crea grupo -> define subgrupos por área/clase -> miembros se unen -> aplica regla -> ejecuta sorteo.

## 8. Modo rápido vs modo registrado

| Capacidad | Modo rápido/anónimo | Modo registrado |
|---|---:|---:|
| Crear grupo | Sí | Sí |
| Unirse por código | Sí | Sí |
| Elegir subgrupo | Sí | Sí |
| Ejecutar sorteo | Sí | Sí |
| Ver resultado propio | Sí | Sí |
| Recuperar grupos | Limitado | Sí |
| Multi-dispositivo | Limitado | Sí |
| Wishlist persistente | No | Sí |
| Preguntas/pistas | No | Sí |
| Notificaciones | No | Sí |
| Historial | No | Sí |

Funciones que deben exigir cuenta registrada:

- recuperación robusta;
- multi-dispositivo;
- wishlist persistente;
- preguntas/pistas persistentes;
- notificaciones;
- historial.

## 9. Wishlist, preguntas y pistas

Orden recomendado:

1. wishlist simple;
2. preguntas estructuradas;
3. pistas controladas;
4. chat libre solo si se justifica.

Evitar chat libre al inicio por:

- moderación y abuso;
- alta complejidad técnica;
- menor valor inmediato frente al núcleo del producto.

## 10. Idiomas

Idiomas objetivo:

- español
- inglés
- italiano
- portugués
- francés

Estrategia i18n:

- introducir en fase dedicada (tras estabilizar flujos);
- externalizar textos por llaves;
- evitar hardcodear textos nuevos;
- mantener glosario de dominio consistente.

Glosario clave:

- amigo secreto
- grupo
- subgrupo
- sorteo
- participante
- lista de deseos
- pistas

## 11. Wizard futuro de creación de grupo

Flujo recomendado:

1. nombre del grupo
2. tipo (familia / empresa / clase / amigos)
3. fecha del evento
4. presupuesto
5. subgrupos
6. regla del sorteo
7. invitaciones
8. revisión final

MVP inmediato del wizard:

- nombre;
- subgrupos (opcionales);
- regla;
- invitaciones.

Campos que pueden esperar:

- tipo;
- fecha;
- presupuesto;
- revisión enriquecida.

## 12. Plan por fases

### Fase 1 — Cerrar flujo principal actual

- Objetivo: robustez del flujo anónimo actual.
- Alcance: crear/invitar/unir/subgrupo/regla/preparar/ejecutar/ver resultado.
- No incluye: gestionados, auth social, wishlist.
- Aceptación: E2E estable en emulador y entorno dev real.

### Fase 2 — Participantes gestionados

- Objetivo: soportar participantes sin móvil y niños.
- Alcance: base `participants`, alta manual, delegación inicial.
- No incluye: notificaciones/chat.
- Aceptación: grupo mixto app+gestionados funciona end-to-end.

### Fase 3 — Resultado y privacidad delegada

- Objetivo: reforzar secreto por defecto.
- Alcance: lectura propia + delegada, sin “ver todo”.
- No incluye: modo emergencia global.
- Aceptación: owner no puede inspeccionar asignaciones globales.

### Fase 4 — Autenticación registrada

- Objetivo: continuidad real de usuario.
- Alcance: Google (Android), base Apple/email, vinculación anónimo->registrado.
- No incluye: social avanzado.
- Aceptación: recuperación multi-dispositivo validada.

### Fase 5 — i18n

- Objetivo: soporte multilenguaje operativo.
- Alcance: ES/EN/IT/PT/FR en flujos core.
- No incluye: rediseño visual total.
- Aceptación: cobertura funcional sin hardcode crítico.

### Fase 6 — Wishlist/preguntas/pistas

- Objetivo: enriquecer dinámica sin chat libre.
- Alcance: wishlist simple + preguntas + pistas controladas.
- No incluye: chat abierto.
- Aceptación: valor lúdico claro con privacidad y control.

### Fase 7 — UI final + branding

- Objetivo: acabado visual final de Tarci Secret.
- Alcance: polish UI/UX, consistencia visual, branding completo.
- No incluye: cambios arquitectónicos de datos.
- Aceptación: experiencia publicable y coherente.
