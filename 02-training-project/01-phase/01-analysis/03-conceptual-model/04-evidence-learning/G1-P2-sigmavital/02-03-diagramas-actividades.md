# Diagramas de Actividades UML — SIGMAVITAL (SGA)

**Autor:** `@darkid8`  
**Casos de uso críticos modelados:** `CU-06` y `CU-07`

---

## 1. Diagrama de Actividades 1 · `CU-06 Despachar ambulancia a servicio de emergencia`

- **Fuente editable:** [02-actividad-despacho.drawio](./02-actividad-despacho.drawio)
- **Imagen:** [02-actividad-despacho.svg](./02-actividad-despacho.svg)
- **Calles (*swimlanes*):** `Coordinador Operativo`, `Sistema SIGMAVITAL`, `Paramédico`.
- **Concurrencia:** Se modela mediante barra explícita de **bifurcación (*fork*) y unión (*join*)** al confirmar el despacho: en paralelo se ejecuta la actualización del tablero operativo en tiempo real (`RF-028`) y el envío de notificación a la tripulación en campo.
- **Guardas y correspondencia con la plantilla `CU-06`:**
  - `[Unidades y tripulación habilitadas]` → flujo principal paso 3.
  - `[Sin unidades habilitadas]` → excepción `2a` (bloqueo, alerta roja y fin en `Solicitado`).
  - `[Sugerencia automática aceptada]` → flujo principal paso 4.
  - `[Asignación manual con motivo RN-007]` → flujo alterno `4a` (`CU-15`).
  - `[Tipo TAB/TAM acorde a prioridad]` → flujo principal paso 5.
  - `[Requiere confirmación advertencia RN-002]` → excepción `4c` (solicitud de confirmación explícita).

---

## 2. Diagrama de Actividades 2 · `CU-07 Gestionar atención prehospitalaria y cierre de servicio`

- **Fuente editable:** [03-actividad-atencion-cierre.drawio](./03-actividad-atencion-cierre.drawio)
- **Imagen:** [03-actividad-atencion-cierre.svg](./03-actividad-atencion-cierre.svg)
- **Calles (*swimlanes*):** `Paramédico`, `Sistema SIGMAVITAL`.
- **Declaración sobre concurrencia (`Rubricas_G1.md` §5.1 a):** Este proceso de atención y cierre es estrictamente secuencial porque cada transición de estado (`En ruta` → `En atención` → `Traslado` → `Finalizado`) depende cronológicamente de la culminación clínica de la etapa anterior, por lo que no presenta bifurcaciones paralelas internas.
- **Guardas y correspondencia con la plantilla `CU-07`:**
  - `[Requiere traslado a IPS]` → flujo principal paso 4.
  - `[Estabilizado en sitio sin traslado]` → flujo alterno `3a`.
  - `[Ocurre incidente en ruta]` → flujo alterno `4a` (invoca `CU-16`).
  - `[Sin incidentes]` → continúa hacia cierre (flujo principal paso 5).
  - `[4 campos obligatorios RN-005 completos]` → flujo principal pasos 6–7 (cierre `Finalizado`, liberación de unidad y auditoría `CU-14`).
  - `[Faltan campos de cierre]` → excepción `6a` (bloqueo y retorno para corregir datos).
