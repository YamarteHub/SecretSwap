# Fase 4 - Premium UX and Brand Plan (Tarci Secret)

## 0) Objetivo del documento

Definir una fase de implementacion incremental para transformar Tarci Secret de "app funcional" a "MVP visualmente publicable", sin romper el flujo validado ni ampliar alcance tecnico de backend.

Este plan prioriza experiencia visual, claridad de uso y consistencia de marca antes de implementar funciones avanzadas (login, chat, wishlist, i18n completo u otras dinamicas).

Referencias de contexto:

- `docs/product/COMPETITOR_ANALYSIS_AND_PRODUCT_OPPORTUNITIES.md`
- `docs/product/UI_UX_VISION_TARCI_SECRET.md`
- `docs/product/PHASE3_IMPLEMENTATION_PLAN.md`
- `docs/product/PHASE2_BLUEPRINT.md`
- `docs/decisions/DECISIONS_LOG.md`

---

## 1) Diagnostico actual

Tarci Secret ya tiene nucleo funcional robusto:

- modo rapido/anonimo;
- crear grupo;
- unirse por codigo;
- subgrupos;
- reglas de sorteo;
- participantes con app;
- participantes sin app;
- ninos gestionados;
- sorteo en backend;
- asignacion propia;
- resultados gestionados;
- edicion previa al sorteo;
- bloqueo tras sorteo;
- validaciones importantes;
- dashboard inicial.

Brecha actual: la app funciona, pero todavia se percibe tecnica, poco ordenada y visualmente por debajo de nivel publicable.

Aspectos a mejorar en esta fase:

- jerarquia visual global;
- claridad de flujo (entrada -> creacion -> sorteo -> resultado);
- dashboard con estructura premium;
- detalle de grupo con orden de informacion;
- wizard mas guiado y profesional;
- uso consistente del logo/identidad;
- pantallas de resultado con emocion + privacidad;
- lenguaje de producto mas humano y claro;
- sensacion premium sin complejidad innecesaria.

---

## 2) Principios visuales

La Fase 4 debe ejecutar una direccion visual coherente con estos criterios:

- **calida:** cercana, humana, amable;
- **limpia:** sin ruido ni sobrecarga;
- **moderna:** tipografia clara, espaciado consistente, jerarquia fuerte;
- **premium:** acabados visuales cuidados, sin recargar;
- **familiar:** comprensible para hogares y grupos de amigos;
- **emocional:** celebra regalo y sorpresa sin exageracion infantil;
- **privada:** refuerza secreto y confianza;
- **no infantil:** evitar ilustracion o copy excesivamente caricaturesco;
- **no corporativa fria:** evitar estilo rigido o distante;
- **usable por adultos, jovenes y empresas:** neutralidad inteligente por contexto.

Regla transversal de UX:

> Una pantalla, una accion principal clara.

---

## 3) Uso de marca

Activos existentes a utilizar sin redisenar en esta fase:

- `imagenes/Icono TarciSecret.png`
- `imagenes/Logo TarciSecret.png`

Objetivo: definir uso correcto y consistente segun contexto.

### Criterios de aplicacion

- **Icono de app:** usar en contextos compactos (avatar visual, encabezados de modulo, accesos rapidos, placeholders de grupo).
- **Logo completo:** usar en pantallas de entrada y momentos de marca (splash, bienvenida, portada principal).
- **Splash:** composicion limpia con protagonismo de marca; evitar texto excesivo.
- **Dashboard:** branding sobrio en header (sin competir con CTA principal).
- **Pantalla de bienvenida:** valor de producto + marca, con copy breve.
- **Estados vacios:** uso ligero de iconografia/ilustracion de marca para calidez, sin bloquear legibilidad.
- **Iconografia funcional:** consistente con semantica de regalo, secreto, personas, grupo y estado.

Nota de alcance:

- No modificar imagenes ni generar nuevas versiones en esta etapa.
- Solo definir reglas de uso y placement.

---

## 4) Design System minimo

Objetivo: crear una base reusable para acelerar coherencia visual sin rediseno total de golpe.

Componentes minimos propuestos y que deben resolver:

- **AppScaffold**
  - estructura base de pantalla (fondo, paddings, safe areas, scroll, header opcional).
  - asegura consistencia de layout entre home, wizard, detalle y resultados.

- **SectionCard**
  - contenedor estandar para bloques de informacion/accion.
  - unifica sombras, radios, espaciados y jerarquia de secciones.

- **PrimaryButton**
  - CTA principal de cada pantalla.
  - jerarquia visual fuerte y estado disabled/loading estandar.

- **SecondaryButton**
  - accion secundaria de apoyo.
  - contraste correcto sin competir con CTA principal.

- **StatusChip**
  - etiqueta compacta de estado (activo, listo, completado, advertencia).
  - lectura rapida de estado sin texto largo.

- **ParticipantTile**
  - representacion consistente de participante (tipo, estado, subgrupo).
  - evita listas desordenadas y mejora escaneo.

- **SubgroupTile**
  - bloque para subgrupo con conteos/cobertura.
  - simplifica entendimiento de asignacion por subgrupos.

- **EmptyState**
  - estado vacio con mensaje, accion y tono emocional equilibrado.
  - evita pantallas frias o ambiguas.

- **ResultCard**
  - contenedor premium de resultado personal/gestionado.
  - combina emocion (momento regalo) y privacidad (mensaje claro).

- **WarningBox**
  - advertencias/validaciones con severidad visual controlada.
  - diferencia aviso suave vs bloqueo real.

- **PremiumHeader**
  - encabezado reusable con marca ligera + contexto de pantalla.
  - mejora consistencia y evita headers improvisados.

---

## 5) Fase 4A - Aplicar tema visual base

### Objetivo

Establecer la base visual comun para toda la app:

- colores;
- tipografia;
- espaciados;
- cards;
- botones;
- chips;
- uso de logo;
- estados visuales.

### Entregables

- tokens visuales base (color, texto, spacing);
- estilos de componentes minimos;
- estructura base para headers/cards/botones/chips;
- guia de aplicacion rapida por pantalla.

### Restricciones obligatorias

- no tocar backend;
- no tocar Firestore Rules;
- no tocar logica de sorteo;
- no tocar `executeDraw`;
- no cambiar modelo de datos.

---

## 6) Fase 4B - Wizard profesional de amigo secreto

Wizard propuesto:

1. Nombre del grupo.
2. Modalidad: remoto / presencial / mixto.
3. Participas tu?
4. Participantes.
5. Subgrupos: si/no.
6. Regla del sorteo.
7. Revision final.
8. Crear grupo o finalizar preparacion.

### Criterio de persistencia (backend-aware)

Campos que se pueden persistir ya (si backend actual los soporta):

- nombre de grupo;
- participas tu;
- participantes (con app/sin app/ninos gestionados);
- subgrupos y asignaciones;
- regla de sorteo disponible;
- estado de preparacion previo al sorteo.

Campos que pueden mostrarse como UI preparada para futuro (sin persistencia nueva por ahora):

- modalidad remoto/presencial/mixto como selector visual no bloqueante si no existe campo en backend;
- ayudas de copy/contexto por tipo de uso (familia/empresa/colegio);
- metadatos de experiencia no criticos.

Regla de implementacion:

- nunca bloquear el flujo por datos que aun no existan en backend.

---

## 7) Fase 4C - Reorganizar GroupDetailScreen

Orden final propuesto:

1. Header.
2. Estado del sorteo.
3. Accion principal.
4. Preparacion.
5. Participantes.
6. Subgrupos.
7. Participantes sin app.
8. Invitaciones.
9. Regla.

### Objetivo UX

- convertir la pantalla en centro de control claro;
- mostrar primero lo decisivo para avanzar;
- mover secciones secundarias abajo sin perder acceso;
- reforzar bloqueos y validaciones con `WarningBox`.

---

## 8) Fase 4D - Pantallas de resultado premium

Pantallas a mejorar:

- Mi amigo secreto.
- Resultados gestionados.

### Resultado esperado

- mas emocion en el momento clave ("te toca regalar a...");
- privacidad explicitamente reforzada;
- claridad de lectura y accion;
- entrega privada mejor guiada para gestionados;
- subgrupo visible si existe.

### Reglas de privacidad visual

- no mostrar informacion que el usuario no deba ver;
- recordar contexto privado en copy de cabecera;
- evitar ambiguedad en resultados gestionados.

---

## 9) Fase 4E - Splash / bienvenida / idioma basico

Alcance: solo entrada visual y narrativa inicial. No i18n completo.

Debe contemplar:

- logo;
- mensaje de valor;
- entrada en modo rapido;
- opcion visible "crear cuenta proximamente" (informativa, no funcional completa);
- deteccion de idioma como roadmap (no implementacion completa en esta fase).

Objetivo:

- primer impacto de marca consistente con app premium y calida;
- menor friccion para empezar en segundos.

---

## 10) Que NO hacer todavia

No implementar en esta fase:

- no usuarios registrados completos;
- no chat libre;
- no wishlist;
- no SMS/email automatico;
- no batallas/equipos;
- no refactor masivo transversal;
- no rehacer backend;
- no romper el flujo validado actual.

Tambien queda fuera:

- no cambios en Firestore Rules;
- no cambios en `executeDraw`;
- no cambios de modelo de datos.

---

## 11) Orden recomendado de implementacion (PRs pequenos)

Secuencia recomendada:

- **PR-4A:** Theme + componentes base.
- **PR-4B:** Dashboard premium.
- **PR-4C:** Resultado emocional.
- **PR-4D:** Wizard.
- **PR-4E:** Detalle de grupo reorganizado con componentes.
- **PR-4F:** Splash/bienvenida.

Razon de orden:

- primero base visual reutilizable;
- luego pantallas de alto impacto percibido;
- despues flujo de creacion y detalle;
- cierre con entrada de marca.

---

## 12) Checklist de validacion por PR

Cada PR de Fase 4 debe pasar, como minimo:

- `flutter analyze`;
- crear grupo;
- anadir participante con app;
- anadir participante sin app;
- anadir nino gestionado;
- asignar subgrupo;
- ejecutar sorteo;
- ver mi amigo secreto;
- ver resultados gestionados;
- confirmar privacidad (scope correcto de resultados);
- confirmar que backend no se rompio.

Criterio de salida de fase:

- experiencia consistente y publicable visualmente;
- flujo funcional intacto;
- sensacion premium, calida y clara percibida en pruebas manuales.

---

## 13) Recomendacion de primer PR concreto

Primer PR recomendado: **PR-4A Theme + componentes base**.

Alcance concreto sugerido del PR-4A:

- definir paleta base y estilos tipograficos;
- introducir `AppScaffold`, `SectionCard`, `PrimaryButton`, `SecondaryButton`, `StatusChip`, `WarningBox`, `PremiumHeader`;
- aplicar componentes en 1-2 pantallas piloto (dashboard + una pantalla de detalle parcial) sin reestructurar toda la navegacion;
- validar que no hay impacto en logica, providers, backend ni reglas.

Por que empezar aqui:

- reduce deuda visual sistémica;
- evita redisenos repetidos en PRs siguientes;
- acelera consistencia real en todo lo que viene.
