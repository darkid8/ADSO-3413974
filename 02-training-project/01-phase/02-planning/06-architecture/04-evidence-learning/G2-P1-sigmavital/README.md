# README de entrega · Guía 2: Diseño de la solución (Avance Día 1)

## 1. Datos de la entrega

| Campo | Valor |
|---|---|
| Producto | P1 (artefactos de diseño) |
| Usuario de GitHub del autor | `@darkid8` |
| Ficha | 3413974 |
| Caso elegido (nombre del proyecto) | SIGMAVITAL — Sistema de Gestión de Ambulancias (SGA) |
| Enlace al informe de análisis o SRS del caso (ruta en tu fork) | `02-training-project/01-phase/01-analysis/02-requirements/04-evidence-learning/SRS_SIGMAVITAL_SGA.md` |
| Cuenta de GitHub con la que haces los commits | `@darkid8` |

## 2. Origen del insumo y trabajo en equipo

| Pregunta | Respuesta |
|---|---|
| ¿El SRS / informe de análisis lo elaboró un equipo? ¿Cuántas personas? | Sí, el SRS base de SIGMAVITAL fue elaborado por un equipo de 4 aprendices (más el Instructor como Product Owner). |
| ¿Qué parte del SRS es tuya? | `@darkid8` desempeñó el rol de Desarrollador Backend, definiendo los módulos de Autenticación/RBAC, Ambulancias, Emergencias, Auditoría, reglas de negocio y el diccionario técnico de la base de datos. Para esta entrega individual seleccioné y diseño el subconjunto nuclear de **14 RF** (`RF-002`, `RF-005`, `RF-007`, `RF-008`, `RF-011`, `RF-014`, `RF-016`, `RF-018`, `RF-021`, `RF-022`, `RF-023`, `RF-024`, `RF-028`, `RF-055`) y **5 RNF**. |
| ¿Los artefactos de esta entrega los hiciste tú solo? | Sí, todos los artefactos de diseño (`A1` a `A7`) son de autoría individual de `@darkid8`. |
| ¿Otro aprendiz usó o te compartió archivos de esta entrega? | No. |

## 3. Qué reutilicé, qué ajusté y qué hice nuevo

| Artefacto | Archivo en esta carpeta | Origen (ruta en mi fork o «nuevo») | Qué ajusté o agregué |
|---|---|---|---|
| A1. Ficha de interpretación y plataforma | `A1-ficha-interpretacion-y-plataforma.md` | `02-training-project/01-phase/01-analysis/02-requirements/04-evidence-learning/SRS_SIGMAVITAL_SGA.md` | Seleccioné el subconjunto individual de 14 RF y 5 RNF, eliminé ambigüedades de stack (fijando TypeScript + PostgreSQL) y justifiqué la plataforma con 4 condiciones del caso. |
| A2 y A3. Diagrama de clases y patrones GoF | `A2-A3-diagrama-clases-y-patrones.drawio`, `A2-diagrama-clases.svg`, `A2-A3-clases-y-patrones.md` | Nuevo (referencia conceptual de `SRS_SIGMAVITAL_SGA.md` y práctica `03-execute/15-week/02-optional-activity/`) | Diseñé 16 clases/interfaces tipadas con herencia, composición, agregación, polimorfismo y apliqué los patrones GoF **Strategy** y **Observer**. |
| A4. Arquitectura y tabla de RNF | `A4-arquitectura.drawio`, `A4-arquitectura.svg`, `A4-arquitectura-decisiones.md` | Nuevo (estructura modular de `SRS_SIGMAVITAL_SGA.md` §2.1) | Formalicé 4 capas estrictas sin saltos de capa, canal WSS y tabla de decisiones para 5 RNF con alternativas descartadas. |
| A5. Vista de componentes | *(En elaboración Día 2)* | Nuevo | Se entregará mañana `2026-11-27`. |
| A6. Vista de despliegue | *(En elaboración Día 2)* | Nuevo | Se entregará mañana `2026-11-27`. |
| A7. Matriz de trazabilidad | *(En elaboración Día 2)* | Nuevo | Se entregará mañana `2026-11-27`. |

**Qué reutilicé (resumen en 3 a 5 líneas):**
Reutilicé la especificación SRS de SIGMAVITAL consolidada en el fork (`SRS_SIGMAVITAL_SGA.md`), específicamente el núcleo operativo prehospitalario (autenticación, ambulancias TAB/TAM, personal, pacientes, emergencias, monitoreo y auditoría) junto con sus restricciones y requisitos no funcionales.

**Qué ajusté para llevarlo al estándar de la rúbrica (resumen en 3 a 5 líneas):**
Acoté el alcance individual a 14 RF críticos, eliminé la mezcla de tecnologías que existía en el SRS original (Django/Vue/MySQL) fijando TypeScript + Node.js/Express + React + PostgreSQL, y unifiqué la disponibilidad operativa al 97 %.

**Qué hice completamente nuevo (resumen en 3 a 5 líneas):**
Construí desde cero el diseño orientado a objetos tipado con 16 clases/interfaces, la aplicación explícita de los patrones Strategy y Observer sobre `ServicioDespacho` y la arquitectura formal en 4 capas con alternativas descartadas frente a los RNF.

## 4. Autoverificación de mínimos

**Si es P1:**
- [x] A1 Ficha de interpretación: ≥ 8 RF (14 RF) y ≥ 3 RNF (5 RNF) con ID; plataforma justificada
- [x] A2 Diagrama de clases: ≥ 8 clases (16 clases/interfaces), tipos, métodos, multiplicidades, ≥ 1 composición/agregación y ≥ 1 herencia o interfaz (con ≥ 2 implementaciones)
- [x] A3 ≥ 2 patrones GoF distintos aplicados en el diagrama (Strategy y Observer)
- [x] A4 Arquitectura con diagrama y tabla de ≥ 3 RNF → decisión
- [ ] A5 Vista de componentes *(en elaboración Día 2 — 2026-11-27)*
- [ ] A6 Vista de despliegue *(en elaboración Día 2 — 2026-11-27)*
- [ ] A7 Matriz de trazabilidad análisis → diseño *(en elaboración Día 2 — 2026-11-27)*
- [x] Fuente editable (`.drawio`) e imagen exportada (`.svg`) de cada diagrama del Día 1

## 5. Historial de commits

| Día | Qué avancé (mensaje del commit) |
|---|---|
| `2026-11-26` (Día 1) | `feat(g2-p1): definir plataforma A1, diagrama de clases OO con patrones GoF A2-A3 y arquitectura A4` |
| `2026-11-27` (Día 2) | *(Pendiente mañana: A5, A6, A7 y ajuste de cohesión tras lista B7)* |

## 6. Uso de inteligencia artificial (declaración obligatoria)

| Herramienta | Para qué la usé | Qué verifiqué o cambié después |
|---|---|---|
| Asistente IA (Antigravity) | Apoyo en redacción técnica de justificaciones de plataforma/patrones y generación XML `.drawio` / `.svg`. | Validé que los 14 RF y 5 RNF correspondan exactamente al SRS de SIGMAVITAL y comprobé multiplicidades, composición/agregación y ausencia de saltos de capa. |

## 7. Enlaces

- Informe de análisis / SRS del caso: `02-training-project/01-phase/01-analysis/02-requirements/04-evidence-learning/SRS_SIGMAVITAL_SGA.md`
- Carpeta de esta entrega en GitHub: `https://github.com/darkid8/ADSO-3413974/tree/main/02-training-project/01-phase/02-planning/06-architecture/04-evidence-learning/G2-P1-sigmavital`
- Enlaces internos: [A1](./A1-ficha-interpretacion-y-plataforma.md) · [A2-A3 Clases](./A2-A3-clases-y-patrones.md) · [A4 Arquitectura](./A4-arquitectura-decisiones.md)

## 8. Declaración de autoría

Declaro que los artefactos de esta carpeta son de mi autoría, que lo que reutilicé de mi trabajo del año o de otras fuentes está indicado en la sección 3, que no entregué como propio material del instructor ni de otros aprendices, y que puedo explicar cada artefacto en la verificación oral.

Usuario de GitHub: `@darkid8` · Fecha: `2026-11-26`
