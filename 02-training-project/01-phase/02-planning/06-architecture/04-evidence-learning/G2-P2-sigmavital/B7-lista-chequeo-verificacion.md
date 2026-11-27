# B7 · Lista de Chequeo de Verificación del Diseño y Registro de Hallazgos — SIGMAVITAL (SGA)

**Autor:** `@darkid8`  
**Alcance:** Verificación cruzada sobre todos los artefactos de **G2-P1** (`A1`–`A7`) y **G2-P2** (`B1`–`B6`).  
**Criterios evaluados:** **24 criterios medibles** agrupados en 8 categorías con severidad (`Crítico`, `Mayor`, `Menor`) y evidencia verificable.

---

## 1. Lista de chequeo diligenciada (`24 criterios`)

| ID | Artefacto / Categoría | Criterio de aceptación (medible) | Severidad | Cumple | Evidencia verificable |
|---|---|---|---|---|---|
| `LC-01` | Clases (`A2`) | El diagrama contiene ≥ 8 clases con atributos tipados, visibilidad y métodos con parámetros | Crítico | **Sí** | `G2-P1/A2-A3-diagrama-clases-y-patrones.drawio` (17 clases/interfaces tipadas). |
| `LC-02` | Clases (`A2`) | Ninguna clase reúne responsabilidades de áreas distintas (UI, negocio, persistencia, reportes) | Mayor | **Sí** *(ajustado)* | `ServicioEmergencia` quedó solo con estado/cierre; reporte movido a `GeneradorReporteOperativo` (`H-01`). |
| `LC-03` | Clases (`A2`) | Todas las asociaciones traen multiplicidad en ambos extremos e incluyen ≥ 1 composición/agregación y ≥ 1 herencia/interfaz | Mayor | **Sí** | `Ambulancia ◆ DocumentoHabilitacion`, `Servicio ◇ Ambulancia`, `PersonalOperativo <\|-- Paramedico/Conductor`. |
| `LC-04` | Clases (`A2`/`A7`) | El 100 % de las clases del diagrama traza a ≥ 1 requisito de la matriz `A7` | Mayor | **Sí** | `G2-P1/A7-matriz-trazabilidad.md` §2 (17/17 clases trazadas, 0 huérfanas). |
| `LC-05` | Patrones (`A3`) | Se aplican ≥ 2 patrones GoF distintos en el diagrama (al menos uno distinto de Singleton) con justificación del caso | Crítico | **Sí** | **Strategy** (`ICriterioAsignacion`) + **Observer** (`ISuscriptorEventoOperativo`) en `A2-A3-clases-y-patrones.md`. |
| `LC-06` | Patrones (`A3`) | Existe polimorfismo real verificable mediante interfaz con ≥ 2 implementaciones concretas | Mayor | **Sí** | `ICriterioAsignacion` (`AsignacionCriticaTAM`, `AsignacionEstandarTAB`) y `ISuscriptorEventoOperativo` (`MonitorTableroTiempoReal`, `RegistradorAuditoriaInmutable`). |
| `LC-07` | Arquitectura (`A4`) | El diagrama define estilo por capas sin saltos de capa (Presentación no accede directo a BD) | Crítico | **Sí** | `G2-P1/A4-arquitectura.svg`: flujo estricto `Capa 1 → Capa 2 → Capa 3 → Capa 4`. |
| `LC-08` | Arquitectura (`A4`) | La tabla de decisiones atiende ≥ 3 RNF con alternativa descartada y razón del descarte | Mayor | **Sí** | `G2-P1/A4-arquitectura-decisiones.md` §2 cubre 5 RNF (`RNF-001, 002, 004, 009, 013`) + estilo. |
| `LC-09` | Componentes (`A5`) | Existen ≥ 5 componentes con interfaces provistas y requeridas nombradas y flechas en dirección correcta | Crítico | **Sí** | `G2-P1/A5-componentes.svg`: 6 componentes con `IAuthRBAC`, `IDespacho`, `IFlotaHabilitacion`, `IMonitoreoWS`, `IAuditoria`, `IRepositorioDatos`. |
| `LC-10` | Componentes (`A5`) | Cada componente indica las clases que agrupa y los requisitos que atiende | Menor | **Sí** | Tabla de mapeo en `G2-P1/A5-vista-componentes.md`. |
| `LC-11` | Despliegue (`A6`) | Existen ≥ 3 nodos con artefactos alojados, protocolo/puerto en cada conexión y ≥ 1 decisión RNF | Mayor | **Sí** | `G2-P1/A6-despliegue.svg`: 4 nodos + respaldo con `HTTPS:443`, `WSS:443`, `HTTP:3000`, `TCP:5432`, `SFTP:22`. |
| `LC-12` | Trazabilidad (`A7`) | La matriz cubre el 100 % de los RF seleccionados en `A1` en ambos sentidos | Crítico | **Sí** | `G2-P1/A7-matriz-trazabilidad.md` (14/14 RF + 5/5 RNF + 12/12 tablas). |
| `LC-13` | Modelo datos (`B1`) | El modelo conceptual contiene ≥ 6 entidades con PK, cardinalidad mín/máx, verbo, ≥ 1 N:M y ≥ 1 1:N | Crítico | **Sí** | `G2-P2/B1-modelo-conceptual.svg`: 9 entidades, N:M (`PERSONAL ↔ SERVICIO`), 1:N y justificación relacional. |
| `LC-14` | Modelo datos (`B2`) | El modelo lógico contiene ≥ 8 tablas con PK/FK, tabla intermedia N:M y cuadro de reglas de transformación | Crítico | **Sí** | `G2-P2/B2-modelo-logico.svg` y `B2-modelo-logico-y-reglas.md` (12 tablas y 5 reglas aplicadas). |
| `LC-15` | Modelo datos (`B3`) | Evidencia paso a paso `0FN → 3FN` de ≥ 2 tablas propias con DF escritas (una llave compuesta y una transitiva) | Crítico | **Sí** | `G2-P2/B3-normalizacion.md`: `despacho_tripulacion_0fn` (2FN) y `ficha_ambulancia_sede_0fn` (3FN). |
| `LC-16` | Modelo datos (`B3`) | El modelo final queda sin atributos multivaluados (1FN), dependencias parciales (2FN) ni transitivas (3FN) | Crítico | **Sí** | Verificado en `telefono_paciente` (1FN), `tripulacion_servicio` (2FN) y `sede` (3FN). |
| `LC-17` | Diccionario y SQL (`B4`) | El diccionario cubre el 100 % de tablas y columnas con estándar de nombrado, tipo, tamaño, restricciones y dominio | Mayor | **Sí** | `G2-P2/B4-diccionario-datos.md`: 12/12 tablas y 67 columnas en `snake_case`. |
| `LC-18` | Diccionario y SQL (`B5`) | El script SQL ejecuta sin errores en un motor real y crea el 100 % de las tablas con PK, FK, `NOT NULL`, `UNIQUE` | Crítico | **Sí** | `G2-P2/B5-evidencia-ejecucion.log` (SQLite3 sin errores, `12/12` tablas creadas). |
| `LC-19` | Diccionario y SQL (`B5`) | El script incluye ≥ 3 restricciones `CHECK` y acción referencial `ON DELETE` en ≥ 3 llaves foráneas | Mayor | **Sí** | `B5-schema-sigmavital.sql` declara `12 CHECK` y `11 FK` con `ON DELETE RESTRICT/CASCADE/SET NULL`. |
| `LC-20` | Diccionario y SQL (`B4`/`B5`) | Los nombres de tablas, columnas y tipos del script SQL coinciden 100 % con el diccionario de datos | Mayor | **Sí** | Verificación directa `B4` ↔ `B5`: 0 discrepancias de nombres o restricciones. |
| `LC-21` | Seguridad (`B6`) | Existen ≥ 6 políticas concretas (≥ 2 por Integridad, Confidencialidad y Disponibilidad) ligadas a tablas del caso | Crítico | **Sí** | `G2-P2/B6-politicas-seguridad-y-roles.md` §1 (`POL-INT-01..02`, `POL-CON-01..02`, `POL-DIS-01..02`). |
| `LC-22` | Seguridad (`B6`) | Las contraseñas se declaran con **hash y sal** (no cifradas), tráfico por TLS y tratamiento Ley 1581/2012 | Crítico | **Sí** | `POL-CON-01` (`bcrypt`/`Argon2id` + `TLS 1.3`) y `POL-CON-02` (`paciente` bajo Ley 1581/2012). |
| `LC-23` | Seguridad (`B6`) | Matriz de ≥ 3 roles contra todas las tablas y respaldo con frecuencia y prueba mensual de restauración | Mayor | **Sí** | `B6` §2 (4 roles × 12 tablas) y `POL-DIS-01`/`POL-DIS-02` (diario + prueba mensual). |
| `LC-24` | Calidad documental | Todos los diagramas tienen fuente editable (`.drawio`), imagen exportada (`.svg`) y `README.md` completo | Menor | **Sí** | Verificado en `G2-P1` y `G2-P2` (XML válido en todos los archivos). |

---

## 2. Registro de hallazgos y correcciones aplicadas (`4 hallazgos`)

| ID | Artefacto | Descripción del hallazgo | Requisito / Principio afectado | Severidad | Corrección aplicada |
|---|---|---|---|---|---|
| `H-01` | `G2-P1/A2` Diagrama de clases | En la versión v1 de Día 1, `ServicioEmergencia` incluía `+exportarReportePDF(): Buffer`, mezclando lógica de negocio APH con generación de reportes. | Cohesión (`Rubricas_G2.md` §1.2.5) | **Mayor** | Se retiró el método de `ServicioEmergencia` y se extrajo a `GeneradorReporteOperativo` (`+generarResumenPDF(srv)`), reflejado en `A2` y `A5` en el commit [`b660e8f`](https://github.com/darkid8/ADSO-3413974/commit/b660e8f). |
| `H-02` | `G2-P1/A1` y `A4` vs SRS | El borrador original del SRS presentaba disponibilidad contradictoria (`77 %` en `RST-04` vs `97 %` en `RNF-013`) y mezcla de stack (Django/Vue/MySQL). | `RNF-013` y consistencia | **Mayor** | Se unificó disponibilidad al `97 %` en `SRS_SIGMAVITAL_SGA.md` ([`277cdc5`](https://github.com/darkid8/ADSO-3413974/commit/277cdc5)) y se fijó stack único TypeScript + PostgreSQL en `A1` ([`e7e9c43`](https://github.com/darkid8/ADSO-3413974/commit/e7e9c43)). |
| `H-03` | `G2-P1/A1` vs Código previo | Los roles genéricos del prototipo inicial (`medico`, `enfermero`, `paciente`) no coincidían con el dominio prehospitalario del SRS. | `RF-005`, `RF-014` | **Menor** | Se alinearon los roles y clases en `A2`, `B2` y `B6` a `Administrador`, `Coordinador Operativo`, `Paramedico` (`TAB`/`TAM`), `Conductor` y `Analista Directivo`. |
| `H-04` | `G2-P2/B2` y `B4` vs `B5` | Al preparar el script `B5` en motor SQLite/PostgreSQL, se verificó que `ENUM` sin restricción `CHECK` portable y tipos `UUID` sin generador en SQLite impedirían ejecutar el DDL en pruebas locales. | `B5` Consistencia modelo-diccionario-SQL | **Mayor** | Se estandarizaron tipos `INTEGER` y restricciones explícitas `CHECK` en `B4` y `B5` logrando ejecución limpia con `0` errores en SQLite3 y compatibilidad directa con PostgreSQL. |
