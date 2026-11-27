# Matriz Requisito → Caso de Uso — SIGMAVITAL (SGA)

**Autor:** `@darkid8`  
**Fuente:** [SRS_SIGMAVITAL_SGA.md](../../../02-requirements/04-evidence-learning/SRS_SIGMAVITAL_SGA.md) (`RF-001` a `RF-065`, `RNF-001` a `RNF-029`)

---

## 1. Distinción entre Requisitos Funcionales (RF) y No Funcionales (RNF)

En el análisis UML, **solo los Requisitos Funcionales (`RF`) se modelan como Casos de Uso**, pues representan objetivos de negocio observables que un actor logra interactuando con el sistema.  
Por el contrario, los **Requisitos No Funcionales (`RNF-001` a `RNF-029`)** establecen restricciones de calidad, rendimiento, seguridad, disponibilidad, usabilidad y respaldo que **condicionan transversalmente** cómo deben ejecutarse dichos casos de uso (por ejemplo, `RNF-009` exige que `CU-06` responda en ≤ 2 s, y `RNF-001`/`RNF-002` condicionan a `CU-01`), pero **no generan casos de uso propios**.

---

## 2. Catálogo consolidado de Casos de Uso (12 base + 4 de relación)

Los casos se agrupan por **objetivo del actor** evitando fragmentar operaciones CRUD (`Rubricas_G1.md` §7.1):

| ID | Caso de uso (`Verbo + objeto`) | Actor(es) | Relación UML |
|---|---|---|---|
| `CU-01` | Autenticar y controlar sesión de usuario | Administrador, Coordinador Operativo, Paramédico, Vigilante; Sec: Servicio Correo SMTP | Base (usa SMTP en recuperación) |
| `CU-02` | Administrar cuentas de usuario y roles | Administrador | `«include»` → `CU-14` |
| `CU-03` | Gestionar flota de ambulancias TAB/TAM | Administrador, Coordinador Operativo | Base |
| `CU-04` | Gestionar personal operativo y disponibilidad | Administrador, Coordinador Operativo | Base |
| `CU-05` | Registrar solicitud de emergencia y paciente | Coordinador Operativo | Base |
| `CU-06` | Despachar ambulancia a servicio de emergencia | Coordinador Operativo | `«include»` → `CU-13`, `«include»` → `CU-14` |
| `CU-07` | Gestionar atención APH y cierre de servicio | Paramédico, Coordinador Operativo | `«include»` → `CU-14` |
| `CU-08` | Monitorear estado operativo en tiempo real | Coordinador Operativo, Administrador | Base |
| `CU-09` | Gestionar novedades e incidentes operativos | Coordinador Operativo, Paramédico, Administrador | Base |
| `CU-10` | Auditar operaciones y generar reportes KPI | Administrador, Coordinador Operativo | Base |
| `CU-11` | Gestionar trámites de soporte institucional | Administrador, Vigilante | Base |
| `CU-12` | Emitir alertas automáticas de vencimientos | Temporizador (Proceso Automático); Sec: Servicio Correo SMTP | Base automática |
| `CU-13` | Validar habilitación vigente de unidad y tripulación | *(Iniciado por `CU-06`)* | Incluido obligatoriamente por `CU-06` |
| `CU-14` | Registrar evento en auditoría | *(Iniciado por `CU-02`, `CU-06`, `CU-07`)* | Incluido obligatoriamente |
| `CU-15` | Asignar unidad manualmente con motivo | Coordinador Operativo *(extiende `CU-06`)* | `«extend»` → `CU-06` |
| `CU-16` | Reportar incidente en ruta | Paramédico *(extiende `CU-07`)* | `«extend»` → `CU-07` |

### Justificación en una línea de cada relación `«include»` y `«extend»`
- **`CU-06` `«include»` `CU-13`:** Todo despacho de ambulancia debe validar obligatoriamente que la unidad (SOAT, técnico-mecánica, REPS) y la tripulación estén habilitadas y vigentes (`RN-003`, `RN-004`).
- **`CU-02` / `CU-06` / `CU-07` `«include»` `CU-14`:** Toda creación/cambio de roles, despacho o cierre de servicio exige de manera obligatoria dejar registro inmutable en el log de auditoría (`RF-055`, `RN-010`).
- **`CU-15` `«extend»` `CU-06`:** Solo de forma condicional, cuando el Coordinador decide anular la sugerencia automática del algoritmo, el caso base se extiende en el punto *Selección de unidad* para exigir el motivo de asignación manual (`RF-023`, `RN-007`).
- **`CU-16` `«extend»` `CU-07`:** Solo cuando ocurre una falla mecánica, retraso o evento anómalo durante la atención o traslado en ruta, el caso base se extiende en el punto *Seguimiento en ruta* para registrar la novedad operativa (`RF-059`, `RN-006`).

---

## 3. Matriz de cobertura `RF-001` a `RF-065`

**Resumen de cobertura:** **60 de 65 RF cubiertos (92,31 %)** — supera el mínimo exigido del 90 %. Los **5 RF no cubiertos (`RF-031` a `RF-035`, 7,69 %)** se excluyen justificadamente según la sección 1.6 del SRS (fuera del alcance de facturación/EPS en la fase prehospitalaria).

| ID RF | Descripción resumida del SRS | Estado | Caso de uso asignado / Justificación de exclusión |
|---|---|---|---|
| `RF-001` | CRUD lógico de usuarios y roles con auditoría | Cubierto | `CU-02` (y `CU-14`) |
| `RF-002` | Autenticación con correo, contraseña y JWT | Cubierto | `CU-01` |
| `RF-003` | Cierre automático por 15 min de inactividad y aviso | Cubierto | `CU-01` |
| `RF-004` | Recuperación de contraseña vía enlace SMTP (30 min) | Cubierto | `CU-01` |
| `RF-005` | Control de acceso basado en roles (RBAC) | Cubierto | `CU-01` |
| `RF-006` | Asignación y modificación de roles con auditoría | Cubierto | `CU-02` (y `CU-14`) |
| `RF-007` | Registro de intentos fallidos y bloqueo 30 min (5 intentos) | Cubierto | `CU-01` |
| `RF-008` | Registro completo de ambulancias TAB/TAM y REPS | Cubierto | `CU-03` |
| `RF-009` | Actualización de estado operativo en tiempo real | Cubierto | `CU-03` / `CU-08` |
| `RF-010` | Consulta filtrada de inventario de ambulancias | Cubierto | `CU-03` |
| `RF-011` | Control de documentación obligatoria y bloqueo por vencimiento | Cubierto | `CU-03` / `CU-12` / `CU-13` |
| `RF-012` | Historial de mantenimientos preventivos y correctivos | Cubierto | `CU-03` |
| `RF-013` | Inventario de equipos médicos TAB/TAM (Res. 3100/2017) | Cubierto | `CU-03` |
| `RF-014` | Registro de personal médico y operativo con certificaciones | Cubierto | `CU-04` |
| `RF-015` | Control de disponibilidad del personal en tiempo real | Cubierto | `CU-04` |
| `RF-016` | Vencimiento de certificaciones del personal y bloqueo | Cubierto | `CU-04` / `CU-12` / `CU-13` |
| `RF-017` | Historial de servicios y control de jornadas laborales | Cubierto | `CU-04` |
| `RF-018` | Registro de pacientes bajo confidencialidad RBAC | Cubierto | `CU-05` |
| `RF-019` | Registro del estado clínico inicial del paciente | Cubierto | `CU-05` |
| `RF-020` | Consulta de historial de servicios por paciente | Cubierto | `CU-05` |
| `RF-021` | Registro de solicitud de emergencia con prioridad clínica | Cubierto | `CU-05` |
| `RF-022` | Asignación automática de ambulancia en ≤ 2 s | Cubierto | `CU-06` (incluye `CU-13`, `CU-14`) |
| `RF-023` | Asignación manual con motivo obligatorio | Cubierto | `CU-15` (extiende `CU-06`) |
| `RF-024` | Máquina de estados completa del servicio | Cubierto | `CU-07` |
| `RF-025` | Cierre formal con campos obligatorios | Cubierto | `CU-07` (incluye `CU-14`) |
| `RF-026` | Cancelación justificada solo en Solicitado/Asignado | Cubierto | `CU-06` |
| `RF-027` | Consulta de historial de servicios con exportación PDF/Excel | Cubierto | `CU-07` / `CU-10` |
| `RF-028` | Panel centralizado en tiempo real diferenciando TAB y TAM | Cubierto | `CU-08` |
| `RF-029` | KPI y alertas críticas en panel principal | Cubierto | `CU-08` |
| `RF-030` | Registro básico de ingresos y egresos operativos | Cubierto | `CU-11` |
| `RF-031` | Generación automática de facturas inmutables y notas contables | **Excluido** | Fuera de alcance en fase 1 según SRS §1.6 (sin facturación electrónica/EPS). |
| `RF-032` | Cartera, cálculo de mora y bloqueo de deudores | **Excluido** | Fuera de alcance en fase 1 según SRS §1.6 (procesos financieros/EPS excluidos). |
| `RF-033` | Reportes financieros periódicos y alertas de mora | **Excluido** | Fuera de alcance en fase 1 según SRS §1.6 (facturación/cartera externa). |
| `RF-034` | Recibos de pago en PDF e historial financiero | **Excluido** | Fuera de alcance en fase 1 según SRS §1.6 (recaudo y facturación externa). |
| `RF-035` | Consulta de estado de cuenta de cartera | **Excluido** | Fuera de alcance en fase 1 según SRS §1.6 (portal financiero de terceros). |
| `RF-036` | Registro de ingreso/salida de visitantes | Cubierto | `CU-11` |
| `RF-037` | Verificación de identidad, alertas y vehículo de visitante | Cubierto | `CU-11` |
| `RF-038` | Pre-autorizaciones de acceso de visitantes | Cubierto | `CU-11` |
| `RF-039` | Historial y estadísticas de visitas | Cubierto | `CU-11` |
| `RF-040` | Radicación y clasificación automática de PQRS | Cubierto | `CU-11` |
| `RF-041` | Asignación de PQRS en ≤ 24 h o escalamiento | Cubierto | `CU-11` / `CU-12` |
| `RF-042` | Consulta pública de PQRS por radicado y notificaciones | Cubierto | `CU-11` |
| `RF-043` | Respuesta formal de PQRS, alertas y cierre | Cubierto | `CU-11` |
| `RF-044` | Historial inalterable de PQRS y exportación | Cubierto | `CU-11` |
| `RF-045` | Registro de propietarios y vinculación contractual de unidades | Cubierto | `CU-03` |
| `RF-046` | Control operativo/contractual de unidades con historial | Cubierto | `CU-03` |
| `RF-047` | Registro de proveedores y contratos con alertas 30/15/5 días | Cubierto | `CU-11` / `CU-12` |
| `RF-048` | Bloqueo de contratos vencidos e historial | Cubierto | `CU-11` |
| `RF-049` | Evaluación de desempeño de proveedores y reportes | Cubierto | `CU-11` |
| `RF-050` | Carga de documentos con MIME, tamaño y confidencialidad | Cubierto | `CU-11` |
| `RF-051` | Versionamiento automático, bloqueo oficial y control hash | Cubierto | `CU-11` |
| `RF-052` | Búsqueda avanzada, visor integrado y descarga auditada | Cubierto | `CU-11` |
| `RF-053` | RBAC documental, auditoría y notificaciones | Cubierto | `CU-11` |
| `RF-054` | Carpetas jerárquicas documentales y exportación | Cubierto | `CU-11` |
| `RF-055` | Registro automático de eventos CRUD, auth y cambios de rol | Cubierto | `CU-10` / `CU-14` |
| `RF-056` | Inmutabilidad técnica de auditoría y retención ≥ 5 años | Cubierto | `CU-10` / `CU-14` |
| `RF-057` | Consulta filtrada de auditoría y exportación PDF/Excel | Cubierto | `CU-10` |
| `RF-058` | Detección y alerta de eventos críticos de seguridad | Cubierto | `CU-10` |
| `RF-059` | Registro de novedades operativas por tipo y prioridad | Cubierto | `CU-09` / `CU-16` |
| `RF-060` | Ciclo de vida y responsables de novedades | Cubierto | `CU-09` |
| `RF-061` | Alertas por vencimiento de resolución de novedades | Cubierto | `CU-09` |
| `RF-062` | Evidencia multimedia, comentarios y filtros de novedades | Cubierto | `CU-09` |
| `RF-063` | Reportes e indicadores de tiempo de resolución de novedades | Cubierto | `CU-09` / `CU-10` |
| `RF-064` | Reportes operativos personalizados y programados PDF/Excel | Cubierto | `CU-10` |
| `RF-065` | Indicadores KPI (tiempo respuesta, TAB/TAM, cancelación) | Cubierto | `CU-10` |
