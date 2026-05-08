# MVP E2E Acceptance Matrix — Tarci Secret / SecretSwap

## 1. Propósito

Este documento define la matriz mínima de validación E2E para determinar si el MVP de Tarci Secret puede considerarse funcionalmente publicable.

Su objetivo es verificar, de extremo a extremo, el flujo core de amigo secreto congelado para MVP, priorizando estabilidad, privacidad, claridad de UX e idioma consistente.

Esta matriz técnica se complementa con los criterios de intuición de uso definidos en `docs/product/UX_INTUITIVE_MVP_CRITERIA.md`.

## 2. Alcance de la prueba

La validación E2E del MVP cubre únicamente el flujo core:

- crear grupo;
- unirse por código;
- gestionar participantes con app;
- añadir participante sin app;
- añadir niño gestionado;
- crear subgrupos;
- asignar subgrupos;
- configurar regla de sorteo;
- ejecutar sorteo;
- ver mi asignación;
- ver secretos gestionados;
- confirmar privacidad;
- cambiar idioma sin mezcla ES/EN.

## 3. Precondiciones

Antes de ejecutar esta matriz E2E, debe cumplirse:

- Firebase/emuladores operativos o entorno configurado.
- App ejecutando en Android Studio/emulador.
- Usuario administrador (owner) de prueba.
- Al menos un segundo usuario/invitado de prueba o mecanismo debug controlado.
- Mínimo 3 participantes efectivos.
- Código de invitación activo.

## 4. Matriz E2E

Prioridades:

- P0 crítico
- P1 importante
- P2 secundario

| ID | Prioridad | Caso de prueba | Rol | Pasos | Resultado esperado | Evidencia requerida | Resultado observado | Bug/nota | Estado |
|---|---|---|---|---|---|---|---|---|---|
| E2E-01 | P0 crítico | Crear grupo como owner | Owner | Iniciar sesión como owner. Crear grupo con nombre válido. | Grupo creado correctamente y owner asignado al grupo. | Captura de pantalla del grupo creado y resultado observado. | Pendiente de ejecución | - | Pendiente |
| E2E-02 | P1 importante | Generar/ver código de invitación | Owner | Entrar al grupo creado. Consultar código de invitación vigente. | Código visible y utilizable para join por código. | Captura de pantalla del código (en entorno de prueba) y resultado observado. | Pendiente de ejecución | - | Pendiente |
| E2E-03 | P0 crítico | Unirse por código como invitado | Invitado | Iniciar sesión como invitado. Ingresar código válido. Confirmar unión. | Invitado unido al grupo como miembro activo. | Captura de pantalla de unión exitosa y usuario/rol usado. | Pendiente de ejecución | - | Pendiente |
| E2E-04 | P1 importante | Validar que un usuario removed no pueda reingresar | Owner + Invitado | Marcar miembro como removed. Intentar join de ese usuario con código activo. | Reingreso bloqueado para miembro removed con mensaje claro. | Captura del bloqueo, mensaje observado y log si aplica. | Pendiente de ejecución | - | Pendiente |
| E2E-05 | P1 importante | Añadir participante sin app | Owner | Desde gestión del grupo, añadir participante gestionado sin cuenta app. | Participante sin app creado y visible en gestión del owner. | Captura de lista actualizada y resultado observado. | Pendiente de ejecución | - | Pendiente |
| E2E-06 | P1 importante | Añadir niño gestionado | Owner | Crear participante tipo niño/gestionado según flujo definido. | Niño gestionado agregado sin romper flujo de membresía. | Captura y registro de usuario/rol usado. | Pendiente de ejecución | - | Pendiente |
| E2E-07 | P1 importante | Crear subgrupos | Owner | Crear al menos dos subgrupos dentro del grupo. | Subgrupos creados y disponibles para asignación. | Captura de subgrupos y resultado observado. | Pendiente de ejecución | - | Pendiente |
| E2E-08 | P1 importante | Asignar subgrupos a participantes | Owner | Asignar subgrupo a participantes efectivos relevantes. | Asignaciones guardadas correctamente y visibles en gestión. | Captura de asignaciones y resultado observado. | Pendiente de ejecución | - | Pendiente |
| E2E-09 | P1 importante | Configurar regla `ignore` | Owner | Seleccionar `subgroupMode = ignore`. Guardar configuración. | Regla aplicada correctamente sin restricción por subgrupos. | Captura de configuración guardada y resultado observado. | Pendiente de ejecución | - | Pendiente |
| E2E-10 | P1 importante | Configurar regla `preferDifferent` | Owner | Seleccionar `subgroupMode = preferDifferent`. Guardar configuración. | Regla aplicada; prioriza cruces entre subgrupos sin bloquear sorteo si no llega al 100%. | Captura de configuración y resultado observado. | Pendiente de ejecución | - | Pendiente |
| E2E-11 | P0 crítico | Configurar regla `requireDifferent` | Owner | Seleccionar `subgroupMode = requireDifferent`. Guardar configuración. | Regla aplicada con exigencia de subgrupos distintos por asignación. | Captura de configuración y resultado observado. | Pendiente de ejecución | - | Pendiente |
| E2E-12 | P0 crítico | Bloquear sorteo si hay menos de 3 efectivos | Owner | Dejar 2 participantes efectivos e intentar ejecutar sorteo. | Sorteo bloqueado por mínimo oficial de 3 efectivos con mensaje claro. | Captura del bloqueo, mensaje y log/error si aplica. | Pendiente de ejecución | - | Pendiente |
| E2E-13 | P0 crítico | Bloquear `requireDifferent` si falta `subgroupId` | Owner | Configurar `requireDifferent` dejando algún efectivo sin subgrupo. Ejecutar sorteo. | Sorteo falla/bloquea con mensaje claro por falta de `subgroupId`. | Captura del error, resultado observado y log si aplica. | Pendiente de ejecución | - | Pendiente |
| E2E-14 | P0 crítico | Ejecutar sorteo correctamente | Owner | Asegurar precondiciones válidas (>=3 efectivos y reglas coherentes). Ejecutar sorteo. | Ejecución creada correctamente y estado final válido. | Captura del resultado y referencia de ejecución observada. | Pendiente de ejecución | - | Pendiente |
| E2E-15 | P0 crítico | Ver solo mi asignación | Miembro autenticado | Iniciar sesión como miembro. Abrir vista de asignación personal. | Solo se muestra la asignación propia del usuario autenticado. | Captura de la vista y usuario/rol usado. | Pendiente de ejecución | - | Pendiente |
| E2E-16 | P0 crítico | Ver solo secretos gestionados | Owner/Responsable | Ingresar como responsable. Abrir vista de resultados gestionados. | Solo se muestran resultados gestionados del responsable, no globales ajenos. | Captura de vista y resultado observado. | Pendiente de ejecución | - | Pendiente |
| E2E-17 | P0 crítico | Confirmar privacidad: owner no ve todas las asignaciones | Owner | Intentar acceder desde UI a asignaciones globales completas. | Acceso global no disponible; privacidad mantenida por diseño. | Captura del comportamiento y resultado observado. | Pendiente de ejecución | - | Pendiente |
| E2E-18 | P1 importante | Re-sortear y confirmar nueva ejecución | Owner | Ejecutar un nuevo sorteo en condiciones válidas. Comparar con ejecución previa. | Nueva ejecución registrada correctamente, trazable y consistente. | Captura de nueva ejecución y evidencia comparativa básica. | Pendiente de ejecución | - | Pendiente |
| E2E-19 | P0 crítico | Cambiar idioma ES/EN sin mezcla en flujo core | Owner + Invitado | Recorrer flujo core en ES y EN (si aplica cambio de idioma). | Sin mezcla de idiomas en pantallas core; textos consistentes por idioma activo. | Capturas por pantalla clave y observaciones UX. | Pendiente de ejecución | - | Pendiente |
| E2E-20 | P2 secundario | Confirmar que `user_groups` es solo proyección (validación técnica) | QA funcional / Owner | Contrastar comportamientos de membresía real vs listados derivados en UI. | La lógica funcional depende de membresía real; `user_groups` actúa solo como proyección de lectura. | Evidencia de comportamiento observado y notas de validación. | Pendiente de ejecución | Validación técnica, no prueba de usuario familiar. | Pendiente |
| E2E-21 | P0 crítico | Flujo entendible sin ayuda externa (prueba no asistida) | Usuario no técnico | Entregar la app y pedir: "Crea un amigo secreto para tu familia e invita a alguien con código", sin guías adicionales. | La persona completa el flujo principal sin explicación externa. | Registro de dudas, tiempos, pantallas de bloqueo y resultado final. | Pendiente de ejecución | Ver criterios en `UX_INTUITIVE_MVP_CRITERIA.md`. | Pendiente |

## 5. Criterios de aceptación

El MVP se considera aceptable si:

- todos los E2E P0 críticos pasan;
- no hay mezcla de idiomas en flujo core;
- no se exponen asignaciones ajenas;
- `executeDraw` exige mínimo 3 participantes efectivos;
- `requireDifferent` valida `subgroupId`;
- el flujo owner/invitado se entiende;
- la UI permite completar el flujo sin explicación externa.

## 6. Criterios bloqueantes

Se considera bloqueante para publicación MVP:

- cualquier usuario puede ver asignaciones ajenas;
- el sorteo se ejecuta con menos de 3 efectivos;
- `requireDifferent` permite participantes sin subgrupo;
- mezcla ES/EN en pantallas core;
- join por código falla en flujo normal;
- no se puede ver mi asignación después del sorteo;
- resultados gestionados muestran datos incorrectos o globales;
- no se puede volver al dashboard o continuar flujo básico;
- el usuario no técnico necesita explicación externa para completar el flujo.

## 7. Evidencias

Para cada prueba E2E se debe guardar:

- captura de pantalla si aplica;
- resultado observado;
- error/log si falla;
- usuario/rol usado;
- fecha de prueba;
- entorno usado.

## 8. Fuera de alcance de QA MVP

No probar todavía en esta fase:

- wishlist;
- chat;
- pistas;
- push notifications reales;
- WhatsApp/email automático;
- torneos;
- equipos;
- pádel;
- monetización;
- multi-organizador.
