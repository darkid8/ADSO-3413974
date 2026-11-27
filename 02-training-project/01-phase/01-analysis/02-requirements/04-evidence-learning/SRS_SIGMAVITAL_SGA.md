# Especificación de Requisitos de Software (SRS) — SIGMAVITAL (SGA)

**Sistema:** SIGMAVITAL — Sistema de Gestión Integral de Movilidad Asistencial, Vigilancia Integral y Traslado de Atención Logística (SGA)  
**Estándar de referencia:** IEEE Std 830-1998  
**Equipo de proyecto (roles anonimizados por política de repositorio público):**  
- `@darkid8` — Desarrollador Backend  
- Integrante 2 — Scrum Master  
- Integrante 3 — Desarrollador Frontend  
- Integrante 4 — Desarrollador Fullstack  
- Instructor / Product Owner — Líder de validación académica  

**Fecha base:** 18 de febrero de 2026  
**Versión ajustada para G1/G2:** 1.1 (2026-11-26 — normalización de `RST-09`, unificación de disponibilidad operativa al `97 %` coherente con `RNF-013`, y anonimización de datos personales).

---

## 1. Introducción

### 1.1 Planteamiento del problema
En las instituciones médicas dedicadas a la atención prehospitalaria (APH), la gestión operativa de ambulancias y el control de los servicios de emergencia presentan deficiencias estructurales significativas cuando se realizan de forma manual o mediante herramientas fragmentadas: tiempos de respuesta prolongados, desorganización de recursos, dificultad para diferenciar unidades de **Transporte Asistencial Básico (TAB)** y **Transporte Asistencial Medicalizado (TAM)**, ausencia de información en tiempo real y falta de trazabilidad operativa.

**Pregunta problema:** ¿Cómo diseñar e implementar un sistema de software integrado para la gestión y asignación de ambulancias que permita optimizar los tiempos de respuesta, mejorar la organización operativa, diferenciar la gestión de unidades TAB y TAM, y garantizar información en tiempo real en las instituciones médicas de atención prehospitalaria?

### 1.2 Propósito
Describir de manera detallada los requerimientos funcionales, no funcionales, reglas de negocio y restricciones del Sistema de Gestión de Ambulancias (SGA) SIGMAVITAL, estableciendo una base verificable para las fases de análisis, diseño, desarrollo y pruebas.

### 1.3 Justificación
Según el DANE (2023), el 74,7 % de la población colombiana se encuentra afiliada al sistema de salud, pero persisten retos en oportunidad de atención de urgencias y traslado asistencial. El Registro Especial de Prestadores de Servicios de Salud (REPS) y la **Resolución 3100 de 2017** (complementada por la Resolución 544 de 2023) diferencian los requisitos de habilitación para **TAB** y **TAM**, fundamentando la automatización, trazabilidad y control documental que aporta SIGMAVITAL.

### 1.4 Objetivo general
Diseñar y desarrollar un Sistema de Gestión de Ambulancias (SGA) que automatice, integre y optimice los procesos de registro, asignación, monitoreo y control de las unidades de emergencia en instituciones de atención prehospitalaria, diferenciando unidades TAB y TAM en tiempo real y en alineación con el REPS y la Resolución 3100 de 2017.

### 1.5 Objetivos específicos
1. Analizar y definir requisitos funcionales y no funcionales mediante técnicas de elicitación y revisión normativa (REPS, Resolución 3100 de 2017).
2. Diseñar la arquitectura modular escalable y el modelo de base de datos relacional.
3. Desarrollar autenticación y control de acceso basado en roles (RBAC).
4. Implementar gestión integral de ambulancias (TAB/TAM), personal médico, pacientes y solicitudes de emergencia.
5. Programar un módulo de asignación automática de ambulancias por disponibilidad, tipo requerido, proximidad y prioridad clínica.
6. Integrar monitoreo en tiempo real del estado operativo de unidades y servicios.
7. Implementar generación de reportes e indicadores KPI desagregados por TAB/TAM.
8. Ejecutar pruebas funcionales, de usabilidad y rendimiento.

### 1.6 Alcance del sistema
**Incluye:** automatización de flujos de recepción, asignación, seguimiento y cierre de servicios prehospitalarios; gestión de ambulancias TAB/TAM, personal, pacientes y emergencias; monitoreo en tiempo real; seguridad RBAC; reportes PDF/Excel; módulos complementarios documentados en el SRS grupal (auditoría, novedades, soporte documental, PQRS, visitantes, proveedores y financiero).

**Exclusiones declaradas:**
1. Sin integración directa con sistemas hospitalarios externos o historia clínica externa de terceros en esta fase.
2. Sin gestión completa de historia clínica electrónica (solo registro clínico prehospitalario básico del traslado).
3. Sin rastreo GPS satelital en tiempo real integrado por hardware en esta fase.
4. Sin integración con plataformas de aseguradoras/EPS ni pasarelas de facturación electrónica externa.
5. Sin aplicaciones móviles nativas (solución web responsiva).

### 1.7 Personal involucrado y roles del sistema

| Rol en el proyecto | Categoría | Responsabilidad |
|---|---|---|
| Product Owner (Instructor) | Líder de validación | Define prioridades y valida cumplimiento de necesidades |
| Scrum Master | Tecnólogo en ADS | Coordina reuniones, seguimiento y tiempos |
| Desarrollador Backend (`@darkid8`) | Tecnólogo en ADS | Lógica de negocio, API, seguridad y base de datos |
| Desarrollador Frontend | Tecnólogo en ADS | Interfaz gráfica responsiva y experiencia de usuario |
| Desarrollador Fullstack | Tecnólogo en ADS | Integración transversal frontend-backend |

**Perfiles de usuario del sistema:**
- **Administrador:** configuración global, usuarios, roles, auditoría y supervisión de plataforma.
- **Coordinador Operativo:** gestión de solicitudes de emergencia, asignación TAB/TAM y monitoreo en tiempo real.
- **Paramédico (TAB / TAM):** recepción de servicios asignados, atención prehospitalaria, actualización de estados y cierre clínico básico.
- **Conductor:** apoyo en traslado y confirmación operativa en ruta.
- **Vigilante / Analista Directivo:** registro de acceso de visitantes (vigilante) y consulta de KPI/reportes (analista).

### 1.8 Definiciones, acrónimos y abreviaturas
- **SGA:** Sistema de Gestión de Ambulancias.
- **APH:** Atención Prehospitalaria.
- **TAB / TAM:** Transporte Asistencial Básico / Transporte Asistencial Medicalizado.
- **REPS:** Registro Especial de Prestadores de Servicios de Salud.
- **RBAC:** Control de Acceso Basado en Roles.
- **JWT / HTTPS / REST / SQL / JSON / UML:** Estándares web, de seguridad, datos y modelado.

---

## 2. Descripción general y restricciones

### 2.1 Perspectiva del producto
Aplicación web multiusuario bajo arquitectura cliente-servidor por capas (Frontend SPA, Backend API REST + WebSockets, Base de Datos Relacional, Capa de Seguridad RBAC, Motor de Reportes y Capa de Integración futura).

### 2.2 Restricciones del sistema (`RST-01` a `RST-10`)
*(Nota de ajuste v1.1: se corrige la numeración duplicada de `RST-07` en el borrador original renumerando el control de acceso como `RST-09`, y se unifica `RST-04` al `97 %` de disponibilidad conforme a `RNF-013`).*

| ID | Tipo | Descripción |
|---|---|---|
| `RST-01` | Normativa legal | Cumplimiento estricto de Resolución 3100 de 2017 y Resolución 544 de 2023. |
| `RST-02` | Seguridad de información | Tratamiento de datos sensibles conforme a Ley 1581 de 2012 y lineamientos REPS. |
| `RST-03` | Entorno de ejecución | Accesible en navegadores modernos (Chrome, Firefox, Edge) sin instalación local. |
| `RST-04` | Disponibilidad operativa | Operación 24/7 con disponibilidad mínima unificada del **97 %** (ajustado desde 77 % del borrador inicial). |
| `RST-05` | Limitaciones de alcance | Sin GPS satelital en vivo, historia clínica completa ni interoperabilidad hospitalaria externa en v1. |
| `RST-06` | Restricción tecnológica | Arquitectura modular y desacoplada para mantenimiento independiente. |
| `RST-07` | Restricción de datos | Log de auditoría inalterable conservado por mínimo 5 años (estándar REPS). |
| `RST-08` | Rendimiento operativo | Respuestas óptimas bajo concurrencia en asignación y monitoreo en tiempo real. |
| `RST-09` | Seguridad de acceso | Autenticación segura y autorización RBAC estricta por perfil (antes rotulado erróneamente como `RST-07`). |
| `RST-10` | Infraestructura tecnológica | Eficiencia de recursos para operar en infraestructura moderada y conectividad variable. |

---

## 3. Requisitos de interfaces (resumen técnico)
- **Interfaces de usuario:** Login, Panel de Control en tiempo real (TAB verde / TAM rojo, prioridades P1 rojo / P2 amarillo / P3 verde), Gestión de Ambulancias, Gestión de Personal, Solicitudes de Emergencia, Asignación, Reportes, Monitoreo en Tiempo Real, Auditoría y Gestión de Novedades; operación crítica en ≤ 4 pasos (`1280×768` escritorio / `768×1024` tableta).
- **Interfaces de software (stack unificado):** Ubuntu Server 22.04 LTS, Nginx (HTTPS/TLS Let's Encrypt), Node.js + Express (API REST + Socket.IO), React.js, PostgreSQL, bcrypt/Argon2 para hash de contraseñas, JWT, PDFKit/jsPDF + ExcelJS, Docker.
- **Interfaces de comunicación:** HTTPS puerto `443`, API REST JSON, WebSockets (`WSS 443`), SMTP TLS para notificaciones (`RF-004`, `RF-011`, `RF-016`) y TCP `5432` hacia PostgreSQL en red interna.

---

## 4. Requisitos funcionales del SGA (`RF-001` a `RF-065`)

| ID | Descripción | Prioridad | Actor | Módulo |
|---|---|---|---|---|
| `RF-001` | Registrar, editar, activar, desactivar y eliminar lógicamente usuarios validando correo único, contraseña compleja y rol, con trazabilidad en auditoría. | Alta | Administrador | Autenticación |
| `RF-002` | Autenticar usuarios mediante correo y contraseña generando token JWT con expiración configurable (máx. 8 h) y control por rol. | Alta | Todos | Autenticación |
| `RF-003` | Cerrar sesión automáticamente tras 15 minutos de inactividad y advertir antes de expiración de token para preservar datos no guardados. | Alta | Sistema | Autenticación |
| `RF-004` | Permitir recuperación de contraseña mediante enlace seguro enviado al correo con vigencia máxima de 30 minutos. | Alta | Usuario | Autenticación |
| `RF-005` | Implementar control de acceso basado en roles (RBAC) restringiendo módulos, formularios, reportes y acciones según perfil. | Alta | Sistema | Autenticación |
| `RF-006` | Permitir asignar y modificar roles de usuario registrando cada cambio de privilegios en auditoría. | Alta | Administrador | Autenticación |
| `RF-007` | Registrar intentos fallidos de inicio de sesión y bloquear la cuenta 30 minutos al superar 5 intentos consecutivos, alertando al administrador. | Alta | Sistema | Autenticación |
| `RF-008` | Registrar ambulancias con número de unidad, placa, tipo (`TAB` o `TAM`), marca, modelo, año, habilitación REPS y documentos. | Alta | Administrador | Ambulancias |
| `RF-009` | Actualizar estado operativo de cada ambulancia (`Disponible`, `En servicio`, `En mantenimiento`, `Fuera de servicio`) en tiempo real vía WebSockets. | Alta | Coordinador / Sistema | Ambulancias |
| `RF-010` | Consultar inventario de ambulancias con filtros por tipo, estado, sede y disponibilidad. | Alta | Coordinador / Administrador | Ambulancias |
| `RF-011` | Controlar documentación obligatoria (SOAT, técnico-mecánica, REPS), alertar vencimientos e impedir asignación con documentos vencidos. | Alta | Administrador / Sistema | Ambulancias |
| `RF-012` | Registrar historial de mantenimientos preventivos y correctivos con fecha, tipo, proveedor, costo y estado. | Alta | Administrador | Ambulancias |
| `RF-013` | Gestionar inventario de equipos y dotación médica de cada ambulancia diferenciando requisitos TAB y TAM (Res. 3100/2017). | Alta | Administrador | Ambulancias |
| `RF-014` | Registrar personal médico y operativo (paramédicos, conductores, auxiliares) con formación, tarjeta profesional, certificaciones y unidad. | Alta | Administrador | Personal |
| `RF-015` | Controlar disponibilidad del personal en tiempo real (`Disponible`, `En servicio`, `En descanso`, `Incapacitado`) en el panel de asignación. | Alta | Coordinador | Personal |
| `RF-016` | Registrar vencimientos de certificaciones del personal, alertar anticipadamente e impedir asignación si expiró documentación crítica. | Alta | Sistema | Personal |
| `RF-017` | Consultar historial de servicios por miembro del personal y controlar jornadas laborales generando alertas por exceso de horas continuas. | Media | Administrador / Coordinador | Personal |
| `RF-018` | Registrar pacientes atendidos (identificación, fecha nacimiento, contacto familiar, antecedentes) bajo confidencialidad RBAC. | Alta | Paramédico / Coordinador | Pacientes |
| `RF-019` | Registrar estado clínico inicial del paciente (`estable`, `crítico`, `fallecido`) vinculado al servicio de emergencia. | Alta | Paramédico | Pacientes |
| `RF-020` | Consultar historial de servicios asociados a un paciente con filtros por fecha, tipo y unidad. | Alta | Paramédico / Administrador | Pacientes |
| `RF-021` | Registrar solicitudes de emergencia con hora, dirección/coordenadas, tipo, prioridad clínica (`verde`, `amarillo`, `naranja`, `rojo`) y solicitante. | Alta | Coordinador / Operador | Emergencias |
| `RF-022` | Ejecutar asignación automática de ambulancia por disponibilidad, tipo TAB/TAM, prioridad y proximidad en ≤ 2 segundos. | Alta | Sistema | Emergencias |
| `RF-023` | Permitir asignación manual de ambulancia por el coordinador superando la sugerencia automática con registro obligatorio de motivo. | Alta | Coordinador | Emergencias |
| `RF-024` | Gestionar ciclo de vida del servicio (`Solicitado`, `Asignado`, `En ruta`, `En atención`, `Traslado`, `Finalizado`, `Cancelado`) con marcas de tiempo. | Alta | Coordinador / Sistema | Emergencias |
| `RF-025` | Permitir el cierre formal del servicio solo si están completos resultado, estado del paciente, destino de traslado y responsable. | Alta | Paramédico / Coordinador | Emergencias |
| `RF-026` | Permitir cancelación de servicio con justificación obligatoria en auditoría únicamente en estados `Solicitado` o `Asignado`. | Media | Coordinador | Emergencias |
| `RF-027` | Consultar historial completo de servicios con filtros combinados y exportación a PDF y Excel. | Alta | Administrador / Coordinador | Emergencias |
| `RF-028` | Proveer panel centralizado en tiempo real vía WebSockets diferenciando visualmente unidades TAB y TAM. | Alta | Coordinador / Administrador | Monitoreo |
| `RF-029` | Mostrar KPI y alertas críticas en el panel (servicios activos, unidades disponibles, sin tripulación, vencimientos, solicitudes sin asignar). | Alta | Coordinador / Administrador | Monitoreo |
| `RF-030` | Registrar ingresos y egresos operativos con soporte documental y validación de proveedor registrado. | Alta | Administrador | Financiero |
| `RF-031` | Generar facturas automáticas inmutables al cierre del servicio con notas crédito/débito para correcciones. | Alta | Sistema | Financiero |
| `RF-032` | Gestionar cartera, cálculo de mora desde día 1 y bloqueo por mora > 30 días. | Alta | Administrador | Financiero |
| `RF-033` | Generar reportes financieros periódicos y alertas de vencimiento/mora con ≥ 3 días de anticipación. | Alta | Administrador | Financiero |
| `RF-034` | Generar recibos de pago en PDF e historial financiero inalterable. | Media | Sistema | Financiero |
| `RF-035` | Consultar estado de cuenta por usuarios o entidades autorizadas. | Media | Usuario / Administrador | Financiero |
| `RF-036` | Registrar ingreso y salida de visitantes con pre-autorización vigente o registro manual justificado por vigilante. | Alta | Vigilante | Visitantes |
| `RF-037` | Verificar identidad de visitante, foto opcional, alertas de documento bloqueado o exceso de permanencia y registro de vehículo. | Alta | Vigilante / Sistema | Visitantes |
| `RF-038` | Registrar pre-autorizaciones de acceso para visitantes esperados con rango horario y motivo. | Media | Usuario Interno | Visitantes |
| `RF-039` | Mantener historial y reportes estadísticos de visitas con alertas de accesos no autorizados. | Alta | Administrador / Vigilante | Visitantes |
| `RF-040` | Registrar PQRS clasificadas por tipo con radicado único y plazo legal de respuesta. | Alta | Usuario | PQRS |
| `RF-041` | Asignar PQRS a responsable en ≤ 24 horas o escalar por defecto al coordinador con alerta al administrador. | Alta | Administrador / Sistema | PQRS |
| `RF-042` | Consultar estado de PQRS por código de radicado sin inicio de sesión y notificar cambios de estado. | Media | Usuario | PQRS |
| `RF-043` | Registrar respuesta formal de PQRS con soporte, alertas 2 días antes del vencimiento y cierre controlado. | Alta | Administrador / Responsable | PQRS |
| `RF-044` | Mantener historial inalterable de cada PQRS y exportar reportes en PDF/Excel. | Alta | Sistema | PQRS |
| `RF-045` | Registrar propietarios de ambulancias, vincular unidades y clasificarlas por tipo TAB/TAM, habilitación y estado contractual. | Alta | Administrador | Unidades |
| `RF-046` | Controlar estado operativo/contractual impidiendo asignar unidades no operativas y conservando historial de cambios. | Alta | Sistema | Unidades |
| `RF-047` | Registrar proveedores y contratos con alertas de vencimiento a los 30, 15 y 5 días previos. | Alta | Administrador | Proveedores |
| `RF-048` | Impedir vincular contratos vencidos a órdenes de servicio y conservar historial contractual. | Alta | Sistema | Proveedores |
| `RF-049` | Registrar evaluaciones de desempeño de proveedores y generar reportes PDF/Excel. | Media | Administrador | Proveedores |
| `RF-050` | Cargar documentos (PDF, DOCX, XLSX, imágenes) validando MIME, tamaño, etiquetas y confidencialidad. | Alta | Administrador | Documental |
| `RF-051` | Versionar documentos automáticamente, bloquear edición de oficiales y controlar duplicados por hash. | Alta | Administrador | Documental |
| `RF-052` | Proveer búsqueda avanzada de documentos, vista integrada sin descarga obligatoria y descarga auditada por RBAC. | Alta | Usuarios autorizados | Documental |
| `RF-053` | Aplicar RBAC sobre acciones documentales, auditar operaciones y notificar cargas relevantes por rol. | Alta | Sistema | Documental |
| `RF-054` | Organizar documentos en carpetas jerárquicas vinculadas a módulos y exportar listados PDF/Excel. | Media | Administrador | Documental |
| `RF-055` | Registrar automáticamente eventos CRUD, autenticación, asignaciones, transiciones de servicio y cambios de rol en auditoría. | Alta | Sistema | Auditoría |
| `RF-056` | Garantizar inmutabilidad técnica de auditoría (sin edición ni borrado por ningún rol) y retención ≥ 5 años. | Alta | Sistema | Auditoría |
| `RF-057` | Consultar auditoría con filtros, detalle anterior/posterior y exportación PDF/Excel. | Alta | Administrador | Auditoría |
| `RF-058` | Detectar y alertar eventos críticos o anómalos de seguridad por nivel de criticidad. | Alta | Sistema | Auditoría |
| `RF-059` | Registrar novedades operativas con tipo, descripción, prioridad y vínculo a unidad, servicio o personal. | Alta | Usuarios autorizados | Novedades |
| `RF-060` | Asignar responsables de novedades, controlar ciclo (`Pendiente`, `En proceso`, `Resuelto`, `Cerrado`) y bloquear cerradas. | Alta | Coordinador / Administrador | Novedades |
| `RF-061` | Resaltar incidentes críticos, controlar tiempos de resolución, alertar vencimientos y registrar reasignaciones. | Alta | Sistema | Novedades |
| `RF-062` | Adjuntar evidencia multimedia, hilo cronológico de comentarios y búsqueda combinada en novedades. | Media | Usuarios autorizados | Novedades |
| `RF-063` | Generar reportes de novedades e indicadores de tiempo promedio de resolución correlacionados con auditoría y monitoreo. | Media | Administrador / Analista | Novedades |
| `RF-064` | Generar y programar reportes operativos periódicos personalizados con exportación PDF/Excel. | Alta | Administrador / Analista | Reportes |
| `RF-065` | Calcular KPI operativos (tiempo promedio de respuesta, servicios TAB/TAM, tasa cancelación, incidentes) con gráficos interactivos. | Alta | Administrador / Analista | Reportes |

---

## 5. Requisitos no funcionales (`RNF-001` a `RNF-029`) y reglas de negocio (`RN-001` a `RN-018`)

### 5.1 Requisitos no funcionales clave
- **Seguridad (`RNF-001` a `RNF-007`):** Hash seguro con sal única (`bcrypt`/`Argon2`, `RNF-001`), comunicación exclusiva `HTTPS/TLS` (`RNF-002`), `RBAC` (`RNF-003`), cifrado en reposo de datos sensibles de pacientes bajo Ley 1581/2012 (`RNF-004`), complejidad y rotación de contraseña cada 90 días (`RNF-005`), sanitización OWASP SQLi/XSS/CSRF (`RNF-006`), confirmación explícita y auditoría de acciones críticas (`RNF-007`).
- **Rendimiento (`RNF-008` a `RNF-012`):** Consultas críticas ≤ 3 s (`RNF-008`), asignación automática ≤ 2 s (`RNF-009`), ≥ 20 usuarios concurrentes sin degradación (`RNF-010`), carga de UI ≤ 5 s (`RNF-011`), priorización de tráfico crítico (`RNF-012`).
- **Disponibilidad (`RNF-013` a `RNF-015`):** Disponibilidad mínima **97 %** 24/7 (`RNF-013`), mantenimientos en ventanas de baja demanda (`RNF-014`), respaldos, reinicio controlado y alertas (`RNF-015`).
- **Usabilidad (`RNF-016` a `RNF-020`):** Flujo de registro y asignación en ≤ 4 pasos (`RNF-016`), responsivo en navegadores modernos (`RNF-017`), mensajes de error accionables (`RNF-018`), menú dinámico por rol (`RNF-019`), priorización visual de emergencias activas (`RNF-020`).
- **Escalabilidad, Compatibilidad y Mantenibilidad (`RNF-021` a `RNF-027`):** Retención de datos ≥ 5 años (`RNF-021`), despliegue en contenedores Docker (`RNF-022`), multiplataforma en navegador (`RNF-023`), exportación compatible Office/LibreOffice (`RNF-024`), arquitectura modular desacoplada (`RNF-025`), documentación y estándares (`RNF-026`), extensibilidad futura GPS/HCE (`RNF-027`).
- **Trazabilidad y Respaldo (`RNF-028` a `RNF-029`):** Trazabilidad completa con estado anterior/posterior (`RNF-028`), respaldo diario fuera del servidor principal con retención de 30 copias, **RTO ≤ 4 h y RPO ≤ 24 h** (`RNF-029`).

### 5.2 Reglas de negocio (`RN-001` a `RN-018`)
- `RN-001` Solo ambulancias `Disponible` pueden asignarse.
- `RN-002` Coherencia TAB/TAM según complejidad clínica con advertencia al coordinador.
- `RN-003` Bloqueo de ambulancia con SOAT, técnico-mecánica o REPS vencidos.
- `RN-004` Bloqueo de personal no disponible o con certificaciones expiradas.
- `RN-005` Cierre de servicio exige resultado, estado paciente, destino y responsable.
- `RN-006` Cancelación permitida solo en estados `Solicitado` o `Asignado`.
- `RN-007` Asignación manual distinta a sugerencia exige motivo registrado.
- `RN-008` Renovación obligatoria de contraseña cada 90 días (alerta 10 días antes).
- `RN-009` Bloqueo automático de 30 min tras 5 intentos fallidos consecutivos.
- `RN-010` Inmutabilidad total de auditoría y retención ≥ 5 años.
- `RN-011` a `RN-018` Reglas de PQRS (24 h), contratos vencidos (alertas 30/15/5 días), documentos oficiales bloqueados, inmutabilidad de facturas, cartera/mora (30 días), cierre de novedades con resolución, control de visitantes y reportes de solo lectura.

---

## 6. Resumen del modelo entidad-relación base (23 entidades)
- **Núcleo operativo:** `roles`, `usuarios`, `ambulancias`, `personal`, `pacientes`, `solicitudes_emergencia`, `servicios`, `historial_estados_servicio`, `personal_servicio`.
- **Gestión financiera:** `proveedores`, `contratos_proveedor`, `evaluaciones_proveedor`, `facturas`, `notas_credito_debito`, `cartera`, `pagos`, `movimientos_financieros`.
- **Soporte:** `documentos`, `versiones_documento`, `visitantes`, `preautorizaciones`, `pqrs`, `respuestas_pqrs`, `novedades`, `comentarios_novedad`, `auditorias`.

---

## 7. Referencias
- IEEE. (1998). *IEEE Recommended Practice for Software Requirements Specifications* (IEEE Std 830-1998).
- ISO/IEC 25010. (2023). *Systems and software Quality Requirements and Evaluation (SQuaRE)*.
- Ministerio de Salud y Protección Social. (2017). *Resolución 3100 de 2017*. Bogotá, Colombia.
- DANE. (2023). *Encuesta Nacional de Calidad de Vida*. Bogotá, Colombia.
