# Modelo de Dominio Conceptual (v2 Verificada) — SIGMAVITAL (SGA)

**Autor:** `@darkid8`  
**Versión:** 2.0 (Día 2 — 2026-11-27 · Corregido hallazgo `H-03`: eliminado atributo técnico `idSede` en `Ambulancia` y fijada multiplicidad `1` a `0..*` hacia `NovedadOperativa`)  
**Diagramas:** [04-modelo-dominio.drawio](./04-modelo-dominio.drawio) · [04-modelo-dominio.svg](./04-modelo-dominio.svg)

---

## 1. Clases conceptuales identificadas (11 clases puras de negocio, sin métodos ni claves técnicas)

| # | Clase conceptual | Atributos de negocio | Rol en el dominio |
|---|---|---|---|
| 1 | `Paciente` | `documento`, `nombreCompleto`, `antecedentesClinicos` | Persona objeto de atención prehospitalaria |
| 2 | `SolicitudEmergencia` | `codigoSolicitud`, `fechaHora`, `direccionEvento`, `prioridadClinica` | Evento de urgencia reportado |
| 3 | `ServicioAtencion` | `estadoServicio`, `horaAsignacion`, `resultadoAtencion`, `destinoTraslado` | Atención prehospitalaria ejecutada |
| 4 | `Ambulancia` | `numeroUnidad`, `placa`, `tipoUnidad`, `estadoOperativo` | Unidad móvil TAB o TAM |
| 5 | `DocumentoHabilitacion` | `tipoDocumento`, `numeroRegistro`, `fechaVencimiento` | Soporte legal REPS, SOAT y técnico-mecánica |
| 6 | `SedeOperativa` | `nombreSede`, `ciudad`, `direccion` | Base física donde operan las unidades |
| 7 | `PersonalOperativo` | `documento`, `nombreCompleto`, `estadoDisponibilidad` | Superclase del talento humano en campo |
| 8 | `Paramedico` | `registroProfesional`, `nivelSoporte` | Especialización clínica TAB/TAM |
| 9 | `Conductor` | `licenciaConduccion`, `categoria` | Especialización de conducción de emergencia |
| 10 | `AsignacionTripulacion` | `rolEnTurno`, `horaAsignacion` | Clase de asociación entre `ServicioAtencion` y `PersonalOperativo` |
| 11 | `NovedadOperativa` | `tipoNovedad`, `prioridad`, `estadoSeguimiento` | Incidente o falla reportada durante la operación |

## 2. Generalización, clase de asociación y multiplicidades clave
- **Generalización:** `Paramedico` y `Conductor` heredan de `PersonalOperativo`.
- **Clase de asociación:** `AsignacionTripulacion` modela la relación N:M entre `ServicioAtencion` (`0..*`) y `PersonalOperativo` (`1..*`).
- **Asociaciones clave:** `SedeOperativa (1)` aloja `Ambulancia (0..*)`; `ServicioAtencion (1)` registra `NovedadOperativa (0..*)`; `Ambulancia (1)` respaldada por `DocumentoHabilitacion (1..*)`.
