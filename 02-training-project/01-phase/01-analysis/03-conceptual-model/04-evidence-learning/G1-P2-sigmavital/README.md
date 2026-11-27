# Entrega Guía 1 · Producto 2: Modelo de análisis y verificación

## 1. Datos de la entrega

- **Producto:** P2 modelo de análisis y verificación
- **Usuario de GitHub del autor:** `@darkid8`
- **Caso de estudio:** SIGMAVITAL — Sistema de Gestión de Ambulancias (SGA)
- **Trabajo en equipo del año:** Sí (base SRS del proyecto SIGMAVITAL; modelos de análisis, plantillas extendidas, diagramas de actividades, mockups, verificación, ajustes e informe son individuales de `@darkid8`).

## 2. Qué reutilicé

| Artefacto | Ruta original en mi fork (semana) | ¿Lo hice solo o en equipo? |
|---|---|---|
| Especificación SRS y diccionario base de entidades | `02-training-project/01-phase/01-analysis/02-requirements/04-evidence-learning/SRS_SIGMAVITAL_SGA.md` | Base en equipo, depuración individual |
| Flujos de proceso BPMN de referencia vistos en clase | `03-execute/22-week/02-optional-activity/` y `03-execute/23-week/02-optional-activity/` | Referencia individual |

## 3. Qué ajusté

| # | Artefacto | Qué cambié y por qué | Enlace al commit |
|---|---|---|---|
| 1 | `01-plantillas-casos-uso-extendidos.md` (`H-01`, `H-02`) | Se estructuraron `CU-05`, `CU-06` y `CU-07` en Anexo A (Día 1) y luego se eliminaron términos técnicos (`WebSocket`, `tabla servicios`) y la verificación de disponibilidad en precondiciones (`Rubricas_G1.md` §7.3, §7.10). | [`29c3930`](https://github.com/darkid8/ADSO-3413974/commit/29c3930) · [`60fbf20`](https://github.com/darkid8/ADSO-3413974/commit/60fbf20) |
| 2 | `04-modelo-dominio.*` (`H-03`) | Se abstrajeron 11 clases puras (Día 1) y tras la lista de chequeo se retiró el atributo técnico `idSede` de `Ambulancia` y se definió multiplicidad `1` a `0..*` hacia `NovedadOperativa`. | [`29c3930`](https://github.com/darkid8/ADSO-3413974/commit/29c3930) · [`60fbf20`](https://github.com/darkid8/ADSO-3413974/commit/60fbf20) |
| 3 | `05-mer-conceptual.*` (`H-04`, `H-05`) | Se adaptó el núcleo a Pata de Gallo (Día 1) y luego se añadió `hora_incorporacion` en `TRIPULACION_SERVICIO` y la entidad débil `HISTORIAL_ESTADO_SERVICIO` (`11` entidades). | [`29c3930`](https://github.com/darkid8/ADSO-3413974/commit/29c3930) · [`60fbf20`](https://github.com/darkid8/ADSO-3413974/commit/60fbf20) |

## 4. Qué construí nuevo

- `01-plantillas-casos-uso-extendidos.md`: 3 plantillas extendidas completas (`CU-05`, `CU-06`, `CU-07`).
- `02-actividad-despacho.drawio`/`.svg`, `03-actividad-atencion-cierre.drawio`/`.svg` y `02-03-diagramas-actividades.md`: 2 diagramas de actividades con calles, guardas completas y fork/join en `CU-06`.
- `04-modelo-dominio.drawio`/`.svg`/`.md`: 11 clases conceptuales sin métodos, generalización y clase de asociación.
- `05-mer-conceptual.drawio`/`.svg`/`.md`: MER en Pata de Gallo con 11 entidades, N:M resuelta y 2 entidades débiles.
- `06-prototipo-mockups.drawio`, `06-mockup-cu05-solicitud.svg`, `06-mockup-cu06-despacho.svg`, `06-mockup-cu07-cierre.svg` y `06-prototipo-mockups.md`.
- `07-verificacion-lista-chequeo-y-ajustes.md`: Anexo B (16 criterios) y Anexo D (5 hallazgos corregidos y reverificados).
- `08-informe-analisis-y-trazabilidad.md`: Informe de análisis y Matriz de trazabilidad Anexo C (92,31 % RF).

## 5. Artefactos entregados

**Producto 2**

- [x] Diagramas de actividades (2 o más): [02-actividad-despacho.svg](./02-actividad-despacho.svg) · [03-actividad-atencion-cierre.svg](./03-actividad-atencion-cierre.svg) · [02-03-diagramas-actividades.md](./02-03-diagramas-actividades.md)
- [x] Plantillas extendidas de casos de uso (3 o más): [01-plantillas-casos-uso-extendidos.md](./01-plantillas-casos-uso-extendidos.md)
- [x] Modelo de dominio: [04-modelo-dominio.drawio](./04-modelo-dominio.drawio) · [04-modelo-dominio.svg](./04-modelo-dominio.svg) · [04-modelo-dominio.md](./04-modelo-dominio.md)
- [x] Modelo entidad-relación: [05-mer-conceptual.drawio](./05-mer-conceptual.drawio) · [05-mer-conceptual.svg](./05-mer-conceptual.svg) · [05-mer-conceptual.md](./05-mer-conceptual.md)
- [x] Prototipo inicial (3 o más pantallas): [06-prototipo-mockups.drawio](./06-prototipo-mockups.drawio) · [PANT-01](./06-mockup-cu05-solicitud.svg) · [PANT-02](./06-mockup-cu06-despacho.svg) · [PANT-03](./06-mockup-cu07-cierre.svg) · [06-prototipo-mockups.md](./06-prototipo-mockups.md)
- [x] Lista de chequeo diligenciada (15 o más criterios): [07-verificacion-lista-chequeo-y-ajustes.md](./07-verificacion-lista-chequeo-y-ajustes.md)
- [x] Registro de ajustes y segunda verificación: [07-verificacion-lista-chequeo-y-ajustes.md](./07-verificacion-lista-chequeo-y-ajustes.md)
- [x] Informe de análisis: [08-informe-analisis-y-trazabilidad.md](./08-informe-analisis-y-trazabilidad.md)
- [x] Matriz de trazabilidad (Anexo C): [08-informe-analisis-y-trazabilidad.md](./08-informe-analisis-y-trazabilidad.md)

## 6. Declaración de autoría

- [x] Declaro que el ajuste y lo construido nuevo en esta carpeta es **mi trabajo individual**.
- [x] Declaro que lo que tomé de mi equipo o de otra fuente está identificado en la sección 2.
- [x] Entiendo que el sábado 28 de noviembre de 2026 el instructor me hará **3 preguntas orales** sobre mis productos (una del producto 1, una del producto 2 y una a su elección) y que, si respondo bien menos de 2, el producto sobre el que fallé queda con tope de 50.

Firma (usuario de GitHub y fecha): `@darkid8` · `2026-11-27`

## 7. Uso de inteligencia artificial

| Herramienta | Para qué la usé | Qué verifiqué o corregí yo |
|---|---|---|
| Asistente IA (Antigravity) | Apoyo en redacción estructurada de plantillas, diagramas de actividades, mockups y XML en Draw.io/SVG. | Revisé correspondencia 1-a-1 de guardas entre diagramas y plantillas, corregí los 5 hallazgos de la lista de chequeo (`H-01` a `H-05`) y validé cada vínculo de trazabilidad del Anexo C. |

## 8. Autocontrol antes del push

- [x] Hice commits propios en al menos 2 días distintos entre la publicación de la guía (sábado 21 de noviembre de 2026) y la entrega (`2026-11-26` y `2026-11-27`).
- [x] No subí el marco documental del instructor, plantillas sin diligenciar ni archivos de otras personas.
- [x] Hice `push` y comprobé en GitHub que la carpeta está publicada.
