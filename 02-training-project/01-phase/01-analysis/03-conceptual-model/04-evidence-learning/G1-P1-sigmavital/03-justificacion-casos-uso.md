# Justificación de Actores, Alcance y Relaciones UML — SIGMAVITAL (SGA)

**Autor:** `@darkid8`  
**Diagrama asociado:** [03-diagrama-casos-uso.drawio](./03-diagrama-casos-uso.drawio) · [03-diagrama-casos-uso.svg](./03-diagrama-casos-uso.svg)

---

## 1. Actores del sistema (5 primarios + 1 secundario)

Siguiendo `Rubricas_G1.md` (§7.6), todo caso de uso tiene un iniciador claro, y los sistemas externos que solo reciben información actúan como **actores secundarios** fuera de la frontera del sistema:

| Actor | Tipo | Iniciador de casos | Responsabilidad en el diagrama |
|---|---|---|---|
| `Administrador` | Primario | `CU-01`, `CU-02`, `CU-03`, `CU-04`, `CU-10`, `CU-11` | Configura usuarios/roles, flota TAB/TAM, personal, auditoría y soporte institucional. |
| `Coordinador Operativo` | Primario | `CU-01`, `CU-05`, `CU-06`, `CU-08`, `CU-09`, `CU-10` | Registra emergencias, ejecuta o ajusta despachos, supervisa el tablero en tiempo real y gestiona novedades. |
| `Paramédico` | Primario | `CU-01`, `CU-07`, `CU-09` | Actualiza estados de atención prehospitalaria (`En ruta` → `Finalizado`), cierra servicios y reporta incidentes en ruta. |
| `Vigilante` | Primario | `CU-01`, `CU-11` | Registra ingresos/egresos de visitantes en sede (`RF-036`, `RF-037`). |
| `Temporizador (Proceso Automático)` | Primario temporal | `CU-12` | Dispara periódicamente la verificación de vencimientos (SOAT, técnico-mecánica, REPS, certificados, contratos). |
| `Servicio Correo SMTP` | Secundario (`«sistema externo»`) | *(No inicia)* | Recibe solicitudes de envío de correo desde `CU-01` (recuperación de clave) y `CU-12` (alertas automáticas). |

---

## 2. Criterio sobre operaciones CRUD (`Rubricas_G1.md` §7.1)

Ningún caso de uso se fragmentó en operaciones técnicas aisladas («Crear ambulancia», «Consultar ambulancia», «Actualizar ambulancia»). Cada caso representa un **objetivo completo de negocio con valor para el actor** (por ejemplo, `CU-03 Gestionar flota de ambulancias TAB/TAM`, `CU-04 Gestionar personal operativo y disponibilidad`).

---

## 3. Justificación de relaciones `«include»` y `«extend»` (`Rubricas_G1.md` §7.2)

| Relación | Caso origen (flecha sale) | Caso destino (flecha llega) | Punto de extensión | Justificación en una línea |
|---|---|---|---|---|
| `«include»` | `CU-06 Despachar ambulancia` | `CU-13 Validar habilitación vigente` | n/a (obligatorio) | Todo despacho exige obligatoriamente verificar SOAT, técnico-mecánica, REPS y certificaciones vigentes antes de asignar (`RN-003`, `RN-004`). |
| `«include»` | `CU-02 Administrar cuentas y roles` | `CU-14 Registrar evento en auditoría` | n/a (obligatorio) | Todo cambio de usuarios o privilegios de rol debe quedar registrado de forma obligatoria en la auditoría inmutable (`RF-006`, `RF-055`). |
| `«include»` | `CU-06 Despachar ambulancia` | `CU-14 Registrar evento en auditoría` | n/a (obligatorio) | Toda asignación automática, manual o cancelación de despacho debe generar traza obligatoria en el log de auditoría (`RF-026`, `RF-055`). |
| `«include»` | `CU-07 Gestionar atención APH` | `CU-14 Registrar evento en auditoría` | n/a (obligatorio) | Toda transición de estado y cierre formal de servicio prehospitalario debe auditarse obligatoriamente (`RF-024`, `RF-055`). |
| `«extend»` | `CU-15 Asignar unidad manualmente` | `CU-06 Despachar ambulancia` | `PE-01: Sugerencia descartada` | Solo de forma condicional, cuando el Coordinador decide no aceptar la ambulancia sugerida, se extiende el despacho para exigir motivo obligatorio (`RN-007`). |
| `«extend»` | `CU-16 Reportar incidente en ruta` | `CU-07 Gestionar atención APH` | `PE-02: Contingencia en ruta` | Solo cuando ocurre una falla mecánica, retraso o incidente durante el desplazamiento, se extiende la atención para registrar la novedad operativa (`RF-059`, `RN-006`). |
