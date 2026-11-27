# A7 · Matriz de Trazabilidad Bidireccional (Análisis → Diseño) — SIGMAVITAL (SGA)

**Autor:** `@darkid8`  
**Cobertura:** **14/14 RF seleccionados (100 %)** y **5/5 RNF seleccionados (100 %)**; verificación bidireccional con **0 clases huérfanas** y **0 tablas huérfanas**.

---

## 1. Trazabilidad hacia adelante: Requisitos (`RF` / `RNF`) → Diseño (`A2`, `B2`, `A5`, `A3/A4`)

| ID Requisito | Clase(s) en `A2` | Tabla(s) en `B2` | Componente(s) en `A5` | Patrón / Decisión (`A3` / `A4`) |
|---|---|---|---|---|
| `RF-002` | `Usuario` | `usuario` | `CompAutenticacionRBAC` | JWT con expiración + `bcrypt` (`RNF-001`) |
| `RF-005` | `Rol`, `Usuario` | `rol`, `usuario` | `CompAutenticacionRBAC` | Middleware RBAC en Capa 2 |
| `RF-007` | `Usuario` | `usuario`, `auditoria_evento` | `CompAutenticacionRBAC` | Bloqueo `intentos_fallidos` + alerta |
| `RF-008` | `Ambulancia` | `ambulancia`, `sede` | `CompFlotaYPersonal` | Diferenciación `TAB` / `TAM` |
| `RF-011` | `Ambulancia`, `DocumentoHabilitacion` | `documento_ambulancia`, `ambulancia` | `CompFlotaYPersonal` | Composición `Ambulancia ◆ Documento` |
| `RF-014` | `PersonalOperativo`, `Paramedico`, `Conductor` | `personal`, `usuario` | `CompFlotaYPersonal` | Herencia OO → discriminador `tipo_cargo` |
| `RF-016` | `PersonalOperativo` | `personal` | `CompFlotaYPersonal` | Validación `estaHabilitado()` previa al despacho |
| `RF-018` | `SolicitudEmergencia` | `paciente`, `telefono_paciente` | `CompDespachoEmergencias`, `CompWebOperativo` | Ley 1581/2012 + tabla multivaluada 1FN |
| `RF-021` | `SolicitudEmergencia` | `solicitud_emergencia` | `CompDespachoEmergencias`, `CompWebOperativo` | Prioridad clínica (`VERDE`..`ROJO`) |
| `RF-022` | `ServicioDespacho`, `ICriterioAsignacion`, `AsignacionCriticaTAM`, `AsignacionEstandarTAB` | `servicio`, `ambulancia`, `tripulacion_servicio` | `CompDespachoEmergencias` | **Patrón Strategy** + índices BD (`≤ 2 s`) |
| `RF-023` | `ServicioDespacho`, `ServicioEmergencia` | `servicio` (`asignacion_manual`, `motivo_asignacion_manual`) | `CompDespachoEmergencias` | Registro obligatorio motivo `RN-007` |
| `RF-024` | `ServicioEmergencia`, `GeneradorReporteOperativo` | `servicio`, `tripulacion_servicio` | `CompDespachoEmergencias` | Máquina de estados + validación cierre `RN-005` |
| `RF-028` | `ISuscriptorEventoOperativo`, `MonitorTableroTiempoReal` | `ambulancia`, `servicio` | `CompMonitoreoTiempoReal`, `CompWebOperativo` | **Patrón Observer** + Socket.IO `WSS` |
| `RF-055` | `ISuscriptorEventoOperativo`, `RegistradorAuditoriaInmutable` | `auditoria_evento` | `CompAuditoriaYPersistencia` | **Patrón Observer** + tabla *append-only* |
| `RNF-001` | `Usuario` (`passwordHash`) | `usuario` | `CompAutenticacionRBAC` | `bcrypt` con sal única |
| `RNF-002` | n/a (transporte) | n/a | `CompWebOperativo` ↔ Proxy Nginx | `HTTPS :443` / `WSS :443` TLS 1.3 |
| `RNF-004` | `Usuario`, `Rol` | `paciente`, `telefono_paciente` | `CompAutenticacionRBAC`, `CompAuditoriaYPersistencia` | RBAC Capa 2 + cifrado en reposo |
| `RNF-009` | `ServicioDespacho` | `ambulancia`, `servicio` | `CompDespachoEmergencias` | Caché flota + índice estado (`≤ 2 s`) |
| `RNF-013` | n/a (infraestructura) | Todas + respaldo offsite | Todos los contenedores Docker | Docker `restart` + *healthcheck* + `pg_dump` |

---

## 2. Verificación hacia atrás (0 clases huérfanas · 0 tablas huérfanas)

- **Clases en `A2` (17/17 cubiertas):** `Usuario` (`RF-002,005,007`), `Rol` (`RF-005`), `PersonalOperativo` (`RF-014,016`), `Paramedico` (`RF-014`), `Conductor` (`RF-014`), `Ambulancia` (`RF-008,011`), `DocumentoHabilitacion` (`RF-011`), `SolicitudEmergencia` (`RF-018,021`), `ServicioEmergencia` (`RF-023,024`), `GeneradorReporteOperativo` (`RF-024`), `ServicioDespacho` (`RF-022,023`), `ICriterioAsignacion` (`RF-022`), `AsignacionCriticaTAM` (`RF-022`), `AsignacionEstandarTAB` (`RF-022`), `ISuscriptorEventoOperativo` (`RF-028,055`), `MonitorTableroTiempoReal` (`RF-028`), `RegistradorAuditoriaInmutable` (`RF-055`).
- **Tablas en `B2` (12/12 cubiertas):** `rol`, `sede`, `usuario`, `personal`, `paciente`, `telefono_paciente`, `ambulancia`, `documento_ambulancia`, `solicitud_emergencia`, `servicio`, `tripulacion_servicio`, `auditoria_evento`. **Resultado: 100 % trazabilidad bidireccional.**
