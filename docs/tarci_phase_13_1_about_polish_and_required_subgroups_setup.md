# Tarci Secret — Fase 13.1: About premium + setup post-creación (subgrupos obligatorios)

## Origen (QA manual)

Durante la auditoría de release candidate (Fase 13) se validó que, al crear un Amigo Secreto con la regla **Exigir subgrupo diferente**, el usuario llegaba al detalle del grupo **sin subgrupos** y **sin asignación propia**, con avisos y bloqueos coherentes con las reglas pero con **fricción de UX**: la app no acompañaba la configuración mínima en el momento adecuado.

## Diagnóstico — Pantalla “Acerca de”

La pantalla era **correcta en contenido** pero perceptualmente **densa**: varias tarjetas con el mismo peso visual, bloques de texto largos sin suficiente ritmo y oportunidad de reforzar **marca** e **institucionalidad** sin añadir funcionalidad.

## Cambios visuales en About

- **Hero**: portada con contenedor propio (degradado suave crema/marfil, borde ligero, sombra existente del sistema), mayor aire vertical y jerarquía tipográfica para nombre + claim.
- **“Qué es…”**: mismo texto; párrafos separados explícitamente (`\n\n`) con espaciado vertical mayor y `line-height` más lecturable.
- **Capacidades (informativo)**: sección breve con **chips** no interactivos que listan las cinco dinámicas activas reutilizando copy ya existente de la app (`dynamicsCard*Title`).
- **“Cómo funciona”**: cabecera de sección con icono; pasos en **SectionCard** más liviano que la tarjeta protagonista, iconos con fondo en gradiente de marca para coherencia con el resto del producto.
- **Privacidad**: cabecera con icono, **frase lead** nueva (`aboutSectionPrivacyLead`), cuerpo en párrafos separados; bloque de confianza en contenedor tenue diferenciado.
- **Retención**: presentación **distinta** a privacidad — `SectionCard` con fondo marfil, icono de calendario/reloj y lead (`aboutRetentionLead`) antes del texto aprobado.
- **Creador / Info app**: mismos contenidos; pequeños ajustes de espaciado.

## Criterio de diseño

- **No** rehacer la pantalla desde cero; **no** eliminar información contractual o de producto.
- **Sí** mejorar jerarquía, ritmo de lectura y sensación premium/institucional.
- Sección de capacidades **solo** informativa (no navega ni selecciona modalidades).

## Flujo post-creación — Subgrupos obligatorios

### Cuándo aparece

Tras crear un grupo de **Amigo Secreto** y pulsar ir al detalle, si:

1. La navegación incluye la marca `GroupDetailRouteExtra.offerPostCreateRequiredSubgroupsSetup == true` (solo se envía cuando la regla elegida en el asistente es **Exigir subgrupo diferente**).
2. En el detalle, el usuario es **owner**.
3. `drawSubgroupRule == requireDifferent`.
4. No hay subgrupos aún (`subgroups.isEmpty`).
5. El sorteo permite edición (`idle` o `failed`).

Entonces se muestra un **bottom sheet** modal transparente con panel crema.

**No aplica** a Sorteos, Equipos, Parejas ni Duelos. **No** se activa para **Preferir subgrupo diferente** en esta fase (recomendación suave posible en el futuro; se omitió para no ampliar alcance).

### Paso 1 — Crear subgrupos

- Título y cuerpo según i18n (`requiredSubgroupsSetup*`).
- Dos campos iniciales + “Añadir otro subgrupo”.
- Validación: al menos **dos** nombres no vacíos (se ignoran filas vacías), **sin duplicados** (comparación simple sin distinguir mayúsculas).
- Persistencia: llama a `GroupsRepository.createSubgroup` por cada nombre (operaciones existentes, sin callable nueva).

### Paso 2 — Asignar al organizador si participa

Solo si el usuario actual es **miembro activo** del grupo (`GroupMember` con `memberState.active`), lo que en el flujo actual de creación de Amigo Secreto incluye al creador con apodo (no existe hoy “solo organizo” en este asistente).

- Selector de radio entre los subgrupos recién creados.
- CTA: **Guardar y continuar** → `GroupsRepository.setMemberSubgroup`.

Si el owner **no** participara como miembro (caso teórico/futuro), tras el paso 1 se cierra el sheet tras `onReload`.

### “Lo haré después”

Cierra el sheet **sin** snackbar de éxito. El detalle sigue mostrando los avisos/checklist ya existentes.

### Post-flujo

Tras guardar subgrupos y, si aplica, asignación propia, se invoca `onReload` (invalidación de `groupDetailProvider` / lista) **sin** snackbar redundante (alineado con Fase 12.1).

## Reutilización técnica

- `createSubgroup` y `setMemberSubgroup` del repositorio existente.
- Activación localizada en `_GroupDetailBodyState` con bandera de ruta consumida una sola vez por montaje del estado.

## i18n

Claves nuevas en **ES, EN, PT, IT, FR** para: título/cuerpo del sheet, labels de campos (con `{index}`), CTA, errores, “Lo haré después”, leads de About y título de capacidades.

Comando: `flutter gen-l10n`.

## Validaciones técnicas ejecutadas

- `flutter gen-l10n`
- `flutter analyze`

Backend **no** modificado → `npm run build` no requerido para esta fase.

## Checklist manual (Stan)

### About

- [ ] Aspecto más premium / menos denso; hero y secciones diferenciadas.
- [ ] Chips de las cinco dinámicas visibles.
- [ ] Privacidad y retención legibles con frases lead.
- [ ] LinkedIn abre correctamente.
- [ ] Versión/compilación/copyright visibles.
- [ ] Revisar ES / EN / PT / IT / FR.

### Subgrupos obligatorios

- [ ] **Caso A**: Owner participa + Exigir subgrupo diferente → sheet tras crear → ≥2 subgrupos → asignación propia → detalle sin bloqueos previos de subgrupo vacío para el owner.
- [ ] **Caso B**: Si en el futuro el owner no es miembro activo → solo paso 1 (hoy el asistente de Amigo Secreto crea miembro owner).
- [ ] **Caso C**: “Lo haré después” → detalle con warnings/checklist como antes.
- [ ] **Caso D**: Sin regla de exigencia o con ignorar/preferir → **no** debe aparecer el sheet al crear (Para **preferir**, no implementado en 13.1).
