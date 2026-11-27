# A5 · Vista de Componentes e Interfaces — SIGMAVITAL (SGA)

**Autor:** `@darkid8`  
**Diagramas:** [A5-componentes.drawio](./A5-componentes.drawio) · [A5-componentes.svg](./A5-componentes.svg)

---

## 1. Catálogo de componentes (6 componentes con interfaces provistas y requeridas)

Siguiendo `Rubricas_G2.md` (§2.1 A5), cada flecha de dependencia apunta **desde el componente que requiere la interfaz hacia el componente que la provee**, respetando la arquitectura en capas sin accesos directos desde la interfaz web a la base de datos:

| Componente | Interfaz que provee | Interfaz que requiere | Clases que agrupa | Requisitos que atiende |
|---|---|---|---|---|
| `CompWebOperativo` | `UI Web SPA React` | `IAuthRBAC`, `IDespacho`, `IFlotaHabilitacion`, `IMonitoreoWS` | Vistas cliente SPA (Login, Despacho, Flota, Atención APH) | `RF-018`, `RF-021`, `RF-028`, `RNF-017` |
| `CompAutenticacionRBAC` | `IAuthRBAC` | `IRepositorioDatos`, `IAuditoria` | `Usuario`, `Rol` | `RF-002`, `RF-005`, `RF-007`, `RNF-001`, `RNF-004` |
| `CompDespachoEmergencias` | `IDespacho` | `IFlotaHabilitacion`, `IMonitoreoWS`, `IAuditoria`, `IRepositorioDatos` | `SolicitudEmergencia`, `ServicioEmergencia`, `ServicioDespacho`, `ICriterioAsignacion`, `AsignacionCriticaTAM`, `AsignacionEstandarTAB`, `GeneradorReporteOperativo` | `RF-018`, `RF-021`, `RF-022`, `RF-023`, `RF-024`, `RNF-009` |
| `CompFlotaYPersonal` | `IFlotaHabilitacion` | `IRepositorioDatos`, `IAuditoria` | `Ambulancia`, `DocumentoHabilitacion`, `PersonalOperativo`, `Paramedico`, `Conductor` | `RF-008`, `RF-011`, `RF-014`, `RF-016` |
| `CompMonitoreoTiempoReal` | `IMonitoreoWS` | `IAuthRBAC`, `IFlotaHabilitacion` | `ISuscriptorEventoOperativo`, `MonitorTableroTiempoReal` | `RF-028`, `RNF-002` |
| `CompAuditoriaYPersistencia` | `IAuditoria`, `IRepositorioDatos` | Motor `PostgreSQL 16` | `RegistradorAuditoriaInmutable` y repositorios SQL | `RF-055`, `RNF-004`, `RNF-013` |
