# Analisis de competencia y oportunidades de producto - Tarci Secret

## 0) Objetivo del documento

Documentar un analisis estrategico de una app competidora de amigo secreto para identificar aprendizajes utiles, simplificaciones rescatables y oportunidades reales de producto para Tarci Secret, sin clonar su enfoque ni perder la identidad emocional, familiar y privada de la marca.

Este documento es de direccion de producto. No implica cambios de codigo inmediatos.

---

## 1) Resumen de la app competidora observada

La app competidora analizada presenta un flujo orientado a resolver un sorteo de amigo secreto en pocos pasos y con baja friccion.

Elementos observados:

- onboarding con beneficios claros;
- mensaje de alto volumen de uso (prueba social);
- CTA principal visible: **Iniciar sorteo**;
- modos de uso: **Remoto** y **Presencial**;
- entrada manual y rapida de nombres;
- restricciones manuales por participante;
- compartir resultado individual;
- historial de sorteos (tipo "Sorteos celebrados");
- diseño visual blanco/morado de baja carga;
- presencia de anuncios visibles.

### Fortalezas

- simplicidad general del flujo;
- claridad de accion principal desde el inicio;
- pocos pasos para llegar al sorteo;
- entrada rapida de participantes por nombres;
- modos remoto/presencial faciles de entender;
- restricciones manuales por persona;
- compartir resultado por participante;
- historial accesible de sorteos ya ejecutados;
- estetica blanca/morada limpia y facil de interpretar.

### Debilidades

- parece centrada casi exclusivamente en amigo secreto basico;
- no se observa soporte robusto para ninos o personas sin movil;
- no se observa gestion avanzada de subgrupos/casas/departamentos;
- no se observa privacidad delegada sofisticada;
- no se observa separacion clara entre usuario de app y participante real;
- anuncios visibles que reducen percepcion premium;
- poca identidad emocional diferencial;
- poca preparacion para dinamicas mas amplias (equipos, duelos, emparejamientos complejos).

---

## 2) Lecciones positivas aplicables a Tarci Secret

Tarci Secret debe capturar los patrones de claridad y rapidez de la competencia sin copiar pantallas ni limitar su ambicion funcional.

### Simplicidad de entrada

La competencia deja claro en segundos "que hacer primero". Tarci Secret debe ofrecer esa misma inmediatez incluso con mas potencia interna.

Aplicacion recomendada:

- home con una sola accion dominante por contexto;
- copy corto, directo y humano;
- reduccion de decisiones iniciales.

### Accion principal clara

Debe existir una accion principal dominante segun etapa:

- **Crear amigo secreto**
- o **Empezar sorteo**

Esto evita que el usuario se pierda entre funcionalidades secundarias.

### Entrada rapida de nombres

Incluir modo rapido de alta velocidad para contextos familiares/presenciales:

- pegar o escribir nombres manualmente;
- editar y eliminar en segundos;
- sorteo simple sin configuracion extensa.

### Modo remoto / presencial / mixto

Incorporar como base de producto:

- **Remoto:** cada participante recibe o consulta su resultado en su dispositivo, o via entrega delegada;
- **Presencial:** el organizador revela resultados uno por uno;
- **Mixto:** conviven usuarios con app y participantes gestionados.

### Restricciones por participante

Tarci Secret ya avanza con reglas de subgrupos, pero conviene planificar restricciones manuales avanzadas:

- A no puede regalar a B;
- parejas no se regalan entre si;
- padre/madre no regala a hijo;
- miembros de misma casa/departamento/equipo pueden evitarse.

### Compartir resultado individual

Fortalecer resultados gestionados con opciones progresivas:

- copiar mensaje;
- compartir por WhatsApp;
- compartir por email;
- marcar como entregado;
- imprimir.

### Historial

El concepto "Sorteos celebrados" aporta continuidad y confianza.

Direccional Tarci Secret:

- historial basico para usuarios registrados;
- vista de grupos activos vs completados;
- acceso rapido a resultados personales/gestionados.

---

## 3) Que NO debe copiar Tarci Secret

Tarci Secret no debe replicar patrones que debiliten su propuesta diferencial:

- anuncios intrusivos;
- estetica generica sin alma;
- logica excesivamente plana que no represente familias reales;
- dependencia exclusiva de participantes manuales;
- ausencia de privacidad delegada;
- exposicion excesiva de resultados por parte del organizador;
- flujo limitado solo a amigo secreto.

Principio rector: aprender de la simplicidad, no de la superficialidad.

---

## 4) Diferenciales estrategicos de Tarci Secret

Tarci Secret debe superar a la competencia por inclusion real, privacidad robusta y amplitud de escenarios sociales.

### Participantes reales

La plataforma debe contemplar de forma nativa:

- usuarios con app;
- usuarios anonimos;
- usuarios registrados;
- adultos sin app;
- ninos gestionados;
- participantes manuales;
- personas anadidas por el organizador.

### Separacion usuario / participante

Diferencial estructural clave:

- un usuario de app no siempre coincide con un participante;
- permite integrar personas sin movil y menores;
- mejora el modelado de grupos familiares y comunitarios.

### Privacidad por defecto

Arquitectura y UX alineadas en confidencialidad:

- cada usuario ve solo su asignacion;
- el owner no ve todas las asignaciones por defecto;
- cada responsable ve solo resultados de personas gestionadas;
- sorteo ejecutado en backend;
- sin lectura global insegura de asignaciones.

### Subgrupos inteligentes

Aplicable a:

- casas;
- departamentos;
- clases;
- equipos;
- sucursales;
- niveles;
- categorias.

Reglas actuales o previstas:

- ignorar subgrupos;
- preferir subgrupo diferente;
- exigir subgrupo diferente;
- restricciones manuales futuras.

### Resultados delegados

Ventaja competitiva real para vida cotidiana:

- si Roy es nino gestionado, Stan ve su resultado para entregarselo;
- si Mami no usa app, su responsable puede entregarle su resultado;
- esto habilita familias y grupos mixtos sin excluir a nadie.

### Futuras dinamicas

Tarci Secret debe crecer sin traicionar la simplicidad:

- duelos;
- batallas;
- emparejamientos;
- equipos;
- parejas;
- torneos simples;
- sorteos sociales.

### Identidad emocional

La marca no es neutra ni generica:

- Tarci;
- madre/familia;
- regalo;
- secreto;
- union;
- sorpresa;
- privacidad;
- emocion.

---

## 5) Propuesta de flujo mejorado para Tarci Secret

Estructura sugerida para balancear claridad (MVP) y escalabilidad (roadmap).

## Home / Dashboard

Debe mostrar:

- logo o marca Tarci Secret;
- accion principal: **Crear amigo secreto**;
- accion secundaria: **Unirse por codigo**;
- grupos activos;
- grupos completados;
- acceso a resultados;
- bloque "Proximas dinamicas" (duelos, equipos, parejas, sorteos sociales).

Regla UX: no saturar la pantalla inicial.

## Selector de dinamica

Opciones:

1. Amigo secreto (principal y recomendado).
2. Duelos o batallas (futuro).
3. Equipos (futuro).
4. Parejas (futuro).
5. Sorteo personalizado (futuro).

## Wizard de amigo secreto

Enfoque: simple, guiado y potente.

### Paso 1 - Nombre del grupo

Ejemplo: `Navidad Familia 2026`

### Paso 2 - Tipo de uso

- Familia
- Amigos
- Empresa
- Clase
- Otro

### Paso 3 - Modalidad

- Remoto
- Presencial
- Mixto

Definicion:

- remoto: cada persona ve o recibe su resultado;
- presencial: resultados uno a uno;
- mixto: combinacion de personas con app y gestionadas.

### Paso 4 - Participantes

Opciones:

- anadir nombres rapido;
- invitar por codigo;
- anadir adulto sin app;
- anadir nino gestionado.

### Paso 5 - Subgrupos

Pregunta inicial: `Quieres usar subgrupos?`

Opciones:

- No, sorteo simple.
- Si, usar casas/departamentos/clases/equipos.

Si la respuesta es "Si":

- crear subgrupos;
- asignar participantes;
- ver quienes faltan por asignar.

### Paso 6 - Reglas

- ignorar subgrupos;
- preferir subgrupo diferente;
- exigir subgrupo diferente;
- restricciones manuales futuras.

### Paso 7 - Revision final

Mostrar:

- participantes totales;
- con app;
- sin app;
- ninos gestionados;
- subgrupos;
- regla;
- modalidad;
- advertencias.

CTA sugerida:

- **Crear grupo**
- o **Ejecutar sorteo** si todo esta listo.

---

## 6) Oportunidades de producto

Priorizacion sugerida por impacto y viabilidad.

## Prioridad alta

- wizard real y simple;
- modo rapido por nombres;
- modalidad remoto/presencial/mixto;
- gestion clara de subgrupos;
- resultados gestionados con copiar/compartir;
- historial basico de grupos completados;
- mejora visual de dashboard y detalle de grupo.

## Prioridad media

- restricciones manuales por participante;
- modo presencial para revelar uno a uno;
- compartir por WhatsApp via share sheet;
- marcar resultado como entregado;
- pantalla de resultado mas emocional;
- cuenta registrada para recuperar grupos;
- vincular usuario anonimo a cuenta registrada.

## Prioridad futura

- email automatico;
- SMS;
- integracion avanzada con WhatsApp;
- wishlist;
- preguntas estructuradas;
- pistas;
- chat/cachondeo controlado;
- duelos/batallas;
- equipos;
- parejas;
- torneos simples;
- monetizacion sin anuncios intrusivos.

---

## 7) Analisis visual y de marca

Analisis basado en activos existentes:

- `imagenes/Icono TarciSecret.png`
- `imagenes/Logo TarciSecret.png`

### Lectura visual actual

- **Icono de app:** composicion fuerte con figura Tarci centrada, caja de regalo frontal, candado visible y ciclo circular. El conjunto comunica "regalo secreto" de forma muy directa.
- **Logo completo:** suma wordmark "Tarci Secret" con jerarquia clara entre "Tarci" (mas protagonista) y "Secret" (mas ligero). Refuerza identidad de marca, no solo funcionalidad.
- **Figura Tarci:** aporta humanidad y cercania. Es un rasgo diferencial frente a apps genericas de sorteo.
- **Regalo + candado + ciclo:** triangulo semantico correcto para promesa de producto (regalo + secreto + dinamica).
- **Paleta morada/dorada con acento rojo:** morado y dorado sostienen calidez/premium; el rojo de la flecha agrega energia, aunque puede sentirse agresivo en ciertos contextos.

### Evaluacion por criterio

- debe sentirse calido y emocional: **cumple**;
- no parecer caricatura barata: **cumple con buena calidad ilustrativa**;
- funcionar como icono pequeno: **cumple parcialmente** (detalle facial puede perderse en tamanos muy chicos);
- ser recordable: **cumple** por personaje + candado;
- transmitir secreto/regalo/privacidad: **cumple**;
- ser mas humano que la competencia: **cumple claramente**;
- verse profesional: **cumple, con margen de refinamiento en sistema de variantes**.

### Recomendaciones de uso de marca

- usar **icono** en app icon, avatar de grupo, accesos rapidos y elementos de tamano reducido;
- usar **logo completo** en splash, onboarding, portada de producto y Play Store;
- revisar intensidad/saturacion de la **flecha roja** para evitar sensacion agresiva (explorar coral mas suave o menor grosor);
- crear **version simplificada** del icono para tamanos pequenos (menos detalle interno, formas mas limpias);
- definir **version monocroma** (claro/oscuro) para fondos complejos y usos de baja tinta;
- preparar **favicon/app-mini icon** optimizado para 16-32 px;
- disenar una **splash screen** de marca con uso respirado del logo, sin sobrecarga de elementos.

---

## 8) Criterio estrategico final

Tarci Secret no debe copiar la app competidora. Debe aprender de su simplicidad y superarla con:

- mayor inclusion;
- privacidad real;
- soporte para grupos familiares reales;
- ninos y personas sin movil;
- subgrupos;
- resultados delegados;
- identidad emocional;
- futuras dinamicas sociales.

Frase clave:

> La competencia resuelve un sorteo rapido. Tarci Secret debe resolver dinamicas reales de grupo con privacidad, emocion y flexibilidad.

---

## 9) Notas de alcance

- Solo documentacion de analisis y direccion de producto.
- No tocar codigo.
- No modificar Flutter.
- No tocar backend.
- No tocar rules.
- No implementar features en esta etapa.
