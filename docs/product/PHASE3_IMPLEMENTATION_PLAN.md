# Fase 3 - Plan de Implementacion Incremental (UI/UX)

## 1) Proposito

Definir un plan de implementacion **incremental, seguro y verificable** para profesionalizar la UX/UI del MVP de Tarci Secret sin romper el flujo funcional ya validado.

Este plan traduce la vision de `docs/product/UI_UX_VISION_TARCI_SECRET.md` en bloques pequenos que se pueden ejecutar en PRs acotados.

---

## 2) Flujo funcional que debe preservarse

El siguiente flujo ya esta validado y **no debe romperse**:

- crear grupo;
- participantes con app;
- participantes sin app;
- ninos gestionados;
- subgrupos;
- reglas;
- ejecucion de sorteo;
- mi asignacion;
- resultados gestionados.

---

## 3) Restricciones obligatorias (toda Fase 3)

- No tocar backend.
- No tocar Firestore Rules.
- No cambiar logica de sorteo.
- No cambiar modelo de datos.
- No implementar login todavia.
- No implementar wishlist/chat.
- No implementar batallas/equipos todavia.
- No i18n completo todavia.
- No hacer rediseño masivo en un solo PR.

---

## 4) Estrategia de entrega y seguridad

1. **PR pequeno por subfase** (3A, 3B, 3C, 3D, 3E).
2. **Cambios de UI por capas**: primero estructura y copy, despues detalle visual.
3. **Sin migraciones de datos**.
4. **Sin cambios de contratos** entre frontend y backend.
5. **Validacion manual guiada** en cada PR usando checklist de regresion.
6. **Rollback simple**: cada subfase debe poder revertirse sin afectar datos.

---

## 5) Fases de implementacion

## Fase 3A - Dashboard profesional

### Objetivo

Mejorar la pantalla inicial de grupos para que sea clara, atractiva y accionable, sin cambiar comportamiento de datos.

### Pantallas afectadas

- Home de grupos / lista principal de grupos.

### Archivos probables

- `src/flutter_app/lib/features/groups/presentation/screens/groups_home_screen.dart`
- Posibles widgets de apoyo en `src/flutter_app/lib/features/groups/presentation/`
- Ajustes de tema si aplica en `src/flutter_app/lib/core/theme/app_theme.dart` (solo visuales leves)

### Que se toca

- Header "Tarci Secret" con jerarquia visual.
- Copy breve del modo rapido (informativo, no flujo nuevo).
- Listado en cards con estados visibles (activo/completado/otro existente).
- Acciones principales:
  - Crear amigo secreto
  - Unirse por codigo
- "Futuras dinamicas" como bloque informativo "Proximamente", sin navegacion operativa nueva.

### Que no se toca

- Repositorios, providers de backend, modelos y reglas de negocio.
- Logica de creacion/union existente.
- Navegacion profunda fuera del dashboard.

### Criterios de aceptacion

- El usuario entiende en menos de 5 segundos que puede crear o unirse.
- Los grupos se ven en cards con estado legible.
- No hay regresion en navegar a crear grupo ni unirse por codigo.
- `flutter analyze` sin errores.

### Riesgos

- Saturar la pantalla con demasiados bloques.
- Confundir "proximamente" con funcionalidad activa.

### Pruebas manuales

1. Usuario sin grupos: ver CTA principales y bloque "proximamente".
2. Usuario con grupos activos y completados: cards correctas y acciones funcionales.
3. Navegar a crear grupo y volver.
4. Navegar a unirse por codigo y volver.

---

## Fase 3B - Wizard de creacion de amigo secreto

### Objetivo

Reemplazar progresivamente la pantalla simple de crear grupo por un wizard guiado, manteniendo compatibilidad con lo que backend soporta hoy.

### Pantallas afectadas

- Flujo de creacion de grupo.

### Archivos probables

- `src/flutter_app/lib/features/groups/presentation/screens/create_group_screen.dart`
- Nuevos widgets/pasos en `src/flutter_app/lib/features/groups/presentation/` (si se separan pasos)
- Rutas existentes en `src/flutter_app/lib/core/routing/app_router.dart` (solo si hace falta transicion de pantallas)

### Que se toca

Pasos minimos iniciales del wizard:

1. Nombre del grupo.
2. Tu apodo.
3. Participas tu (documentado como futuro si backend no soporta).
4. Subgrupos opcionales.
5. Regla del sorteo.
6. Revision final.

Regla clave de producto:

- Si backend no soporta un dato, mostrarlo como **"proximamente"** o dejarlo pendiente, sin simular guardados falsos.

### Que no se toca

- Contratos de API/repositorio.
- Nuevos campos persistidos que no existan.
- Cualquier intento de inferir "ownerParticipates" operativo sin soporte real.

### Criterios de aceptacion

- El wizard permite crear grupo con los campos actualmente soportados.
- Los pasos no soportados operativamente quedan claramente marcados como futuros.
- No se rompe el flujo actual de creacion.
- `flutter analyze` sin errores.

### Riesgos

- Introducir estados intermedios inconsistentes entre pasos.
- Prometer funcionalidad no implementada (falso positivo UX).

### Pruebas manuales

1. Crear grupo con datos minimos.
2. Crear grupo incluyendo subgrupos/regla si ya existen en flujo actual.
3. Validar que el paso "Participas tu" no persiste nada ficticio.
4. Verificar que el grupo creado aparece en dashboard.

---

## Fase 3C - Reorganizar GroupDetailScreen

### Objetivo

Reordenar visualmente la pantalla actual de grupo para mejorar lectura y control, sin reescribirla desde cero.

### Pantallas afectadas

- Detalle de grupo.

### Archivos probables

- `src/flutter_app/lib/features/groups/presentation/screens/group_detail_screen.dart`
- Widgets auxiliares extraidos del mismo archivo (si conviene, sin cambio funcional)

### Que se toca

Orden recomendado inicial:

1. Estado del sorteo + acciones principales.
2. Invitaciones.
3. Preparacion.
4. Participantes con app.
5. Participantes sin app.
6. Subgrupos.
7. Reglas.

Decision UX a evaluar:

- Si mover "Reglas" al final reduce claridad de preparacion, mantenerla mas arriba.
- Criterio: la regla activa debe ser visible antes de ejecutar sorteo.

### Que no se toca

- `executeDraw`.
- Logica de validaciones de sorteo ya existente.
- Reglas y comportamiento de managed assignments.

### Criterios de aceptacion

- La pantalla se entiende por bloques y prioridad de accion.
- Se conservan todas las capacidades actuales.
- No hay regresion en ejecutar sorteo, ver asignacion y ver gestionados.
- `flutter analyze` sin errores.

### Riesgos

- Mover demasiado contenido y perder contexto.
- Duplicar informacion entre bloques (ruido visual).

### Pruebas manuales

1. Grupo en estado idle: revisar orden y claridad.
2. Grupo con sorteo completado: revisar CTA correctas.
3. Grupo con sin app y ninos: revisar lectura de esos bloques.
4. Cambiar regla/subgrupo (si permitido) y validar feedback visual.

---

## Fase 3D - Resultado emocional

### Objetivo

Mejorar jerarquia visual y copy emocional en pantallas de resultados sin cambiar datos mostrados.

### Pantallas afectadas

- Mi asignacion.
- Resultados gestionados.

### Archivos probables

- `src/flutter_app/lib/features/draw/presentation/screens/my_assignment_screen.dart`
- `src/flutter_app/lib/features/draw/presentation/screens/managed_assignments_screen.dart`

### Que se toca

- Copy principal ("Te toca regalar a...").
- Cards con jerarquia visual mas clara.
- Iconografia ligera (regalo/secreto/privacidad).
- Mensajes de privacidad:
  - personal: resultado privado;
  - gestionados: entrega privada.

### Que no se toca

- Query de resultados.
- Logica de autorizacion/filtrado.
- Estructura del modelo de asignaciones.

### Criterios de aceptacion

- El usuario identifica rapidamente a quien debe regalar.
- Se refuerza privacidad en ambas pantallas.
- En gestionados queda claro que solo ve personas bajo su gestion.
- `flutter analyze` sin errores.

### Riesgos

- Sobreestilizar y perder legibilidad.
- Cambiar copy sin contemplar estados vacios o error.

### Pruebas manuales

1. Ver mi asignacion tras sorteo completado.
2. Ver resultados gestionados con adulto sin app y nino gestionado.
3. Revisar estados vacios y mensajes de error visibles.

---

## Fase 3E - Splash / bienvenida / idioma

### Objetivo

Agregar capa de entrada de producto (branding y bienvenida) despues de estabilizar el flujo principal.

### Pantallas afectadas

- Splash.
- Bienvenida.
- Seleccion/confirmacion de idioma (basica).

### Archivos probables

- `src/flutter_app/lib/features/auth/presentation/screens/splash_screen.dart`
- `src/flutter_app/lib/core/routing/app_router.dart`
- Nuevas pantallas de bienvenida/idioma en `src/flutter_app/lib/features/auth/presentation/screens/` (o modulo onboarding)

### Que se toca

- Splash de marca.
- Pantalla de bienvenida con opcion modo rapido vs iniciar sesion (solo UX, sin login real nuevo).
- Selector de idioma basico de interfaz de entrada.

### Que no se toca

- i18n completa de toda la app.
- Sistema completo de autenticacion adicional.
- Persistencia multilenguaje avanzada si no existe infraestructura.

### Criterios de aceptacion

- Entrada inicial mas profesional sin romper rutas actuales.
- Usuario puede continuar al dashboard sin bloqueos.
- Mensajes claros sobre alcance de idioma en esta fase.
- `flutter analyze` sin errores.

### Riesgos

- Introducir friccion extra antes del dashboard.
- Dejar estados de navegacion inconsistentes (back stack).

### Pruebas manuales

1. Primera apertura: splash -> bienvenida -> dashboard.
2. Elegir modo rapido y continuar.
3. Probar retroceso del sistema en cada pantalla de entrada.

---

## 6) Orden recomendado de PRs

1. **PR-3A:** Dashboard profesional.
2. **PR-3C:** Reorganizacion de GroupDetailScreen (primero estructura).
3. **PR-3D:** Resultado emocional.
4. **PR-3B:** Wizard de creacion (cuando 3A/3C esten estables).
5. **PR-3E:** Splash/bienvenida/idioma basico.

Nota: 3B y 3E pueden intercambiarse segun capacidad del equipo, pero 3A + 3C deben ir primero por impacto directo en el flujo principal validado.

---

## 7) Checklist de seguridad por PR

Antes de mergear cada PR de Fase 3:

1. `flutter analyze` sin errores.
2. Smoke test manual del flujo validado:
   - crear grupo;
   - participantes con app/sin app/nino gestionado;
   - subgrupos y reglas;
   - ejecutar sorteo;
   - ver mi asignacion;
   - ver gestionados.
3. Confirmar que no hubo cambios en backend/rules/modelos.
4. Verificar copy de privacidad en pantallas sensibles.
5. Revisar que "Proximamente" no habilite acciones no soportadas.

---

## 8) Resultado esperado

Al finalizar Fase 3:

- Tarci Secret tendra una UX/UI profesional y coherente con MVP.
- El flujo ya validado se mantendra estable.
- La implementacion quedara dividida en entregas pequenas, auditables y seguras.
- El producto estara listo para evolucionar a features futuras sin deuda visual critica.

