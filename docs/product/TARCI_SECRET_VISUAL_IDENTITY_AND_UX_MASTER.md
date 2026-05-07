# Tarci Secret - Visual Identity and UX Master

## 0) Declaracion oficial de identidad fusionada

**Tarci Secret es una app calida, privada y social para organizar dinamicas de grupo con personas reales. Su primer ritual completo es el amigo secreto, incluyendo usuarios con app, personas sin app y ninos gestionados.**

Este documento consolida la direccion oficial de identidad visual y UX para llevar Tarci Secret a un MVP visualmente publicable, manteniendo la logica funcional actual.

---

## 1) Diagnostico

Tarci Secret ya tiene un nucleo funcional solido:

- modo rapido/anonimo;
- crear grupo;
- unirse por codigo;
- participantes con app;
- participantes sin app;
- ninos gestionados;
- subgrupos;
- reglas de sorteo;
- sorteo backend;
- resultado propio;
- resultados gestionados;
- privacidad por asignacion;
- separacion entre usuario de app y participante real.

Diagnostico clave:

- la app no debe verse como una utility generica de sorteos;
- debe percibirse como una app de rituales sociales;
- el problema principal actual no es tecnico, es de percepcion visual y emocional;
- privacidad e inclusion deben verse en la UI, no solo existir en backend.

---

## 2) Identidad fusionada

Base oficial fusionada:

- **concepto estrategico:** app de rituales sociales;
- **estilo visual:** warm minimalism;
- **marca emocional:** Tarci como asistente familiar y guardiana del secreto.

Interpretacion operacional:

- menos interfaz "tecnica" y mas experiencia "ritual";
- menos bloques frios y mas momentos guiados;
- lenguaje humano, cercano y claro;
- identidad reconocible sin infantilizar.

---

## Vision de producto: MVP actual y expansion futura

### MVP actual

El foco absoluto de producto es cerrar al 100% el flujo de amigo secreto / intercambio de regalos:

- crear grupo;
- invitar o unirse por codigo;
- participantes con app;
- participantes sin app;
- ninos gestionados;
- subgrupos;
- reglas de sorteo;
- sorteo backend;
- resultado propio;
- resultados gestionados;
- privacidad por asignacion;
- wizard de amigo secreto;
- resultado emocional.

### Expansion futura

Despues de cerrar el MVP, Tarci Secret puede expandirse hacia dinamicas adicionales:

- sorteos simples;
- emparejamientos;
- equipos;
- duelos/batallas;
- parejas;
- torneos simples;
- competiciones de padel;
- dinamicas de oficina;
- dinamicas de colegios/clases;
- grupos por departamentos, casas, salones o equipos.

Regla de alcance:

- esta expansion no se implementa ahora;
- primero se completa y estabiliza el amigo secreto.

---

## 3) Pilares de diseno

### 3.1 Calidez familiar

- tono cercano y amable;
- formas suaves, buen espaciado y lectura facil;
- interfaz acogedora para familia, amigos, empresa y colegio.

### 3.2 Privacidad visible

- la interfaz debe recordar que cada asignacion es privada;
- mensajes de confidencialidad en momentos sensibles;
- acciones y textos que reduzcan riesgo de exposicion.

### 3.3 Inclusion real

- representar claramente personas con app y sin app;
- visibilizar ninos gestionados y responsables;
- no excluir casos reales por exigir cuenta o movil.

### 3.4 Simplicidad guiada

- una accion principal por pantalla;
- pasos cortos y comprensibles;
- decisiones complejas explicadas con copy simple.

### 3.5 Momento memorable de revelacion

- el resultado personal debe sentirse especial;
- revelacion privada con carga emocional positiva;
- claridad absoluta sobre que hacer despues.

---

## Principio de diseno expansible

La UI de Tarci Secret debe sentirse calida y emocional, pero no puede quedar limitada visualmente solo a:

- Navidad;
- regalos;
- familia;
- ninos.

Debe poder adaptarse despues a contextos como:

- oficina;
- colegio;
- deporte;
- juegos;
- equipos;
- sorteos sociales.

Regla central:

- la identidad puede usar regalo, secreto y Tarci como base de marca;
- los componentes base deben ser flexibles para soportar dinamicas futuras sin rehacer toda la interfaz.

---

## 4) Paleta oficial recomendada

### 4.1 Colores base

- **Primary:** `#4A235A` (deep purple) - marca, secreto, confianza.
- **Background:** `#FDFBF7` (warm bone) - fondo calido general.
- **Surface:** `#FFFFFF` / `#FFFBF8` - tarjetas y contenedores.
- **Accent coral:** `#F05454` (o variante mas suave) - energia puntual, CTA y foco.
- **Secret/lacre:** `#9E4E32` - mensajes de secreto/entrega.
- **Gold:** `#C9A96E` - valor emocional/premium.
- **Sage:** `#7C9A7E` - estados positivos, calma y balance.

### 4.2 Reglas de uso

- usar `Primary` para jerarquia y elementos de marca;
- usar `Background` + `Surface` para limpieza y legibilidad;
- usar coral como acento, no como color dominante;
- usar `Secret/lacre` en etiquetas o cues de privacidad/ritual;
- usar `Gold` de forma medida para detalles premium;
- usar `Sage` para confirmaciones suaves y estados listos.

---

## 5) Tipografia

Tipografia principal recomendada: **Plus Jakarta Sans**.

Motivos:

- moderna y clara en interfaces de producto;
- calida sin parecer infantil;
- profesional sin verse editorial o distante;
- excelente legibilidad en tamanos pequenos y medianos;
- funciona bien para titulos, cuerpo, pills y botones.

Evitar:

- fuentes excesivamente infantiles;
- fuentes demasiado editoriales o ceremoniales para uso continuo;
- combinaciones de muchas familias tipograficas.

---

## 6) Componentes base oficiales

### TarciScaffold

**Proposito:** estructura base de pantalla (fondo, paddings, safe area, ritmo visual).  
**Uso:** todas las pantallas principales para consistencia.

### TarciHeader

**Proposito:** encabezado de contexto con marca y mensaje corto.  
**Uso:** dashboard, detalle y pasos del wizard.

### TarciCard

**Proposito:** contenedor visual base para secciones de contenido y acciones.  
**Uso:** bloques de estado, listas, resumenes y tarjetas de grupo.

### SecretCard

**Proposito:** destacar contenido sensible/privado con tono emocional.  
**Uso:** revelacion de resultado, advertencias de privacidad y entrega.

### PersonTile

**Proposito:** fila estandar para personas con app (rol, estado, subgrupo).  
**Uso:** listas de miembros y participantes directos.

### GuardianTile

**Proposito:** fila para personas gestionadas (adulto sin app/nino + responsable).  
**Uso:** seccion de participantes sin app y resultados delegados.

### StatusPill

**Proposito:** estado corto y escaneable (activo, completado, pendiente, etc.).  
**Uso:** dashboard, detalle de grupo y resumenes.

### WizardStepCard

**Proposito:** encapsular cada paso del wizard con helper text y validacion clara.  
**Uso:** flujo de creacion/preparacion de amigo secreto.

### EmptyState

**Proposito:** evitar pantallas vacias frias, orientando siguiente accion.  
**Uso:** dashboard sin grupos, listas vacias y estados iniciales.

### WarningBox

**Proposito:** mostrar alertas y bloqueos con severidad diferenciada.  
**Uso:** preparacion del sorteo, regla incompatible, faltantes.

### PrimaryButton

**Proposito:** accion dominante de pantalla.  
**Uso:** una por pantalla o seccion principal.

### SecondaryButton

**Proposito:** accion complementaria sin competir con CTA principal.  
**Uso:** navegacion secundaria, acciones de apoyo.

---

## 7) Dashboard ideal

Objetivo: entrada premium, clara y no saturada.

Debe incluir:

- logo/icono Tarci visible;
- una sola accion principal: **Crear amigo secreto**;
- accion secundaria: **Unirme con codigo**;
- grupos activos;
- grupos completados;
- bloque "Proximamente" minimizado;
- sin debug visible en experiencia de usuario final;
- sin CTA duplicados.

Direccion de producto:

- en el futuro el dashboard puede incluir selector de dinamica;
- en el MVP, la accion principal sigue siendo solo **Crear amigo secreto**;
- **Unirme con codigo** se mantiene como accion secundaria;
- las dinamicas futuras se muestran como "Proximamente" sin competir con el flujo MVP.

Regla de experiencia:

- claridad de 5 segundos: usuario entiende inmediatamente que puede crear o unirse.

---

## 8) Wizard ideal

El wizard actual es especifico para amigo secreto.

Secuencia oficial (MVP actual):

1. Ocasion / nombre.
2. Tipo de grupo.
3. Modalidad: presencial / remoto / mixto.
4. Participas tu?
5. Regla del sorteo.
6. Subgrupos si aplica.
7. Participantes.
8. Revision final.

Nota critica:

- la **regla del sorteo** debe aparecer antes que subgrupos/participantes porque condiciona la preparacion y las advertencias.

Principios del wizard:

- pasos cortos;
- progreso visible;
- validaciones legibles;
- resumen final accionable.

Vision futura:

- wizard de amigo secreto;
- wizard de equipos;
- wizard de emparejamientos;
- wizard de torneos simples.

Regla de alcance:

- en esta fase solo se implementa el wizard de amigo secreto.

---

## 9) GroupDetailScreen ideal

Orden recomendado:

1. Header.
2. Estado.
3. Accion principal.
4. Regla del sorteo.
5. Subgrupos.
6. Participantes con app.
7. Participantes sin app / gestionados.
8. Invitaciones.
9. Configuracion avanzada.

Objetivo:

- reducir carga cognitiva;
- mostrar primero decisiones criticas;
- alinear orden visual con flujo real de preparacion.

---

## 10) Pantallas emocionales

### Mi amigo secreto

- tratarla como revelacion privada;
- titulo emocional claro;
- mensaje de confidencialidad visible;
- resultado protagonista y limpio.

### Resultados gestionados

- renombrar/posicionar como **Secretos que gestionas**;
- reforzar rol de **Guardian del secreto**;
- guiar entrega privada para adultos sin app y ninos gestionados;
- mostrar subgrupo cuando exista para mejor contexto.

---

## 11) Gestion de personas reales

UX esperada por perfil:

- **Usuario con app:** ve su asignacion privada, participa directamente.
- **Adulto sin app:** participa mediante gestion delegada.
- **Nino gestionado:** participa con entrega por responsable.
- **Responsable/guardian del secreto:** ve solo resultados que le corresponde gestionar.
- **Caso futuro (miembro con app anade a su hijo):** debe encajar en el mismo modelo de gestion delegada, sin romper privacidad ni flujo actual.

Principio:

- la UX debe mostrar claramente que "usuario de app" y "participante real" no siempre son la misma entidad.

---

## 12) Que NO hacer todavia

No incluir en esta fase:

- no chat;
- no wishlist;
- no WhatsApp/email automatico;
- no notificaciones push avanzadas;
- no i18n completo todavia;
- no refactor masivo;
- no redisenar backend;
- no cambiar modelo de datos;
- no romper privacidad.

Tambien fuera de alcance:

- no cambios de contratos tecnicos existentes;
- no cambios de logica central de sorteo/asignaciones.

---

## Que NO debe ocurrir

- no convertir Tarci Secret en una app solo navidena;
- no disenar todo como si siempre hubiera regalos;
- no meter dinamicas futuras antes de cerrar amigo secreto;
- no crear una arquitectura visual rigida;
- no saturar el dashboard con opciones futuras;
- no perder la privacidad como principio central.

---

## 13) Roadmap visual por PRs pequenos

### PR-UX-01

- limpiar dashboard;
- remover/debug ocultar en experiencia final;
- eliminar CTA duplicado;
- introducir cards base y jerarquia inicial.

### PR-UX-02

- aplicar `TarciCard`;
- aplicar `PersonTile`;
- aplicar `GuardianTile`.

### PR-UX-03

- reordenar `GroupDetailScreen` segun orden oficial.

### PR-UX-04

- implementar wizard profesional con pasos oficiales.

### PR-UX-05

- mejorar pantalla **Mi amigo secreto** como revelacion privada.

### PR-UX-06

- mejorar pantalla de resultados gestionados como **Secretos que gestionas**.

### PR-i18n-Base

- preparar infraestructura visual/textual para multiidioma sin ejecutar i18n completo aun.

---

## 14) Cierre estrategico

Tarci Secret compite primero por ofrecer el mejor amigo secreto privado, inclusivo y bonito.

Su vision futura es convertirse en una plataforma ligera de dinamicas privadas de grupo.

Direccion final:

- mantener la logica actual;
- elevar percepcion visual y emocional;
- cerrar MVP de amigo secreto antes de expandir dinamicas;
- avanzar por PRs pequenos y seguros;
- construir una marca memorable con base flexible para crecimiento futuro.
