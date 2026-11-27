# README de entrega · Guía 2: Diseño de la solución

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
| A1. Ficha de interpretación y plataforma | `A1-ficha-interpretacion-y-plataforma.md` | `02-training-project/01-phase/01-analysis/02-requirements/04-evidence-learning/SRS_SIGMAVITAL_SGA.md` | Seleccioné 14 RF y 5 RNF, unifiqué disponibilidad (`97 %`) y stack (TypeScript + PostgreSQL) justificado con 4 condiciones del caso. |
| A2 y A3. Diagrama de clases y patrones GoF | `A2-A3-diagrama-clases-y-patrones.drawio`, `A2-diagrama-clases.svg`, `A2-A3-clases-y-patrones.md` | Nuevo (referencia conceptual de `SRS_SIGMAVITAL_SGA.md` y práctica `03-execute/15-week/02-optional-activity/`) | Diseñé 17 clases/interfaces con herencia, composición, agregación, polimorfismo (**Strategy** y **Observer**) y mejoré cohesión en Día 2 extrayendo `GeneradorReporteOperativo`. |
| A4. Arquitectura y tabla de RNF | `A4-arquitectura.drawio`, `A4-arquitectura.svg`, `A4-arquitectura-decisiones.md` | Nuevo (estructura modular de `SRS_SIGMAVITAL_SGA.md` §2.1) | Formalicé 4 capas estrictas sin saltos de capa, canal WSS y tabla de decisiones para 5 RNF con alternativas descartadas. |
| A5. Vista de componentes | `A5-componentes.drawio`, `A5-componentes.svg`, `A5-vista-componentes.md` | Nuevo | Modelé 6 componentes con interfaces provistas/requeridas, dirección de dependencia y clases agrupadas. |
| A6. Vista de despliegue | `A6-despliegue.drawio`, `A6-despliegue.svg`, `A6-vista-despliegue.md` | Nuevo | Definí 4 nodos + almacenamiento de respaldo con protocolos/puertos (`HTTPS:443`, `WSS:443`, `HTTP:3000`, `TCP:5432`, `SFTP:22`) ligados a RNF. |
| A7. Matriz de trazabilidad | `A7-matriz-trazabilidad.md` | Nuevo | Tracé bidireccionalmente 14/14 RF y 5/5 RNF con 0 clases y 0 tablas huérfanas. |

**Qué reutilicé (resumen en 3 a 5 líneas):**
Reutilicé la especificación SRS de SIGMAVITAL consolidada en el fork (`SRS_SIGMAVITAL_SGA.md`), específicamente el núcleo operativo prehospitalario (autenticación, ambulancias TAB/TAM, personal, pacientes, emergencias, monitoreo y auditoría) junto con sus restricciones y requisitos no funcionales.

**Qué ajusté para llevarlo al estándar de la rúbrica (resumen en 3 a 5 líneas):**
Acoté el alcance individual a 14 RF críticos, eliminé la mezcla de tecnologías que existía en el SRS original fijando TypeScript + Node.js/Express + React + PostgreSQL, unifiqué la disponibilidad operativa al 97 % y corregí la cohesión de `ServicioEmergencia` extrayendo el generador de reportes PDF.

**Qué hice completamente nuevo (resumen en 3 a 5 líneas):**
Construí desde cero el diseño orientado a objetos tipado (17 clases/interfaces), los patrones Strategy y Observer sobre `ServicioDespacho`, la arquitectura en 4 capas con alternativas descartadas, la vista de 6 componentes, la vista de despliegue de 4 nodos + respaldo y la matriz bidireccional al 100 %.

## 4. Autoverificación de mínimos

**Si es P1:**
- [x] A1 Ficha de interpretación: ≥ 8 RF (14 RF) y ≥ 3 RNF (5 RNF) con ID; plataforma justificada
- [x] A2 Diagrama de clases: ≥ 8 clases (17 clases/interfaces), tipos, métodos, multiplicidades, ≥ 1 composición/agregación y ≥ 1 herencia o interfaz (con ≥ 2 implementaciones)
- [x] A3 ≥ 2 patrones GoF distintos aplicados en el diagrama (Strategy y Observer)
- [x] A4 Arquitectura con diagrama y tabla de ≥ 3 RNF → decisión
- [x] A5 Vista de componentes: ≥ 5 componentes (6 componentes) con interfaces
- [x] A6 Vista de despliegue: ≥ 3 nodos (4 nodos + respaldo) con artefactos y protocolos
- [x] A7 Matriz de trazabilidad análisis → diseño (100 % bidireccional)
- [x] Fuente editable (`.drawio`) e imagen exportada (`.svg`) de cada diagrama

## 5. Historial de commits

| Día | Qué avancé (mensaje del commit) |
|---|---|
| `2026-11-26` (Día 1) | `feat(g2-p1): definir plataforma A1, diagrama de clases OO con patrones GoF A2-A3 y arquitectura A4` ([`e7e9c43`](https://github.com/darkid8/ADSO-3413974/commit/e7e9c43)) |
| `2026-11-27` (Día 2) | `feat(g2-p1): agregar vistas A5 componentes, A6 despliegue, matriz A7 y mejorar cohesion en A2` ([`b660e8f`](https://github.com/darkid8/ADSO-3413974/commit/b660e8f)) |

## 6. Uso de inteligencia artificial (declaración obligatoria)

| Herramienta | Para qué la usé | Qué verifiqué o cambié después |
|---|---|---|
| Asistente IA (Antigravity) | Apoyo en redacción técnica de justificaciones de plataforma/patrones, vistas y generación XML `.drawio` / `.svg`. | Validé que los 14 RF y 5 RNF correspondan exactamente al SRS de SIGMAVITAL, comprobé multiplicidades/cohesión (`GeneradorReporteOperativo`) y verifiqué dirección de dependencias en componentes. |

## 7. Enlaces

- Informe de análisis / SRS del caso: `02-training-project/01-phase/01-analysis/02-requirements/04-evidence-learning/SRS_SIGMAVITAL_SGA.md`
- Carpeta de esta entrega en GitHub: `https://github.com/darkid8/ADSO-3413974/tree/main/02-training-project/01-phase/02-planning/06-architecture/04-evidence-learning/G2-P1-sigmavital`
- Enlaces internos: [A1](./A1-ficha-interpretacion-y-plataforma.md) · [A2-A3 Clases](./A2-A3-clases-y-patrones.md) · [A4 Arquitectura](./A4-arquitectura-decisiones.md) · [A5 Componentes](./A5-vista-componentes.md) · [A6 Despliegue](./A6-vista-despliegue.md) · [A7 Trazabilidad](./A7-matriz-trazabilidad.md)

## 8. Declaración de autoría

Declaro que los artefactos de esta carpeta son de mi autoría, que lo que reutilicé de mi trabajo del año o de otras fuentes está indicado en la sección 3, que no entregué como propio material del instructor ni de otros aprendices, y que puedo explicar cada artefacto en la verificación oral.

Usuario de GitHub: `@darkid8` · Fecha: `2026-11-27`
