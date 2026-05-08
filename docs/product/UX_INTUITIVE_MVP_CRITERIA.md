# Criterios UX Intuitivos MVP — Tarci Secret / SecretSwap

## 1. Principio central

El MVP solo se considera usable si una persona no técnica puede completar el flujo principal sin explicación externa.

Cada pantalla debe responder en menos de 3 segundos:

1. Dónde estoy.
2. Qué falta.
3. Qué puedo hacer ahora.
4. Qué pasa si toco el botón principal.

## 2. Flujo humano mínimo

Una familia real debe poder:

1. Abrir la app.
2. Crear un amigo secreto.
3. Compartir código.
4. Unirse por código.
5. Añadir participantes sin app.
6. Añadir niños gestionados.
7. Crear subgrupos/casas.
8. Asignar participantes a subgrupos.
9. Entender si el grupo está listo.
10. Ejecutar sorteo.
11. Ver su resultado privado.
12. Ver resultados gestionados si corresponde.

Sin ayuda del creador de la app.

## 3. Criterios por pantalla

### 3.1 Splash / bienvenida

- Objetivo: orientar y llevar al flujo principal.
- Pregunta que debe responder: "¿Qué es esto y cómo empiezo?"
- Acción principal: comenzar/entrar.
- Acción secundaria: cambiar idioma o iniciar sesión.
- Textos prohibidos: términos técnicos internos (ver sección 4).
- Textos recomendados: "Crear amigo secreto", "Unirme con código".
- Señales visuales necesarias: título claro, botón principal dominante, estado de carga entendible.
- Errores UX bloqueantes: pantalla sin dirección clara o con múltiples CTA principales.
- Criterio de aceptación: un usuario no técnico entra al flujo correcto en el primer intento.

### 3.2 Dashboard

- Objetivo: mostrar estado general y siguiente paso.
- Pregunta que debe responder: "¿Qué hago ahora?"
- Acción principal: crear grupo o entrar al grupo activo.
- Acción secundaria: unirse por código.
- Textos prohibidos: `drawStatus`, `execution`, `assignment`.
- Textos recomendados: "En preparación", "Listo para sortear", "Falta completar participantes".
- Señales visuales necesarias: estado visible por grupo y CTA principal inequívoco.
- Errores UX bloqueantes: no se entiende si el grupo está listo para sorteo.
- Criterio de aceptación: el usuario identifica el próximo paso sin ayuda.

### 3.3 Crear grupo / wizard

- Objetivo: crear grupo de manera guiada y simple.
- Pregunta que debe responder: "¿Qué necesito para empezar?"
- Acción principal: crear grupo.
- Acción secundaria: volver/cancelar.
- Textos prohibidos: `uid`, `memberState`, `user_groups`.
- Textos recomendados: "Crear amigo secreto", "Nombre del grupo".
- Señales visuales necesarias: progreso simple, validaciones claras, confirmación final.
- Errores UX bloqueantes: campos ambiguos o errores sin explicación.
- Criterio de aceptación: el grupo se crea sin dudas ni pasos ocultos.

### 3.4 Unirse por código

- Objetivo: permitir ingreso rápido y confiable al grupo.
- Pregunta que debe responder: "¿Dónde pongo el código y qué pasa al enviarlo?"
- Acción principal: unirme con código.
- Acción secundaria: volver al inicio/dashboard.
- Textos prohibidos: "Group status", "Advanced settings".
- Textos recomendados: "Unirme con código", "Código de invitación".
- Señales visuales necesarias: campo único destacado, feedback inmediato, errores accionables.
- Errores UX bloqueantes: join falla sin causa entendible.
- Criterio de aceptación: un invitado entra al grupo en un intento normal.

### 3.5 Detalle del grupo

- Objetivo: centralizar el estado del grupo y el progreso del flujo.
- Pregunta que debe responder: "¿Qué falta para sortear?"
- Acción principal: completar pendientes o ejecutar sorteo.
- Acción secundaria: navegar a participantes/subgrupos.
- Textos prohibidos: `drawingLock`, `subgroupMode`.
- Textos recomendados: "Falta asignar subgrupos", "Regla del sorteo", "Listo para sortear".
- Señales visuales necesarias: checklist/indicadores de preparación.
- Errores UX bloqueantes: estado del grupo opaco o contradictorio.
- Criterio de aceptación: se entiende claramente si se puede o no sortear.

### 3.6 Participantes

- Objetivo: gestionar participantes con app de forma clara.
- Pregunta que debe responder: "¿Quién participa y quién falta?"
- Acción principal: añadir o editar participante.
- Acción secundaria: remover/gestionar estado permitido.
- Textos prohibidos: `memberState` como texto principal.
- Textos recomendados: "Participantes", "Añadir participante", "Activo".
- Señales visuales necesarias: lista legible con estado comprensible.
- Errores UX bloqueantes: no distinguir participantes activos de no elegibles.
- Criterio de aceptación: el owner entiende y mantiene el grupo sin confusión.

### 3.7 Subgrupos

- Objetivo: crear y explicar subgrupos/casas.
- Pregunta que debe responder: "¿Para qué sirve un subgrupo y cómo lo uso?"
- Acción principal: crear subgrupo.
- Acción secundaria: editar/eliminar subgrupo.
- Textos prohibidos: tecnicismos de reglas internas.
- Textos recomendados: "Subgrupos", "Casas", "Falta asignar subgrupos".
- Señales visuales necesarias: relación clara entre subgrupo y participantes.
- Errores UX bloqueantes: usuario no entiende para qué existe esta pantalla.
- Criterio de aceptación: usuario entiende valor y uso sin explicación externa.

### 3.8 Participantes gestionados

- Objetivo: administrar personas sin app y niños gestionados.
- Pregunta que debe responder: "¿Cómo incluyo personas que no usan la app?"
- Acción principal: añadir participante gestionado.
- Acción secundaria: editar/remover participante gestionado.
- Textos prohibidos: "Managed assignments" como etiqueta principal.
- Textos recomendados: "Participantes gestionados", "Añadir niño", "Guardar".
- Señales visuales necesarias: etiquetas simples que distingan con app vs gestionado.
- Errores UX bloqueantes: no se entiende diferencia entre participante con app y gestionado.
- Criterio de aceptación: el owner carga correctamente casos familiares mixtos.

### 3.9 Mi amigo secreto

- Objetivo: mostrar resultado privado individual.
- Pregunta que debe responder: "¿Quién me tocó a mí?"
- Acción principal: ver resultado privado.
- Acción secundaria: volver al dashboard/grupo.
- Textos prohibidos: `assignment`, `execution`.
- Textos recomendados: "Tu amigo secreto", "Resultado privado".
- Señales visuales necesarias: foco en privacidad y una sola asignación visible.
- Errores UX bloqueantes: exposición de datos de terceros.
- Criterio de aceptación: el usuario ve solo su asignación y lo entiende al instante.

### 3.10 Secretos que gestionas

- Objetivo: mostrar únicamente resultados gestionados por el responsable.
- Pregunta que debe responder: "¿Qué secretos debo gestionar yo?"
- Acción principal: revisar secretos gestionados.
- Acción secundaria: volver al grupo/dashboard.
- Textos prohibidos: "Managed assignments" como título principal.
- Textos recomendados: "Secretos que gestionas", "Guardián del secreto".
- Señales visuales necesarias: separación explícita entre mis datos y datos gestionados.
- Errores UX bloqueantes: mostrar resultados globales o no gestionados.
- Criterio de aceptación: responsable entiende su alcance sin acceder a información global.

## 4. Textos prohibidos para usuario final

No deben aparecer como textos visibles principales:

- Group status
- Advanced settings
- Managed assignments
- subgroupMode
- execution
- assignment
- uid
- memberState
- drawStatus
- drawingLock
- user_groups

## 5. Textos recomendados

Usar lenguaje humano:

- En preparación
- Listo para sortear
- Falta completar participantes
- Falta asignar subgrupos
- Crear amigo secreto
- Unirme con código
- Regla del sorteo
- Tu amigo secreto
- Secretos que gestionas
- Guardián del secreto
- Resultado privado

## 6. Prueba de usuario no asistida

Prueba manual recomendada:

Entregar la app a una persona no técnica e indicar únicamente:
"Crea un amigo secreto para tu familia e invita a alguien con código."

Registrar:

- si entiende qué hacer;
- dónde se atasca;
- si pregunta algo;
- si entiende cuándo está listo para sortear;
- si entiende su resultado;
- si entiende la privacidad;
- tiempo aproximado para completar el flujo;
- pantallas donde duda.

## 7. Criterios bloqueantes UX

Bloquea publicación si:

- el usuario no entiende cómo crear grupo;
- no entiende cómo invitar;
- no entiende si falta algo antes de sortear;
- no encuentra cómo volver al dashboard;
- no entiende diferencia entre participante con app y gestionado;
- no entiende qué es un subgrupo/casa;
- ve textos técnicos;
- ve mezcla de idiomas;
- ve botones principales compitiendo;
- necesita explicación externa para completar el flujo.
