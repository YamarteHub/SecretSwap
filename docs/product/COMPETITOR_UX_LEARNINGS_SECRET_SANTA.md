# Competitor UX Learnings — Secret Santa

## 1. Propósito

Documentar aprendizajes UX observados en una app competidora de amigo secreto y traducirlos a decisiones prácticas para Tarci Secret, sin romper el foco actual del MVP.

Este documento no amplía alcance funcional del MVP. Solo orienta mejoras de claridad y experiencia de uso.

## 2. Contexto y marco de decisión

- Tarci Secret mantiene foco en cerrar el flujo core de amigo secreto.
- La visión futura puede incluir nuevas dinámicas de grupo, pero no se implementa en esta fase.
- Decisión base: copiar claridad de flujo, no copiar estética literal ni features fuera de alcance.

## 3. Lo observado en la app competidora

- wizard visual (una pregunta por pantalla);
- fondos festivos e ilustraciones grandes;
- botones grandes y jerarquía visual clara;
- flujo de invitación entendible;
- funciones extra: presupuesto, fecha de celebración, wishlist, buscador de regalos, notificaciones, FAQ;
- bottom navigation amplia (celebraciones, regalos, wishlist, menú).

## 4. Qué sí conviene adaptar ahora (MVP)

1. **Una pantalla = una decisión**
   - Mantener pasos cortos y secuenciales.
   - Reducir carga cognitiva en creación/preparación de grupo.

2. **Checklist visual de preparación**
   - Convertir el estado del grupo en checklist simple:
     - participantes listos;
     - subgrupos asignados (si aplica);
     - regla de sorteo definida;
     - listo para sortear.

3. **Momento de invitación más claro**
   - Destacar mejor el paso “invitar por código”.
   - Reforzar CTA principal y feedback de éxito/error comprensible.

4. **Jerarquía visual más obvia**
   - Botón principal único por pantalla.
   - Acciones secundarias menos prominentes.

5. **Lenguaje humano y directo**
   - Priorizar textos cotidianos y evitar términos técnicos en UI.

## 5. Qué conviene dejar para después (post-MVP)

- presupuesto;
- fecha de celebración;
- wishlist;
- buscador de regalos;
- notificaciones push reales;
- FAQ/centro de ayuda avanzado;
- bottom navigation amplia con secciones no core.

Motivo: aportan valor, pero desvían foco y complejizan entrega del MVP actual.

## 6. Qué NO debemos copiar

1. **Estética 100% navideña**
   - Tarci Secret debe ser usable todo el año y para distintos contextos de grupo.

2. **Menú sobredimensionado en fase MVP**
   - Evitar navegación con demasiadas secciones que compitan con el flujo principal.

3. **Sobreacumulación de funcionalidades accesorias**
   - No introducir capas de producto que oculten o diluyan el flujo core.

## 7. Adaptación visual para Tarci Secret (sin volverla navideña)

- Usar tono cálido/festivo neutral (no exclusivamente navideño).
- Mantener ilustraciones de apoyo solo cuando mejoren comprensión.
- Priorizar legibilidad, contraste y estados claros sobre decoración.
- Diseñar para “familia y grupo real”, no solo para campañas estacionales.

## 8. Diferencial que debe mantenerse

- Privacidad estricta por usuario (cada persona ve solo lo que le corresponde).
- Soporte de participantes reales mixtos:
  - con app;
  - sin app;
  - niños gestionados.
- Flujo de sorteo entendible para owner e invitados sin explicación externa.

## 9. Relación con la visión futura (sin desviar MVP)

- La visión futura de dinámicas de grupo se mantiene como dirección de producto.
- En MVP, la prioridad es demostrar usabilidad real del flujo core.
- Regla de producto: toda mejora UX actual debe acortar fricción del flujo vigente, no abrir nuevos módulos.

## 10. Decisiones cerradas para este ciclo

- Copiar claridad de flujo, no estética literal.
- Mantener “una pantalla = una decisión”.
- Convertir preparación del grupo en checklist visual.
- Mejorar el momento/pantalla de invitación.
- Mantener wishlist, buscador de regalos y push fuera del MVP.
- No usar estética 100% navideña.
- Mantener privacidad y participantes reales como diferencial.

## 11. Lista explícita de descartes en MVP

- wishlist;
- buscador de regalos;
- notificaciones push reales;
- presupuesto;
- fecha de celebración;
- FAQ/ayuda avanzada;
- navegación inferior completa tipo “suite” de funcionalidades.

## 12. Recomendaciones para próximos PRs documentales

1. **PR UX-1**: definir guideline de microcopys por pantalla core (CTA principal, mensajes de error y estado).
2. **PR UX-2**: definir checklist visual estándar de “grupo listo para sortear”.
3. **PR UX-3**: definir patrón UX de invitación por código (mostrar, compartir, confirmar unión).
4. **PR UX-4**: definir paleta y estilo visual “festivo neutral” no estacional.
