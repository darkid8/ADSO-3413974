# Plantillas Extendidas de Casos de Uso — SIGMAVITAL (SGA)

**Autor:** `@darkid8`  
**Versión:** 1.0 (Día 1 — 2026-11-26)  
**Formato:** Anexo A de `Plantilla_README_Entrega_G1.md`

---

## Plantilla 1 · `CU-05 · Registrar solicitud de emergencia y paciente`

| Campo | Contenido |
|---|---|
| **Identificador y nombre** | `CU-05 · Registrar solicitud de emergencia y paciente` |
| **Requisitos que atiende** | `RF-018`, `RF-019`, `RF-020`, `RF-021` |
| **Actor primario / secundarios** | Primario: Coordinador Operativo / Secundario: Ninguno |
| **Objetivo del actor** | Registrar una llamada o solicitud de emergencia prehospitalaria junto con los datos básicos y prioridad clínica del paciente para habilitar el despacho. |
| **Precondiciones** | El Coordinador Operativo inició sesión con rol autorizado en el módulo de Emergencias (`CU-01`). |
| **Disparador** | El Coordinador Operativo selecciona «Nueva solicitud de emergencia» al recibir un reporte de urgencia. |
| **Flujo principal** | 1. El Coordinador Operativo abre el formulario de registro de emergencias.<br>2. El sistema presenta los campos de solicitante, dirección o coordenadas del evento, tipo de emergencia, prioridad clínica y búsqueda/registro de paciente.<br>3. El Coordinador Operativo ingresa el número de documento del paciente para verificar si existe en el sistema.<br>4. El sistema consulta la ficha del paciente y precarga nombre, fecha de nacimiento, contacto familiar y antecedentes relevantes si existe registro previo.<br>5. El Coordinador Operativo completa o actualiza los datos del paciente, la dirección exacta, el tipo de emergencia y asigna la prioridad clínica (`Verde`, `Amarillo`, `Naranja` o `Rojo`).<br>6. El sistema valida que los campos obligatorios estén completos y que la prioridad sea coherente con el protocolo.<br>7. El Coordinador Operativo confirma el registro de la solicitud.<br>8. El sistema genera el identificador único de la solicitud, fija su estado inicial en `Solicitado` con marca de tiempo y habilita la opción de despacho (`CU-06`). |
| **Flujos alternos** | **3a.** Si el paciente no tiene registro previo o ingresa sin documento en situación crítica, el sistema permite registrar un paciente nuevo o un ingreso temporal no identificado con los datos disponibles y continúa en el paso 5.<br>**4a.** Si el paciente tiene servicios previos registrados, el sistema muestra un resumen de atenciones anteriores (`RF-020`) para apoyar la clasificación clínica. |
| **Excepciones** | **6a.** Si falta dirección del evento, prioridad clínica o contacto mínimo, el sistema resalta los campos faltantes con un mensaje correctivo y detiene el guardado hasta completarlos. |
| **Postcondiciones** | La solicitud queda registrada en estado `Solicitado` vinculada al paciente con prioridad clínica y hora exacta de recepción. |
| **Reglas de negocio** | Confidencialidad de datos de salud según Ley 1581 de 2012 (`RNF-004`). |
| **Pantalla del prototipo** | `PANT-01 · Registro de Emergencia (CU-05)` *(por vincular en Día 2)* |

---

## Plantilla 2 · `CU-06 · Despachar ambulancia a servicio de emergencia`

| Campo | Contenido |
|---|---|
| **Identificador y nombre** | `CU-06 · Despachar ambulancia a servicio de emergencia` |
| **Requisitos que atiende** | `RF-022`, `RF-023`, `RF-026`, `RN-001`, `RN-002`, `RN-003`, `RN-004`, `RN-007` |
| **Actor primario / secundarios** | Primario: Coordinador Operativo / Secundario: Paramédico (notificado del servicio) |
| **Objetivo del actor** | Asignar la ambulancia TAB o TAM y la tripulación más adecuada a una solicitud activa en el menor tiempo posible. |
| **Precondiciones** | El Coordinador Operativo inició sesión y existen ambulancias en estado `Disponible` en la base de datos. *(Nota de control interno v1: en Día 2 se ajustará para dejar solo lo asumido antes de iniciar y mover la verificación de disponibilidad al flujo alterno/excepción).* |
| **Disparador** | El Coordinador Operativo selecciona «Despachar unidad» sobre una solicitud en estado `Solicitado`. |
| **Flujo principal** | 1. El Coordinador Operativo selecciona la solicitud de emergencia pendiente.<br>2. El sistema invoca la validación obligatoria de habilitación (`CU-13`) sobre las unidades y tripulantes activos.<br>3. El sistema evalúa prioridad clínica, tipo de unidad requerida (`TAB` o `TAM`), disponibilidad y proximidad, presentando una sugerencia automática de ambulancia y tripulación en ≤ 2 s.<br>4. El Coordinador Operativo revisa la unidad sugerida y confirma la asignación.<br>5. El sistema crea el servicio vinculado en la tabla `servicios` con estado `Asignado`, cambia el estado de la ambulancia a `En servicio` y emite la notificación por `WebSocket` al tablero de monitoreo y al equipo en campo.<br>6. El sistema registra el evento de despacho en la auditoría (`CU-14`). |
| **Flujos alternos** | **4a.** Si el Coordinador Operativo decide elegir una unidad distinta a la sugerida (`CU-15`), el sistema solicita el motivo obligatorio de asignación manual (`RN-007`), valida que la unidad seleccionada cumpla `RN-001`/`RN-003` y continúa en el paso 5.<br>**4b.** Si el Coordinador necesita cancelar la solicitud antes de que la unidad salga a ruta (`RF-026`, `RN-006`), registra la justificación obligatoria, el sistema cambia el estado a `Cancelado`, audita el evento y finaliza el caso con cierre administrativo válido. |
| **Excepciones** | **2a.** Si ninguna ambulancia tiene documentación vigente (SOAT, técnico-mecánica o REPS) ni tripulación habilitada (`RN-003`, `RN-004`), el sistema bloquea la asignación automática, muestra una alerta crítica en rojo y mantiene la solicitud en `Solicitado` para gestión manual o escalamiento.<br>**4c.** Si el Coordinador intenta asignar una unidad `TAB` a un caso de prioridad crítica que exige `TAM`, el sistema emite advertencia normativa (`RN-002`) exigiendo confirmación o cambio de unidad. |
| **Postcondiciones** | Queda creado el servicio en estado `Asignado` con ambulancia, tripulación y marca de tiempo, y la unidad pasa a `En servicio`. |
| **Reglas de negocio** | `RN-001`, `RN-002`, `RN-003`, `RN-004`, `RN-006`, `RN-007`, `RN-010`. |
| **Pantalla del prototipo** | `PANT-02 · Panel de Despacho y Monitoreo (CU-06 / CU-08)` *(por vincular en Día 2)* |

---

## Plantilla 3 · `CU-07 · Gestionar atención prehospitalaria y cierre de servicio`

| Campo | Contenido |
|---|---|
| **Identificador y nombre** | `CU-07 · Gestionar atención prehospitalaria y cierre de servicio` |
| **Requisitos que atiende** | `RF-024`, `RF-025`, `RF-027`, `RN-005` |
| **Actor primario / secundarios** | Primario: Paramédico / Secundario: Coordinador Operativo |
| **Objetivo del actor** | Registrar la progresión operativa de la atención prehospitalaria desde la salida hasta la entrega del paciente y cerrar formalmente el servicio. |
| **Precondiciones** | El Paramédico inició sesión y tiene un servicio asignado en estado `Asignado`. |
| **Disparador** | El Paramédico inicia el desplazamiento de la ambulancia asignada. |
| **Flujo principal** | 1. El Paramédico selecciona el servicio asignado y marca la transición a `En ruta`.<br>2. El sistema registra la hora de salida y actualiza el estado visible en el panel operativo.<br>3. Al arribar al sitio de la emergencia, el Paramédico registra la llegada (`En atención`) y consigna la valoración clínica inicial del paciente (`RF-019`).<br>4. Cuando inicia el traslado hacia la institución receptora, el Paramédico actualiza el estado a `Traslado`.<br>5. Al entregar al paciente, el Paramédico diligencia los campos obligatorios de cierre: resultado de la atención, estado final del paciente, institución de destino y responsable de cierre (`RN-005`).<br>6. El sistema verifica que todos los campos obligatorios estén completos y que no existan novedades críticas bloqueantes.<br>7. El sistema cambia el estado del servicio a `Finalizado`, libera la ambulancia y la tripulación a estado `Disponible` y registra el cierre en la auditoría (`CU-14`). |
| **Flujos alternos** | **3a.** Si el paciente no requiere traslado a centro asistencial y es estabilizado en sitio, el Paramédico registra «Atención en sitio sin traslado» en el destino, completa resultado y estado final y continúa en el paso 6.<br>**4a.** Si ocurre una falla vehicular, retraso o incidente con el paciente durante el recorrido, el Paramédico activa el caso extendido `Reportar incidente en ruta (CU-16)` y continúa el registro del servicio. |
| **Excepciones** | **6a.** Si falta alguno de los cuatro campos obligatorios de cierre (`RN-005`), el sistema impide finalizar el servicio, señala los campos incompletos y mantiene el estado actual.<br>**6b.** Si un usuario intenta cancelar el servicio estando en estado `En ruta`, `En atención` o `Traslado`, el sistema rechaza la cancelación (`RN-006`) e indica que debe documentar una novedad operativa. |
| **Postcondiciones** | El servicio queda en estado `Finalizado` con historial completo de marcas de tiempo, y la ambulancia junto con su tripulación vuelven a estado `Disponible`. |
| **Reglas de negocio** | `RN-005`, `RN-006`, `RN-010`. |
| **Pantalla del prototipo** | `PANT-03 · Bitácora de Atención y Cierre APH (CU-07)` *(por vincular en Día 2)* |
