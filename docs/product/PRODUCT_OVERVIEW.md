# PRODUCT_OVERVIEW — Tarci Secret

## Propósito

Tarci Secret permite organizar amigos secretos de forma sencilla, privada y divertida para familias, amigos, clases, empresas o equipos.

## Identidad del producto

Tarci Secret busca ser:

- simple para un sorteo rápido;
- útil para familias y grupos con casas/subgrupos;
- válido para empresas/departamentos;
- amigable para clases/colegios;
- divertido, cercano y con privacidad por defecto.

## Alcance actual del MVP

Estado funcional actual:

- modo rápido/anónimo para entrar sin cuenta formal;
- creación de grupos con owner único;
- invitación por código;
- generación/rotación de código de invitación;
- unión por código;
- subgrupos (casas, departamentos, clases o equipos);
- reglas de sorteo por subgrupo:
  - ignorar subgrupos;
  - preferir subgrupo diferente;
  - exigir subgrupo diferente;
- preparación de sorteo con estado de participantes;
- mínimo de participantes activos antes de habilitar sorteo;
- ejecución de sorteo en backend;
- cada usuario ve solo su asignación;
- snapshots de asignación para preservar resultado histórico.

## Modos de uso

### Modo rápido/invitado

Permite usar la app sin cuenta formal para crear grupo, invitar, unirse, configurar subgrupos y ejecutar el sorteo.  
Limitación principal: si se borra la app o se cambia de móvil, puede perderse el acceso por cambio de sesión/UID.

### Modo registrado (futuro)

Permitirá:

- recuperar grupos;
- usar varios dispositivos;
- wishlist;
- preguntas/pistas;
- notificaciones;
- historial.

## Conceptos principales

- **Grupo**: espacio donde se organiza un amigo secreto.
- **Owner**: persona administradora del grupo en MVP.
- **Participante**: persona que entra en el sorteo del grupo.
- **Subgrupo**: categoría interna (casa/departamento/clase/equipo) usada por reglas.
- **Regla de sorteo**: criterio de emparejamiento respecto a subgrupos.
- **Invitación**: acceso por código para entrar al grupo.
- **Ejecución**: corrida concreta del sorteo con idempotencia y trazabilidad.
- **Asignación**: resultado privado de “a quién le regala cada participante”.

## Privacidad

Principios vigentes:

- owner no ve todas las asignaciones por defecto;
- cada participante ve solo su asignación;
- códigos en claro no se guardan permanentemente;
- las asignaciones se generan en backend;
- participantes gestionados (sin móvil / niños) se tratan en fase futura.

## Historias de usuario (actualizadas)

- Como **owner**, quiero crear un grupo para organizar el amigo secreto.
- Como **owner**, quiero crear subgrupos para reflejar casas/departamentos/clases/equipos.
- Como **owner**, quiero generar o rotar código de invitación cuando lo necesite.
- Como **participante**, quiero unirme con código de forma simple.
- Como **participante**, quiero elegir mi subgrupo dentro del grupo.
- Como **owner**, quiero ejecutar el sorteo cuando el grupo esté preparado.
- Como **participante**, quiero ver solo mi asignación final.

## Futuras fases

- participantes gestionados / niños sin móvil;
- autenticación registrada Google/Apple/email;
- i18n ES/EN/IT/PT/FR;
- wishlist;
- preguntas estructuradas;
- pistas controladas;
- UI/UX visual final y branding completo;
- notificaciones/email en fases posteriores.

## No objetivos actuales

Por ahora no incluye:

- chat libre;
- pagos;
- logística de regalos;
- marketplace;
- múltiples admins avanzados;
- ver todas las asignaciones;
- red social.

