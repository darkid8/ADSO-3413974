# Entrega Guía 1 · Producto 2: Modelo de análisis y verificación (Avance Día 1)

## 1. Datos de la entrega

- **Producto:** P2 modelo de análisis y verificación
- **Usuario de GitHub del autor:** `@darkid8`
- **Caso de estudio:** SIGMAVITAL — Sistema de Gestión de Ambulancias (SGA)
- **Trabajo en equipo del año:** Sí (base SRS del proyecto SIGMAVITAL; modelos de análisis, plantillas extendidas, verificación y ajustes son individuales de `@darkid8`).

## 2. Qué reutilicé

| Artefacto | Ruta original en mi fork (semana) | ¿Lo hice solo o en equipo? |
|---|---|---|
| Especificación SRS y diccionario base de entidades | `02-training-project/01-phase/01-analysis/02-requirements/04-evidence-learning/SRS_SIGMAVITAL_SGA.md` | Base en equipo, depuración individual |
| Flujos de proceso BPMN de referencia vistos en clase | `03-execute/22-week/02-optional-activity/` y `03-execute/23-week/02-optional-activity/` | Referencia individual |

## 3. Qué ajusté

*(Registro completo de los ≥ 5 hallazgos de verificación con antes/después y enlaces a commits de Día 1 y Día 2 se consolidará mañana en `07-lista-chequeo-y-ajustes.md` tras la verificación cruzada.)*

| # | Artefacto | Qué cambié y por qué | Enlace al commit |
|---|---|---|---|
| 1 | `01-plantillas-casos-uso-extendidos.md` | Estructuración narrativa de flujos del SRS de SIGMAVITAL bajo el formato Anexo A (`CU-05`, `CU-06`, `CU-07`). | *(Día 1 — 2026-11-26)* |
| 2 | `04-modelo-dominio.*` | Abstracción de clases conceptuales de negocio puras (sin métodos) desde el dominio APH del SRS. | *(Día 1 — 2026-11-26)* |
| 3 | `05-mer-conceptual.*` | Adaptación de las entidades núcleo del SRS a notación Pata de Gallo con entidad asociativa N:M y entidad débil. | *(Día 1 — 2026-11-26)* |

## 4. Qué construí nuevo (Día 1)

- `01-plantillas-casos-uso-extendidos.md` (3 plantillas extendidas v1).
- `04-modelo-dominio.drawio`, `.svg` y `.md` (11 clases conceptuales, generalización y clase de asociación).
- `05-mer-conceptual.drawio`, `.svg` y `.md` (MER en Pata de Gallo v1).
- *(Pendiente para Día 2: 2 diagramas de actividades, 3 mockups rotulados, lista de chequeo ≥ 15 criterios, registro de ≥ 5 ajustes, informe de análisis y matriz Anexo C).*

## 5. Artefactos entregados

**Producto 2**

- [ ] Diagramas de actividades (2 o más): *(en construcción para Día 2 — 2026-11-27)*
- [x] Plantillas extendidas de casos de uso (3 o más): [01-plantillas-casos-uso-extendidos.md](./01-plantillas-casos-uso-extendidos.md)
- [x] Modelo de dominio: [04-modelo-dominio.drawio](./04-modelo-dominio.drawio) · [04-modelo-dominio.svg](./04-modelo-dominio.svg) · [04-modelo-dominio.md](./04-modelo-dominio.md)
- [x] Modelo entidad-relación: [05-mer-conceptual.drawio](./05-mer-conceptual.drawio) · [05-mer-conceptual.svg](./05-mer-conceptual.svg) · [05-mer-conceptual.md](./05-mer-conceptual.md)
- [ ] Prototipo inicial (3 o más pantallas): *(en construcción para Día 2 — 2026-11-27)*
- [ ] Lista de chequeo diligenciada (15 o más criterios): *(en construcción para Día 2 — 2026-11-27)*
- [ ] Registro de ajustes y segunda verificación: *(en construcción para Día 2 — 2026-11-27)*
- [ ] Informe de análisis: *(en construcción para Día 2 — 2026-11-27)*
- [ ] Matriz de trazabilidad (Anexo C): *(en construcción para Día 2 — 2026-11-27)*

## 6. Declaración de autoría

- [x] Declaro que el ajuste y lo construido nuevo en esta carpeta es **mi trabajo individual**.
- [x] Declaro que lo que tomé de mi equipo o de otra fuente está identificado en la sección 2.
- [x] Entiendo que el sábado 28 de noviembre de 2026 el instructor me hará **3 preguntas orales** sobre mis productos (una del producto 1, una del producto 2 y una a su elección) y que, si respondo bien menos de 2, el producto sobre el que fallé queda con tope de 50.

Firma (usuario de GitHub y fecha): `@darkid8` · `2026-11-26`

## 7. Uso de inteligencia artificial

| Herramienta | Para qué la usé | Qué verifiqué o corregí yo |
|---|---|---|
| Asistente IA (Antigravity) | Apoyo en redacción estructurada de plantillas de casos de uso y generación XML de modelos en Draw.io/SVG. | Revisé correspondencia de reglas de negocio `RN-001` a `RN-010` y preparé puntos de inspección para la lista de chequeo del Día 2. |

## 8. Autocontrol antes del push

- [x] Commit del Día 1 publicado hoy `2026-11-26` *(Día 2 se completará mañana `2026-11-27`)*.
- [x] No subí el marco documental del instructor, plantillas sin diligenciar ni archivos de otras personas.
- [x] Verificación en GitHub pendiente inmediatamente tras el `git push` de hoy.
