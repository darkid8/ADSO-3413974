# Evidencias Semana 25 (17-10-2026) — ADSO Ficha 3413974

**Fecha de Entrega:** 17 de Octubre de 2026  
**Fase:** 03 - Ejecución  
**Ubicación:** `03-execute/25-week/02-optional-activity`  
**Materia / Instructor:** Arquitectura de Software y Sistemas Transaccionales  
**Caso de Estudio:** Documentación Técnica de Arquitectura `orderflow-engine-docs-main` (Prueba Técnica Tech Lead)

---

## 📌 Contenido de la Entrega

De acuerdo con las instrucciones y el trabajo asignado por el instructor para esta semana, se desarrolló un análisis exhaustivo y riguroso de arquitectura, diseño transaccional y lógica de negocio sobre el motor transaccional de pedidos y precios **Orderflow Engine**.

Los entregables generados para esta semana se organizan de la siguiente manera dentro de `02-optional-activity`:

### 1. [Entregable 1: Análisis Arquitectónico y de Lógica de Negocio](02-optional-activity/01-analisis-arquitectura-orderflow-engine.md)
Documento general y detallado que cubre:
- **Resumen Ejecutivo y Contexto:** Origen del problema (*confirmed but missing*) y cómo se resuelven las fallas en releases anteriores.
- **Topología y Arquitectura Hexagonal:** Desacoplamiento entre núcleo puro (`pricing.domain`), puertos de aplicación y adaptadores de infraestructura (`JdbcClient` sin ORM para control estricto de bloqueos).
- **Las 4 Garantías Principales:** Cotizaciones selladas (G-1), dinero con `BigDecimal` y sin punto flotante (G-2), la invariante del HTTP `201 Created` tras el commit (G-3) y el patrón Transactional Outbox (G-4).
- **Funcionamiento del Frontend (`orderflow-engine-web`):** Componentes defensivos (`ui-text`, `ui-action-bar`, `ui-product-image`), ausencia de cálculos monetarios en cliente y manejo de idempotencia en UI.
- **Análisis Crítico:** Identificación de posibles errores técnicos, vacíos funcionales (falta de reserva de inventario, contención en crédito, eventos muertos en outbox) y mejoras sugeridas.

### 2. [Entregable 2: 5 Preguntas Técnicas y de Lógica de Negocio](02-optional-activity/02-cinco-preguntas-tecnicas-logica-negocio.md)
Documento especializado con 5 preguntas de alto nivel técnico orientadas a situaciones límite del mundo real:
1. **Desfase de Inventario:** Cotización sellada vs rotura de stock en el almacén físico antes de la confirmación.
2. **Consistencia Eventual y Outbox:** Qué sucede cuando un evento pasa a estado `DEAD` por rechazo definitivo del ERP sin sagas compensatorias.
3. **Alta Concurrencia en Crédito:** Contención y serialización de bloqueos de fila (`X-lock`) en cuentas corporativas con múltiples sucursales.
4. **Impacto Fiscal en Combos:** Prorrateo del resto mayor en paquetes con distintas tasas de IVA ante notas crédito y devoluciones parciales.
5. **Riesgo Comercial y Revocación:** Consecuencias financieras de un error de precio en catálogo (*pricing glitch*) durante el TTL de 15 minutos sin un mecanismo de revocación de cotizaciones abiertas.

---

## 📂 Estructura de Archivos en el Repositorio

```
03-execute/25-week/
├── README.md                                                   # Índice y presentación de la semana
├── 01-session/
│   └── 01-activity/
│       └── .gitkeep                                            # Sesión regular
└── 02-optional-activity/
    ├── .gitkeep
    ├── 01-analisis-arquitectura-orderflow-engine.md            # Entregable 1: Análisis arquitectónico completo
    └── 02-cinco-preguntas-tecnicas-logica-negocio.md           # Entregable 2: 5 preguntas técnicas y de negocio
```
