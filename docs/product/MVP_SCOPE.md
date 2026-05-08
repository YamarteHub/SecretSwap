# MVP Scope — Tarci Secret

## 1. Proposito del MVP

Cerrar un MVP pequeno, util, funcional, estable y publicable del flujo de amigo secreto, sin expandir el producto a una plataforma grande en esta fase.

## 2. Flujo incluido (alcance oficial)

El MVP de Tarci Secret incluye unicamente:

1. Crear grupo.
2. Unirse por codigo.
3. Gestionar participantes con app.
4. Anadir participantes sin app.
5. Anadir ninos gestionados.
6. Crear subgrupos.
7. Asignar participantes a subgrupos.
8. Configurar regla de sorteo:
   - `ignore` / ignorar subgrupos;
   - `preferDifferent` / preferir subgrupo diferente;
   - `requireDifferent` / exigir subgrupo diferente.
9. Ejecutar sorteo desde backend.
10. Mostrar a cada usuario solo su asignacion.
11. Mostrar al responsable solo resultados gestionados.
12. Permitir re-sortear si hace falta.
13. Mantener privacidad.
14. Mantener UI clara, calida, simple y sin mezcla de idiomas.

## 3. Flujo fuera de alcance (explicito)

No se implementa ahora:

- wishlist;
- chat;
- pistas;
- notificaciones push reales;
- WhatsApp/email automatico;
- multi-organizador;
- historial complejo;
- monetizacion;
- nuevas dinamicas;
- torneos;
- equipos;
- padel;
- arquitectura excesivamente compleja;
- reescritura completa del proyecto.

## 4. Reglas funcionales cerradas

- El MVP prioriza completar amigo secreto antes de cualquier otra dinamica.
- No se reescribe el proyecto desde cero.
- No se implementan nuevas features fuera del flujo core.
- El sorteo se ejecuta en backend.
- Cada usuario ve solo su asignacion.
- El responsable ve solo resultados gestionados.
- La separacion usuario/participante se mantiene.
- El minimo oficial para ejecutar sorteo es 3 participantes efectivos.
- `requireDifferent` exige que todos los participantes efectivos tengan subgrupo.
- `user_groups` es proyeccion, no fuente de verdad.
- Las futuras dinamicas quedan como vision futura, no como implementacion actual.

## 5. Criterios para aceptar el MVP

- Flujo core completo de amigo secreto operativo de extremo a extremo.
- Privacidad funcional respetada en lectura de asignaciones.
- Reglas de sorteo aplicadas de forma consistente.
- Resorteo disponible cuando sea necesario.
- Experiencia clara y estable sin mezcla de idiomas en la UI.

## 6. Checklist E2E minimo

- crear grupo;
- unirse por codigo;
- anadir participante con app;
- anadir participante sin app;
- anadir nino gestionado;
- crear subgrupos;
- asignar subgrupos;
- configurar regla;
- ejecutar sorteo;
- ver mi asignacion;
- ver secretos gestionados;
- confirmar privacidad;
- cambiar idioma sin mezcla ES/EN.
