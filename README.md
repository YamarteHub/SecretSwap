# SecretSwap

Base documental y estructura inicial del proyecto **SecretSwap** (MVP).  
En esta etapa el repositorio contiene **especificación, decisiones y artefactos técnicos**, no implementación.

## Documentación clave

- **Especificación consolidada**: `spec/SPEC.md`
- **Esquema de DTOs / modelo de datos**: `spec/DTO_SCHEMA.md`
- **Producto (MVP)**: `docs/product/PRODUCT_OVERVIEW.md`
- **Contrato funcional V1**: `docs/product/FUNCTIONAL_CONTRACT_V1.md`
- **Blueprint técnico Fase 2**: `docs/product/PHASE2_BLUEPRINT.md`
- **Arquitectura**: `docs/architecture/ARCHITECTURE_OVERVIEW.md`
- **Seguridad y reglas**: `docs/security/SECURITY_RULES_OVERVIEW.md`
- **Decisiones (log)**: `docs/decisions/DECISIONS_LOG.md`
- **Emuladores locales (persistencia)**: `docs/backend/LOCAL_EMULATOR_SETUP.md`

## Estructura del proyecto (alto nivel)

- `docs/`: documentación viva del producto y el sistema
- `spec/`: especificación y contratos (DTOs)
- `src/`:
  - `flutter_app/`: app cliente (Flutter) — pendiente de implementación
  - `firebase_functions/`: backend (Firebase Functions) — pendiente de implementación

## Reglas de trabajo (importante)

- La “verdad del proyecto” vive en archivos dentro de esta carpeta, no solo en conversaciones.
- Cada decisión técnica relevante debe registrarse también en `docs/decisions/DECISIONS_LOG.md`.

