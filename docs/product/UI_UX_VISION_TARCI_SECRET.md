# UI/UX Vision - Tarci Secret (Fase 3 MVP)

## 0) Objetivo del documento

Definir una vision funcional y visual profesional para la Fase 3 de Tarci Secret, enfocada en elevar la experiencia de uso del MVP sin ampliar alcance tecnico de backend ni cambiar la logica central ya validada.

Este documento sirve como referencia de producto, diseño UX/UI y priorizacion de implementacion.

---

## 1) Principios de UX

Tarci Secret debe sentirse:

- **Calida:** visualmente amable, lenguaje cercano y humano.
- **Sencilla:** cada pantalla responde a una pregunta concreta y ofrece una accion principal clara.
- **Moderna:** componentes limpios, jerarquia visual clara y microinteracciones suaves.
- **Divertida:** tono ludico y emocional sin sacrificar claridad.
- **Segura y privada:** reforzar constantemente que el secreto se protege por defecto.
- **Multicontexto:** util para familias, adolescentes y empresas sin cambiar la esencia.

Principios operativos:

1. **Un paso, una decision:** evitar formularios largos en una sola pantalla.
2. **Primero claridad, luego detalle:** resumen arriba, informacion secundaria debajo.
3. **Acciones principales visibles:** CTA primario fijo o claramente destacado.
4. **Estado siempre explicito:** sorteo en curso, listo, completado, bloqueado.
5. **Lenguaje humano:** evitar tecnicismos y mensajes ambiguos.
6. **Privacidad visible:** recordar en momentos clave que cada resultado es personal y secreto.

---

## 2) Tono de marca

Tarci Secret comunica:

- **Secreto** (confianza, discrecion, intimidad).
- **Regalo** (generosidad, detalle, ilusion).
- **Sorpresa** (descubrimiento y emocion).
- **Union** (personas que se conectan).
- **Familia** (cercania y calidez).
- **Juego** (dinamica social divertida).
- **Privacidad** (control y tranquilidad).
- **Ilusion** (expectativa positiva antes del evento).

Guia de voz:

- **Corta y positiva:** frases breves, accionables, sin ruido.
- **Cercana:** "Tu", "Tienes", "Te toca regalar a...".
- **Empatica:** orientar sin culpar ("conviene asignar subgrupo...").
- **Firme cuando importa:** bloqueos y reglas criticas con copy directo.

---

## 3) Flujo inicial (Onboarding y entrada)

### 3.1 Splash screen

Objetivo: presentar marca en 1-2 segundos y transmitir calidez.

- Logo Tarci Secret centrado.
- Fondo limpio con acento cromatico de marca.
- Microanimacion suave (opcional, no intrusiva).

### 3.2 Deteccion de idioma del movil

- Detectar idioma del sistema al abrir por primera vez.
- Mostrar confirmacion no intrusiva:
  - "Idioma detectado: Espanol"
  - Opcion: "Cambiar idioma"

### 3.3 Seleccion manual de idioma

Idiomas objetivo:

- Espanol
- Ingles
- Italiano
- Portugues
- Frances

Reglas UX:

- Lista clara con nombre nativo del idioma.
- Confirmacion inmediata.
- Posibilidad de cambiar despues desde ajustes.

### 3.4 Bienvenida

Pantalla breve con propuesta de valor:

- "Organiza tu amigo secreto de forma simple, divertida y privada."
- CTA primario: **Continuar**
- CTA secundario: **Cambiar idioma**

### 3.5 Modo rapido vs iniciar sesion

Objetivo: reducir friccion y mantener escalabilidad.

- Opcion A: **Modo rapido/anónimo** (entrar ya).
- Opcion B: **Iniciar sesion** (continuidad multi-dispositivo).

Copy recomendado:

- "Puedes empezar en segundos con modo rapido."
- "Si quieres guardar y sincronizar mejor, inicia sesion."

### 3.6 Entrada al Dashboard

Despues de bienvenida/modo:

- Si tiene grupos: abrir dashboard con actividad.
- Si no tiene grupos: dashboard vacio con acciones de creacion y union.

---

## 4) Dashboard

## 4.1 Usuario con grupos

Secciones:

1. **Grupos activos**
   - Cards resumidas (nombre, fecha, estado, accion principal).
2. **Grupos completados**
   - Historial reciente con acceso a resultados.
3. **Acciones rapidas**
   - Crear nuevo grupo
   - Unirse por codigo

Card de grupo (contenido minimo):

- Nombre del grupo
- Estado (Preparando / Listo / Completado)
- Participantes
- Fecha del evento (si existe)
- CTA contextual:
  - "Continuar preparacion"
  - "Ver mi amigo secreto"
  - "Ver resultados gestionados" (si aplica)

### 4.2 Usuario sin grupos

Dashboard de arranque con opciones:

- **Crear amigo secreto** (destacado principal del MVP).
- **Crear duelo o batalla** (etiqueta: Proximamente).
- **Crear equipos** (etiqueta: Proximamente).
- **Unirse por codigo**.

Objetivo UX: mostrar vision de plataforma sin distraer del flujo MVP.

---

## 5) Seleccion de dinamica

Tarci Secret debe estar preparada para:

- Amigo secreto
- Batallas / duelos
- Equipos
- Parejas
- Sorteos sociales

Decision de producto MVP:

- **Prioridad total: Amigo secreto**
- Otras dinamicas visibles como roadmap de producto (no flujo completo aun).

Recomendacion visual:

- Selector en forma de cards.
- Amigo secreto primero y marcado como "Recomendado".
- Otras cards con badge "Proximamente".

---

## 6) Wizard de Amigo Secreto

Objetivo: configurar un grupo de forma guiada, clara y sin fricciones.

Estructura general:

- Progreso visible (Paso X de 9).
- CTA primario fijo: **Continuar**.
- CTA secundario: **Atras**.
- Guardado progresivo cuando sea posible.

Pasos:

1. **Nombre del grupo**
   - Ej: "Navidad Familia 2026"
2. **Tipo de grupo**
   - Familia, amigos, empresa, clase, otro
3. **Participas tu**
   - Si / No
4. **Fecha del evento**
   - Opcional recomendada
5. **Presupuesto**
   - Opcional
6. **Subgrupos**
   - Crear/seleccionar casas, departamentos, equipos
7. **Regla del sorteo**
   - Ignorar / Preferir distinto / Exigir distinto
8. **Participantes e invitaciones**
   - Con app, sin app, ninos gestionados
9. **Revision final**
   - Resumen editable y CTA: **Crear grupo**

Reglas de contenido:

- Helper text corto por paso.
- Validaciones explicadas en lenguaje humano.
- No bloquear por subgrupos incompletos salvo regla "exigir distinto".

---

## 7) Pantalla de grupo (reorganizacion visual)

Objetivo: convertir la pantalla actual en un centro de control claro.

Orden recomendado:

1. **Header de estado del sorteo**
   - Estado actual + CTA principal contextual
2. **Acciones principales**
   - Ejecutar sorteo / Ver mi asignacion / Ver gestionados
3. **Invitaciones**
   - Codigo y compartir
4. **Participantes**
   - Con app y estado rapido
5. **Participantes sin app**
   - Tipo, subgrupo/sin subgrupo, entrega, gestionado por
6. **Subgrupos**
   - Lista y estado de cobertura
7. **Reglas**
   - Modo actual + explicacion de impacto
8. **Preparacion**
   - Checklist de disponibilidad y advertencias

Lineamientos de claridad:

- Mostrar siempre conteos clave.
- Diferenciar advertencia suave vs advertencia fuerte.
- Mantener acciones bloqueadas con explicacion visible.

---

## 8) Pantalla de resultado (emocional)

Objetivo: maximizar emocion y claridad en el momento clave.

Elementos:

- Titulo protagonista: **"Te toca regalar a..."**
- Nombre de la persona destacada (tipografia mayor).
- Mensaje de secreto:
  - "Este resultado es privado. No lo compartas en el grupo."
- Informacion complementaria:
  - Subgrupo (si existe)
  - Nota futura de wishlist (placeholder)
- Acciones:
  - **Volver al grupo**
  - Futuro: **Ver wishlist**

Estilo:

- Espacio visual limpio.
- Enfasis emocional sin saturacion.
- Iconografia discreta de regalo/secreto.

---

## 9) Pantalla de resultados gestionados

Objetivo: permitir entregar resultados a ninos/personas sin app con seguridad.

Mensaje contextual obligatorio:

> "Estos son los resultados de las personas que gestionas. Entregaselos de forma privada."

Estructura:

- Lista por participante gestionado
  - Nombre
  - Tipo (adulto sin app / nino gestionado)
  - Subgrupo o "Sin subgrupo"
  - Resultado asignado
  - Forma de entrega sugerida (verbal/impresa)

Reglas UX:

- Nunca mostrar resultados que no gestiona el usuario.
- Reforzar privacidad en header y pie de pantalla.

---

## 10) Componentes visuales

Sistema propuesto (MVP-friendly):

### 10.1 Cards

- Card base para grupos, resumenes y bloques de configuracion.
- Variantes: neutra, destacada, estado exito, estado advertencia.

### 10.2 Botones

- Primario: accion principal de la pantalla.
- Secundario: acciones complementarias.
- Tertiario/texto: acciones de bajo peso.

### 10.3 Chips

- Estado de grupo (Activo, Completado, Pendiente).
- Tipo de participante (Con app, Sin app, Nino).
- Subgrupo.

### 10.4 Iconos

- Regalo, candado, personas, grupo, calendario, etiqueta.
- Uso consistente y siempre con texto de apoyo.

### 10.5 Estados

- Carga
- Vacio
- Error recuperable
- Exito
- Bloqueo por regla

### 10.6 Colores (direccion)

- Base clara y limpia.
- Acento calido para acciones principales.
- Color neutro para texto secundario.
- Advertencia suave y fuerte diferenciadas.
- Contraste accesible para legibilidad.

### 10.7 Microinteracciones

- Feedback inmediato en cambios de regla/guardado.
- Transiciones suaves entre pasos del wizard.
- Confirmaciones breves para acciones sensibles.

### 10.8 Ilustraciones (opcionales)

- Escenas ligeras: regalo, grupo, secreto.
- Estilo amable, no infantil extremo.
- Uso en estados vacios y bienvenida.

---

## 11) Prioridades de implementacion

### 11.1 Implementar primero (Fase 3 MVP)

1. Splash
2. Bienvenida
3. Dashboard mejorado
4. Wizard de amigo secreto
5. Detalle de grupo reorganizado

Resultado esperado:

- UX consistente extremo a extremo en flujo MVP.
- Menor friccion en creacion/configuracion.
- Mayor comprension de privacidad y estados.

### 11.2 Implementar despues

- Login registrado completo
- Wishlist
- Preguntas y pistas
- Batallas/equipos (dinamicas nuevas)
- i18n completa en toda la app

---

## 12) Criterios de exito UX (MVP)

1. Usuario nuevo crea grupo en pocos minutos sin ayuda externa.
2. El usuario entiende cuando puede sortear y por que no puede.
3. El resultado personal se percibe como emocionante y privado.
4. Gestionar participantes sin app se entiende sin friccion.
5. La experiencia se percibe moderna, calida y confiable.

---

## 13) Notas de alcance

- Este documento define **vision UX/UI**.
- No implica cambios de backend ni de reglas de seguridad.
- No cambia la logica de sorteo existente.
- Prioriza mejoras de experiencia, copy, estructura visual y consistencia.

