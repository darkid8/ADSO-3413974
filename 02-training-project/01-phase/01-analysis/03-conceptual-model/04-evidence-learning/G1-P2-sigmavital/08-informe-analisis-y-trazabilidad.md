# Informe de Análisis y Matriz de Trazabilidad — SIGMAVITAL (SGA)

**Autor:** `@darkid8`  
**Caso de estudio:** SIGMAVITAL — Sistema de Gestión de Ambulancias (SGA)  
**Fecha:** `2026-11-27`

---

## 1. Requisitos interpretados (`RF-001` a `RF-065` y `RNF-001` a `RNF-029`)

A partir de la especificación SRS depurada ([SRS_SIGMAVITAL_SGA.md](../../../02-requirements/04-evidence-learning/SRS_SIGMAVITAL_SGA.md)), se interpretaron **65 requisitos funcionales** y **29 requisitos no funcionales** diferenciando claramente las **funciones de negocio observables** (`RF`) de las **cualidades sistémicas transversales** (`RNF`):

- **Alcance modelado (`60 RF = 92,31 %`):** Agrupados en **12 casos de uso base** (`CU-01` a `CU-12`) más **4 casos incluidos/extendidos** (`CU-13` a `CU-16`) que cubren Autenticación/RBAC (`RF-001`–`RF-007`), Flota TAB/TAM y habilitación REPS (`RF-008`–`RF-013`, `RF-045`–`RF-046`), Personal (`RF-014`–`RF-017`), Pacientes y Emergencias (`RF-018`–`RF-027`), Monitoreo en tiempo real (`RF-028`–`RF-029`), Novedades (`RF-059`–`RF-063`), Auditoría/Reportes (`RF-055`–`RF-058`, `RF-064`–`RF-065`) y Soporte institucional (`RF-030`, `RF-036`–`RF-044`, `RF-047`–`RF-054`).
- **Exclusiones justificadas (`5 RF = 7,69 %`):** Los requisitos `RF-031` a `RF-035` (facturación electrónica automática, cartera y mora comercial) quedan excluidos de esta primera fase prehospitalaria en estricta coherencia con las exclusiones declaradas en el SRS §1.6.
- **Requisitos no funcionales transversales (`RNF-001` a `RNF-029`):** Seguridad (`bcrypt` + sal, `TLS`, Ley 1581/2012), rendimiento (`≤ 2 s` en asignación automática, `≤ 3 s` en consultas), disponibilidad unificada al `97 %` (`RST-04` ↔ `RNF-013`), usabilidad en `≤ 4 pasos`, retención de auditoría a `5 años` y respaldos diarios (`RPO ≤ 24 h`, `RTO ≤ 4 h`).

---

## 2. Enlaces a todos los modelos generados (`G1-P1` y `G1-P2`)

| Artefacto | Enlace en el repositorio |
|---|---|
| Plan de análisis, comparación metodológica y cronograma | [G1-P1/01-plan-analisis-sigmavital.md](../G1-P1-sigmavital/01-plan-analisis-sigmavital.md) |
| Matriz requisito → caso de uso (`65 RF`) | [G1-P1/02-matriz-requisitos-casos-uso.md](../G1-P1-sigmavital/02-matriz-requisitos-casos-uso.md) |
| Diagrama de casos de uso UML + justificaciones | [03-diagrama-casos-uso.drawio](../G1-P1-sigmavital/03-diagrama-casos-uso.drawio) · [03-diagrama-casos-uso.svg](../G1-P1-sigmavital/03-diagrama-casos-uso.svg) · [Justificación](../G1-P1-sigmavital/03-justificacion-casos-uso.md) |
| Plantillas extendidas de casos de uso (`CU-05`, `CU-06`, `CU-07`) | [01-plantillas-casos-uso-extendidos.md](./01-plantillas-casos-uso-extendidos.md) |
| Diagramas de actividades UML (`CU-06` y `CU-07`) | [02-actividad-despacho.drawio](./02-actividad-despacho.drawio) · [02-actividad-despacho.svg](./02-actividad-despacho.svg) · [03-actividad-atencion-cierre.drawio](./03-actividad-atencion-cierre.drawio) · [03-actividad-atencion-cierre.svg](./03-actividad-atencion-cierre.svg) · [Detalle](./02-03-diagramas-actividades.md) |
| Modelo de dominio conceptual (`11 clases`) | [04-modelo-dominio.drawio](./04-modelo-dominio.drawio) · [04-modelo-dominio.svg](./04-modelo-dominio.svg) · [04-modelo-dominio.md](./04-modelo-dominio.md) |
| Modelo Entidad-Relación (`11 entidades`, Pata de Gallo) | [05-mer-conceptual.drawio](./05-mer-conceptual.drawio) · [05-mer-conceptual.svg](./05-mer-conceptual.svg) · [05-mer-conceptual.md](./05-mer-conceptual.md) |
| Prototipo inicial (`3 pantallas` rotuladas) | [06-prototipo-mockups.drawio](./06-prototipo-mockups.drawio) · [PANT-01](./06-mockup-cu05-solicitud.svg) · [PANT-02](./06-mockup-cu06-despacho.svg) · [PANT-03](./06-mockup-cu07-cierre.svg) · [Índice](./06-prototipo-mockups.md) |

---

## 3. Resultado de la verificación y ajustes realizados

La aplicación de la lista de chequeo de **16 criterios verificables** ([07-verificacion-lista-chequeo-y-ajustes.md](./07-verificacion-lista-chequeo-y-ajustes.md)) sobre la versión inicial arrojó **11 criterios cumplidos y 5 hallazgos (`H-01` a `H-05`)**:
- **`H-01` y `H-02`:** Eliminación de términos técnicos (`WebSocket`, tabla `servicios`) en el flujo de `CU-06` y depuración de precondiciones dejando la verificación de disponibilidad en excepción `2a`.
- **`H-03`:** Retiro del atributo técnico `idSede` de la clase conceptual `Ambulancia` y definición de multiplicidad `1` a `0..*` hacia `NovedadOperativa`.
- **`H-04` y `H-05`:** Inclusión del atributo propio `hora_incorporacion` en la entidad asociativa `TRIPULACION_SERVICIO` y adición de la entidad débil `HISTORIAL_ESTADO_SERVICIO` al MER.

Tras aplicar los cinco ajustes en el commit [`60fbf20`](https://github.com/darkid8/ADSO-3413974/commit/60fbf20), la segunda verificación registró **16/16 criterios cumplidos (`100 %`)**.

---

## 4. Anexo C · Matriz de trazabilidad requisito → artefactos (`60/65 RF = 92,31 %`)

| Requisito | Caso de uso | Diagrama de actividades / Plantilla | Clase de dominio | Entidad del MER | Pantalla (casos críticos) |
|---|---|---|---|---|---|
| `RF-001`..`RF-007` | `CU-01`, `CU-02` (`«include»` `CU-14`) | Matriz `G1-P1` | `PersonalOperativo` (acceso) | `ROL`, `USUARIO` | Menú RBAC (`PANT-01..03`) |
| `RF-008`..`RF-013`, `RF-045`–`RF-046` | `CU-03`, `CU-12`, `CU-13` | `02-actividad-despacho`, Plantilla `CU-06` | `Ambulancia`, `DocumentoHabilitacion`, `SedeOperativa` | `SEDE`, `AMBULANCIA`, `DOCUMENTO_UNIDAD` | `PANT-02` (`CU-06` validación `CU-13`) |
| `RF-014`..`RF-017` | `CU-04`, `CU-12`, `CU-13` | `02-actividad-despacho`, Plantilla `CU-06` | `PersonalOperativo`, `Paramedico`, `Conductor` | `PERSONAL`, `TRIPULACION_SERVICIO` | `PANT-02` (`CU-06`) |
| `RF-018`..`RF-021` | `CU-05` | Plantilla `CU-05` | `Paciente`, `SolicitudEmergencia` | `PACIENTE`, `SOLICITUD_EMERGENCIA` | `PANT-01 · CU-05` |
| `RF-022` | `CU-06` (`«include»` `CU-13`, `CU-14`) | `02-actividad-despacho`, Plantilla `CU-06` | `SolicitudEmergencia`, `ServicioAtencion`, `Ambulancia` | `SERVICIO`, `TRIPULACION_SERVICIO` | `PANT-02 · CU-06` |
| `RF-023` | `CU-15` (`«extend»` `CU-06`) | `02-actividad-despacho`, Plantilla `CU-06` (`4a`) | `ServicioAtencion`, `Ambulancia` | `SERVICIO` | `PANT-02 · CU-06` |
| `RF-024`–`RF-025` | `CU-07` (`«include»` `CU-14`) | `03-actividad-atencion-cierre`, Plantilla `CU-07` | `ServicioAtencion`, `PersonalOperativo` | `SERVICIO`, `HISTORIAL_ESTADO_SERVICIO` | `PANT-03 · CU-07` |
| `RF-026` | `CU-06` | Plantilla `CU-06` (`4b`) | `ServicioAtencion` | `SERVICIO`, `HISTORIAL_ESTADO_SERVICIO` | `PANT-02 · CU-06` |
| `RF-027` | `CU-07`, `CU-10` | Plantilla `CU-07` | `ServicioAtencion` | `SERVICIO`, `HISTORIAL_ESTADO_SERVICIO` | `PANT-03 · CU-07` |
| `RF-028`–`RF-029` | `CU-08` | `02-actividad-despacho` (rama fork) | `Ambulancia`, `ServicioAtencion` | `AMBULANCIA`, `SERVICIO` | `PANT-02 · CU-06` |
| `RF-030`, `RF-036`–`RF-044`, `RF-047`–`RF-054` | `CU-11`, `CU-12` | Matriz `G1-P1` *(soporte institucional SRS §6.1.3)* | `SedeOperativa`, `DocumentoHabilitacion` | `USUARIO`, `ROL`, `DOCUMENTO_UNIDAD` | n/a *(módulos no críticos)* |
| `RF-031`–`RF-035` | **Excluido** *(SRS §1.6)* | Justificado en `G1-P1/02-matriz` | n/a | n/a | n/a |
| `RF-055`–`RF-058`, `RF-064`–`RF-065` | `CU-10`, `CU-14` | `02-actividad-despacho`, `03-actividad-atencion-cierre` | `ServicioAtencion` | `HISTORIAL_ESTADO_SERVICIO`, `USUARIO` | Trazado en cierre `PANT-03` |
| `RF-059`–`RF-063` | `CU-09`, `CU-16` (`«extend»` `CU-07`) | `03-actividad-atencion-cierre`, Plantilla `CU-07` (`4a`) | `NovedadOperativa`, `ServicioAtencion` | `SERVICIO` | `PANT-03 · CU-07` (botón `CU-16`) |
