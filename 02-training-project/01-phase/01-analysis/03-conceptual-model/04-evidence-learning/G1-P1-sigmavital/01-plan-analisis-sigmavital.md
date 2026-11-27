# Plan de Análisis y Selección Metodológica — SIGMAVITAL (SGA)

**Autor:** `@darkid8`  
**Caso de estudio:** SIGMAVITAL — Sistema de Gestión de Ambulancias (SGA)  
**Fuente de requisitos:** [SRS_SIGMAVITAL_SGA.md](../../../02-requirements/04-evidence-learning/SRS_SIGMAVITAL_SGA.md)

---

## 1. Caracterización de la solución

| Aspecto obligatorio | Caracterización específica de SIGMAVITAL (SGA) |
|---|---|
| **Tipo de proyecto** | Plataforma web crítica de gestión operativa y atención prehospitalaria (APH) para registro de emergencias, despacho de ambulancias TAB/TAM y monitoreo en tiempo real, regulada por la **Resolución 3100 de 2017** (REPS) y la **Ley 1581 de 2012** (Habeas Data). |
| **Tamaño del equipo** | Equipo pequeño de **4 desarrolladores** (Backend `@darkid8`, Frontend, Fullstack y Scrum Master) más **1 Product Owner / Instructor** que valida prioridades y entregables. |
| **Estabilidad de requisitos** | **Mixta / Media-Alta:** El núcleo regulatorio (habilitación TAB/TAM, trazabilidad de estados, auditoría inmutable, reglas `RN-001` a `RN-010`) es estable; en cambio, los criterios visuales del panel de monitoreo en tiempo real, alertas y formatos de reportes evolucionan de forma iterativa con las validaciones. |
| **Disponibilidad del cliente / PO** | **Parcial y periódica:** El Product Owner e interesados institucionales no participan a tiempo completo en sitio, pero asisten a sesiones semanales de revisión, retroalimentación y validación de incrementos. |

---

## 2. Comparación de metodologías y selección justificada

Se comparan las cuatro metodologías indicadas en `Rubricas_G1.md` (§4.1 b) usando criterios derivados directamente de las características anteriores:

| Metodología | Ajuste a equipo pequeño (4 devs) | Adaptación a requisitos mixtos (núcleo regulatorio + UI iterativa) | Compatibilidad con disponibilidad parcial del cliente | Trazabilidad documental normativa (REPS / Res. 3100) | Veredicto |
|---|---|---|---|---|---|
| **RUP** | Medio: exige alta ceremonia y múltiples roles especializados que sobrecargan a 4 personas. | Medio-Alto: orientado a arquitectura y casos de uso formales, pero pesado ante ajustes rápidos de UI. | Alto: trabaja por hitos de fase sin requerir cliente diario. | **Muy Alto:** produce artefactos de análisis y trazabilidad formal muy completos. | Descartada como marco único por peso documental excesivo para 4 devs. |
| **Scrum** | **Muy Alto:** diseñado para equipos multidisciplinarios de 3–9 integrantes con roles claros. | **Muy Alto:** gestiona un *Product Backlog* priorizado por valor (núcleo APH primero, soporte después) en Sprints cortos. | **Muy Alto:** concentra la interacción con el PO en *Sprint Planning* y *Sprint Review* semanales sin exigir presencia diaria. | Medio-Alto: requiere reforzar explícitamente la matriz de trazabilidad y documentación SRS/UML. | **Base seleccionada** (complementada con artefactos formales de análisis). |
| **XP (Extreme Programming)** | Alto: funciona bien en equipos pequeños. | Alto: excelente para código cambiante, pero débil en modelado previo de requisitos regulatorios. | **Bajo:** exige cliente en sitio (*On-Site Customer*) disponible de forma continua, condición inexistente aquí. | Bajo: prioriza código y pruebas sobre especificación documental previa. | Descartada por exigir disponibilidad continua del cliente. |
| **RAD (Rapid Application Development)** | Medio: requiere dividir en múltiples equipos paralelos para comprimir tiempos. | Medio: útil para prototipos rápidos de interfaz, pero riesgoso para lógica transaccional crítica de despacho TAB/TAM. | Bajo-Medio: depende de talleres intensivos continuos (JAD) con usuarios clave. | Bajo: sacrifica rigor estructural y control normativo por velocidad de prototipado. | Descartada por riesgo en integridad de negocio y necesidad de usuarios permanentes. |

### Selección y justificación
Se selecciona **Scrum con disciplina documental de análisis (híbrido Scrum + trazabilidad formal de requisitos)** (`Rubricas_G1.md` §7.7).

**Justificación basada en las características del caso:**
1. **Tamaño del equipo (4 integrantes):** Scrum encaja de forma natural sin crear burocracia de roles (como RUP), manteniendo coordinación diaria mediante *Daily* de 15 minutos y entregas incrementales por Sprint.
2. **Disponibilidad parcial del cliente/PO:** A diferencia de XP o RAD, Scrum canaliza la validación con el Product Owner en ceremonias acotadas al final de cada Sprint (*Sprint Review*), respetando su agenda semanal.
3. **Estabilidad mixta + exigencia normativa (Res. 3100/2017 y Ley 1581/2012):** Al combinar la ejecución iterativa de Scrum con artefactos formales de análisis antes de codificar (matriz RF→CU, plantillas extendidas, modelo de dominio y lista de chequeo), se evita que la agilidad sacrifique la trazabilidad auditada exigida en sistemas de salud.

---

## 3. Plan de actividades de análisis (Cronograma y entregables)

Plan estructurado para 2 Sprints iniciales de análisis (8 actividades priorizadas con MoSCoW, ≥ 6 exigidas por la rúbrica):

| ID | Actividad de análisis | Sprint / Prioridad | Responsable | Fecha | Entregable verificable |
|---|---|---|---|---|---|
| **ACT-01** | Revisar y depurar el SRS base de SIGMAVITAL (unificar disponibilidad al 97 %, corregir duplicados y delimitar exclusiones de alcance). | Sprint 1 · *Must* | `@darkid8` (Backend) | 2026-11-23 | `SRS_SIGMAVITAL_SGA.md` v1.1 depurado |
| **ACT-02** | Caracterizar la solución, comparar metodologías (RUP, Scrum, XP, RAD) y definir el plan de análisis. | Sprint 1 · *Must* | `@darkid8` | 2026-11-26 | `01-plan-analisis-sigmavital.md` |
| **ACT-03** | Clasificar los 65 RF frente a los 29 RNF y elaborar la matriz de cobertura requisito → caso de uso (≥ 90 % de cobertura). | Sprint 1 · *Must* | `@darkid8` | 2026-11-26 | `02-matriz-requisitos-casos-uso.md` |
| **ACT-04** | Elaborar el diagrama de casos de uso UML con frontera, actores primarios/secundarios y relaciones `«include»`/`«extend»` justificadas. | Sprint 1 · *Must* | `@darkid8` | 2026-11-26 | `03-diagrama-casos-uso.drawio` y `.svg` |
| **ACT-05** | Redactar las plantillas extendidas de los 3 casos de uso críticos (`CU-05`, `CU-06`, `CU-07`) y sus diagramas de actividades UML. | Sprint 2 · *Must* | `@darkid8` + PO (revisión) | 2026-11-26 al 2026-11-27 | `01-plantillas-casos-uso-extendidos.md` + 2 diagramas de actividades |
| **ACT-06** | Construir el modelo de dominio (clases abstractas sin métodos) y el modelo entidad-relación conceptual (Pata de Gallo). | Sprint 2 · *Must* | `@darkid8` | 2026-11-26 al 2026-11-27 | `04-modelo-dominio.*` y `05-mer-conceptual.*` |
| **ACT-07** | Elaborar prototipo inicial (mockups de 3 pantallas críticas rotuladas por caso de uso) para validar flujos con el PO. | Sprint 2 · *Should* | `@darkid8` (adaptado de Frontend) | 2026-11-27 | `06-prototipo-inicial.md` / pantallas rotuladas |
| **ACT-08** | Ejecutar lista de chequeo de ≥ 15 criterios sobre todos los artefactos, registrar ≥ 5 ajustes, verificar de nuevo y consolidar informe + matriz de trazabilidad. | Sprint 2 · *Must* | `@darkid8` | 2026-11-27 | Lista de chequeo, Registro de ajustes, Informe y Matriz Anexo C |
