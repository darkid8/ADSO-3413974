# Modelo de Dominio Conceptual (v1) — SIGMAVITAL (SGA)

**Autor:** `@darkid8`  
**Diagramas:** [04-modelo-dominio.drawio](./04-modelo-dominio.drawio) · [04-modelo-dominio.svg](./04-modelo-dominio.svg)

---

## 1. Clases conceptuales identificadas (11 clases, sin métodos)

El modelo representa los conceptos puros del negocio prehospitalario abstraídos del SRS y de las plantillas extendidas, sin operaciones técnicas ni métodos (`Rubricas_G1.md` §5.1 c):

| # | Clase conceptual | Atributos de negocio | Rol en el dominio |
|---|---|---|---|
| 1 | `Paciente` | `documento`, `nombreCompleto`, `antecedentesClinicos` | Persona objeto de atención prehospitalaria |
| 2 | `SolicitudEmergencia` | `codigoSolicitud`, `fechaHora`, `direccionEvento`, `prioridadClinica` | Evento de urgencia reportado |
| 3 | `ServicioAtencion` | `estadoServicio`, `horaAsignacion`, `resultadoAtencion`, `destinoTraslado` | Atención prehospitalaria ejecutada |
| 4 | `Ambulancia` | `numeroUnidad`, `placa`, `tipoUnidad`, `estadoOperativo` *(Nota v1: incluye `idSede` temporal a depurar tras lista de chequeo)* | Unidad móvil TAB o TAM |
| 5 | `DocumentoHabilitacion` | `tipoDocumento`, `numeroRegistro`, `fechaVencimiento` | Soporte legal REPS, SOAT y técnico-mecánica |
| 6 | `SedeOperativa` | `nombreSede`, `ciudad`, `direccion` | Base física donde operan las unidades |
| 7 | `PersonalOperativo` | `documento`, `nombreCompleto`, `estadoDisponibilidad` | Superclase del talento humano en campo |
| 8 | `Paramedico` | `registroProfesional`, `nivelSoporte` | Especialización clínica TAB/TAM |
| 9 | `Conductor` | `licenciaConduccion`, `categoria` | Especialización de conducción de emergencia |
| 10 | `AsignacionTripulacion` | `rolEnTurno`, `horaAsignacion` | Clase de asociación entre `ServicioAtencion` y `PersonalOperativo` |
| 11 | `NovedadOperativa` | `tipoNovedad`, `prioridad`, `estadoSeguimiento` | Incidente o falla reportada durante la operación |

## 2. Generalización y clase de asociación
- **Generalización:** `Paramedico` y `Conductor` heredan de la clase conceptual `PersonalOperativo`.
- **Clase de asociación:** `AsignacionTripulacion` modela los atributos propios de la vinculación N:M entre un `ServicioAtencion` y el `PersonalOperativo` asignado en ese turno.
