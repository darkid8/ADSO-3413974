# Entrega Guía 1 · Producto 1: Plan de análisis y casos de uso

## 1. Datos de la entrega

- **Producto:** P1 plan de análisis y casos de uso
- **Usuario de GitHub del autor:** `@darkid8`
- **Caso de estudio:** SIGMAVITAL — Sistema de Gestión de Ambulancias (SGA)
- **Trabajo en equipo del año:** Sí (equipo de 4 aprendices en el proyecto formativo SIGMAVITAL; la selección metodológica, plan, matriz RF→CU y diagrama UML son trabajo individual de `@darkid8`).

## 2. Qué reutilicé

| Artefacto | Ruta original en mi fork (semana) | ¿Lo hice solo o en equipo? |
|---|---|---|
| Instrumentos y análisis inicial del SGA | `03-execute/08-week/02-optional-activity/Instrumentos_SGA_Completos.docx` | En equipo |
| Cronograma general de actividades del año | `03-execute/10-week/02-optional-activity/Cronograma weeks.md` | En equipo |
| Normativa interna del proyecto SGA | `03-execute/14-week/02-optional-activity/Normativa_Proyecto_SGA_Completa.docx` | En equipo |
| Especificación SRS base de SIGMAVITAL (65 RF, 29 RNF, 18 RN) | `02-training-project/01-phase/01-analysis/02-requirements/04-evidence-learning/SRS_SIGMAVITAL_SGA.md` | Base en equipo, depuración individual |

## 3. Qué ajusté

*(Los enlaces a commits de Día 1 y Día 2 se consolidarán al cierre del segundo día calendario de trabajo.)*

| # | Artefacto | Qué cambié y por qué | Enlace al commit |
|---|---|---|---|
| 1 | `SRS_SIGMAVITAL_SGA.md` | Se corrigió la numeración duplicada de `RST-07` (pasando control de acceso a `RST-09`), se unificó disponibilidad en `97 %` (`RST-04` ↔ `RNF-013`) y se anonimizaron datos personales para repositorio público. | *(Día 1 — 2026-11-26)* |
| 2 | `02-matriz-requisitos-casos-uso.md` | Se consolidaron los 65 RF del SRS en 12 casos de uso orientados a objetivos (evitando fragmentar CRUD) y se justificó la exclusión de `RF-031` a `RF-035` conforme al alcance prehospitalario del SRS §1.6 (92,31 % de cobertura). | *(Día 1 — 2026-11-26)* |
| 3 | `03-diagrama-casos-uso.drawio` / `.svg` | Se incorporaron frontera del sistema, actor temporal (`Temporizador`), sistema externo (`Servicio Correo SMTP`) y relaciones `«include»`/`«extend»` con dirección UML y justificación individual. | *(Día 1 — 2026-11-26)* |

## 4. Qué construí nuevo

- `01-plan-analisis-sigmavital.md`: caracterización completa de SIGMAVITAL en 4 dimensiones, tabla comparativa de RUP, Scrum, XP y RAD, selección justificada de Scrum con trazabilidad documental y plan de 8 actividades priorizadas.
- `02-matriz-requisitos-casos-uso.md`: matriz completa `RF-001` a `RF-065` con distinción explícita frente a `RNF`.
- `03-diagrama-casos-uso.drawio` y `03-diagrama-casos-uso.svg`.

## 5. Artefactos entregados

**Producto 1**

- [x] Caracterización de la solución: [01-plan-analisis-sigmavital.md](./01-plan-analisis-sigmavital.md#1-caracterizaci%C3%B3n-de-la-soluci%C3%B3n)
- [x] Comparación de metodologías y selección justificada: [01-plan-analisis-sigmavital.md](./01-plan-analisis-sigmavital.md#2-comparaci%C3%B3n-de-metodolog%C3%ADas-y-selecci%C3%B3n-justificada)
- [x] Plan de actividades, cronograma y entregables: [01-plan-analisis-sigmavital.md](./01-plan-analisis-sigmavital.md#3-plan-de-actividades-de-an%C3%A1lisis-cronograma-y-entregables)
- [x] Diagrama de casos de uso (fuente editable): [03-diagrama-casos-uso.drawio](./03-diagrama-casos-uso.drawio)
- [x] Diagrama de casos de uso (imagen): [03-diagrama-casos-uso.svg](./03-diagrama-casos-uso.svg)
- [x] Matriz requisito → caso de uso: [02-matriz-requisitos-casos-uso.md](./02-matriz-requisitos-casos-uso.md)

## 6. Declaración de autoría

- [x] Declaro que el ajuste y lo construido nuevo en esta carpeta es **mi trabajo individual**.
- [x] Declaro que lo que tomé de mi equipo o de otra fuente está identificado en la sección 2.
- [x] Entiendo que el sábado 28 de noviembre de 2026 el instructor me hará **3 preguntas orales** sobre mis productos (una del producto 1, una del producto 2 y una a su elección) y que, si respondo bien menos de 2, el producto sobre el que fallé queda con tope de 50.

Firma (usuario de GitHub y fecha): `@darkid8` · `2026-11-26`

## 7. Uso de inteligencia artificial

| Herramienta | Para qué la usé | Qué verifiqué o corregí yo |
|---|---|---|
| Asistente IA (Antigravity) | Apoyo en estructuración de matrices de trazabilidad, redacción comparativa metodológica y generación base de XML `.drawio` / `.svg`. | Verifiqué cobertura de los 65 RF contra el SRS de SIGMAVITAL, validé la dirección de flechas `«include»`/`«extend»` según `Rubricas_G1.md` §7.2 y revisé las exclusiones del §1.6. |

## 8. Autocontrol antes del push

- [x] Commit del Día 1 publicado hoy `2026-11-26` *(Día 2 se completará mañana `2026-11-27`)*.
- [x] No subí el marco documental del instructor, plantillas sin diligenciar ni archivos de otras personas.
- [x] Verificación en GitHub pendiente inmediatamente tras el `git push` de hoy.
