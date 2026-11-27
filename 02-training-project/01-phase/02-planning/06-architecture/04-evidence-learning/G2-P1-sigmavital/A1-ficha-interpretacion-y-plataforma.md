# A1 · Ficha de Interpretación del Análisis y Plataforma Tecnológica — SIGMAVITAL (SGA)

**Autor:** `@darkid8`  
**Caso de estudio:** SIGMAVITAL — Sistema de Gestión de Ambulancias (SGA)  
**Fuente de análisis:** [SRS_SIGMAVITAL_SGA.md](../../../01-analysis/02-requirements/04-evidence-learning/SRS_SIGMAVITAL_SGA.md)

---

## 1. Subconjunto individual de Requisitos Funcionales seleccionados (14 RF)

Dado que el SRS base de SIGMAVITAL fue levantado en equipo (65 RF), `@darkid8` diseña individualmente el **núcleo operativo de despacho, control de habilitación, monitoreo y trazabilidad APH**, compuesto por **14 requisitos funcionales** y **5 requisitos no funcionales**:

| ID RF | Descripción resumida del SRS | Módulo |
|---|---|---|
| `RF-002` | Autenticar usuarios mediante correo y contraseña generando token JWT con expiración configurable y control por rol. | Autenticación |
| `RF-005` | Implementar control de acceso basado en roles (`RBAC`) restringiendo módulos y acciones según perfil. | Autenticación |
| `RF-007` | Registrar intentos fallidos y bloquear automáticamente la cuenta durante 30 minutos al superar 5 intentos consecutivos. | Autenticación |
| `RF-008` | Registrar ambulancias con número de unidad, placa, tipo (`TAB` o `TAM`), marca, modelo, año y habilitación REPS. | Ambulancias |
| `RF-011` | Controlar documentación obligatoria (SOAT, técnico-mecánica, REPS), alertar vencimientos e impedir asignación vencida. | Ambulancias |
| `RF-014` | Registrar personal operativo (paramédicos y conductores) con tarjeta profesional, certificaciones y disponibilidad. | Personal |
| `RF-016` | Controlar vencimiento de certificaciones del personal e impedir asignación a servicios si expiró documentación crítica. | Personal |
| `RF-018` | Registrar pacientes atendidos con identificación, contacto y antecedentes bajo confidencialidad RBAC. | Pacientes |
| `RF-021` | Registrar solicitudes de emergencia con hora, dirección, tipo de emergencia y prioridad clínica (`verde`, `amarillo`, `naranja`, `rojo`). | Emergencias |
| `RF-022` | Ejecutar asignación automática de ambulancia por disponibilidad, tipo `TAB`/`TAM`, prioridad y proximidad en ≤ 2 s. | Emergencias |
| `RF-023` | Permitir asignación manual de ambulancia por el coordinador con registro obligatorio de motivo (`RN-007`). | Emergencias |
| `RF-024` | Gestionar ciclo de vida completo del servicio (`Solicitado` → `Asignado` → `En ruta` → `En atención` → `Traslado` → `Finalizado` / `Cancelado`) y cierre formal (`RN-005`). | Emergencias |
| `RF-028` | Proveer panel centralizado en tiempo real vía WebSockets diferenciando visualmente unidades `TAB` y `TAM`. | Monitoreo |
| `RF-055` | Registrar automáticamente eventos críticos (autenticación, asignaciones, transiciones de servicio y cambios de estado) en auditoría inmutable. | Auditoría |

---

## 2. Requisitos No Funcionales seleccionados (5 RNF con métrica)

| ID RNF | Atributo / Estándar | Métrica verificable del SRS |
|---|---|---|
| `RNF-001` | Seguridad · Credenciales | Contraseñas almacenadas exclusivamente con **hash + sal (`bcrypt`/`Argon2`)**, sin texto plano ni cifrado reversible. |
| `RNF-002` | Seguridad · Transporte | **100 %** del tráfico cliente-servidor bajo **HTTPS / WSS con TLS vigente**; redirección automática de HTTP. |
| `RNF-004` | Seguridad · Datos sensibles | Datos sensibles de pacientes cifrados en reposo conforme a **Ley 1581 de 2012** y acceso restringido por RBAC. |
| `RNF-009` | Rendimiento · Despacho | Algoritmo de asignación automática de ambulancia ejecutado en **≤ 2 segundos** desde la recepción de la solicitud. |
| `RNF-013` | Disponibilidad | Operación continua 24/7 con disponibilidad mínima del **97 %** mensual (unificada frente a `RST-04`). |

---

## 3. Actores y restricciones del caso

- **Actores:** `Administrador`, `Coordinador Operativo`, `Paramédico` (`TAB`/`TAM`), `Conductor` y actor secundario externo `Servicio Correo SMTP`.
- **Restricciones clave:** Cumplimiento obligatorio de **Resolución 3100 de 2017** (habilitación TAB/TAM y REPS), **Ley 1581 de 2012** (protección de datos personales de salud), operación exclusivamente vía navegador web sin apps nativas (`RST-03`), infraestructura moderada en VPS Linux con contenedores Docker (`RST-10`) y equipo de 4 desarrolladores.

---

## 4. Selección y justificación de plataforma tecnológica

### 4.1 Lenguaje Orientado a Objetos seleccionado: **TypeScript (sobre Node.js + Express en Backend y React 18 en Frontend)**
Justificación con **4 condiciones concretas** del caso SIGMAVITAL:
1. **Tipado estricto orientado a objetos para reglas clínicas (`RN-001`–`RN-007`):** TypeScript permite definir interfaces polimórficas (`ICriterioAsignacion`, `ISuscriptorEventoOperativo`), clases abstractas (`PersonalOperativo`) y enumeraciones seguras (`TipoUnidad: TAB | TAM`, `EstadoServicio`) reduciendo errores de tipos en compilación antes del despliegue.
2. **Ecosistema unificado para tiempo real (`RF-028`, `RNF-009`):** Node.js con `Socket.IO` gestiona conexiones concurrentes WebSocket con baja latencia (≤ 2 s en despacho) usando el mismo lenguaje que el frontend React, lo cual optimiza la curva de trabajo de un equipo de 4 personas.
3. **Portabilidad en contenedores ligeros (`RST-10`):** El runtime Node.js sobre Docker consume poca memoria en un VPS estándar (8 GB RAM) frente a máquinas virtuales pesadas.
4. **Madurez de librerías de seguridad (`RNF-001`, `RNF-002`):** Disponibilidad nativa y auditada de `bcrypt`/`argon2`, `jsonwebtoken`, `helmet` y validación de esquemas para blindar endpoints REST.

### 4.2 Tipo de Base de Datos seleccionada: **Base de Datos Relacional — PostgreSQL 16**
Justificación con **4 condiciones concretas** del caso SIGMAVITAL:
1. **Integridad transaccional ACID en asignación simultánea (`RN-001`):** Impide condiciones de carrera al asignar una misma ambulancia `Disponible` a dos emergencias concurrentes mediante bloqueos transaccionales y restricciones `UNIQUE` / `FOREIGN KEY`.
2. **Estructura relacional fija y trazabilidad REPS (`RF-011`, `RF-024`, `RF-055`):** Las entidades (`solicitud_emergencia` 1:1 `servicio`, `ambulancia` 1:N `documento_ambulancia`, `servicio` N:M `personal`) tienen cardinalidades estrictas y exigen integridad referencial.
3. **Soporte nativo de `CHECK`, `ENUM` e inmutabilidad (`RN-005`, `RN-010`):** Permite validar reglas de integridad directamente en el motor y almacenar instantáneas estructuradas (`JSONB`) en el log de auditoría inmutable.
4. **Retención a 5 años y respaldos consistentes (`RNF-021`, `RNF-029`):** PostgreSQL soporta `pg_dump` automatizado y particionamiento futuro sin cambiar la estructura lógica.

---

## 5. Lista de entregables de diseño (`G2-P1`)

- **A1:** Ficha de interpretación y plataforma tecnológica (`A1-ficha-interpretacion-y-plataforma.md`).
- **A2 y A3:** Diagrama de clases OO y 2 patrones GoF (`A2-A3-diagrama-clases-y-patrones.drawio`, `A2-diagrama-clases.svg`, `A2-A3-clases-y-patrones.md`).
- **A4:** Arquitectura del software en capas y decisiones frente a RNF (`A4-arquitectura.drawio`, `A4-arquitectura.svg`, `A4-arquitectura-decisiones.md`).
- **A5:** Vista de componentes *(en elaboración — Día 2)*.
- **A6:** Vista de despliegue *(en elaboración — Día 2)*.
- **A7:** Matriz de trazabilidad bidireccional análisis → diseño *(en elaboración — Día 2)*.
