# A2 y A3 · Diagrama de Clases OO y Patrones de Diseño GoF — SIGMAVITAL (SGA)

**Autor:** `@darkid8`  
**Diagramas:** [A2-A3-diagrama-clases-y-patrones.drawio](./A2-A3-diagrama-clases-y-patrones.drawio) · [A2-diagrama-clases.svg](./A2-diagrama-clases.svg)

---

## 1. Diseño Orientado a Objetos (`A2`)

El diagrama contiene **16 clases e interfaces** con visibilidad (`+`, `-`, `#`), atributos tipados, métodos con parámetros/retorno y multiplicidades completas:

- **Herencia (`«is-a»`):** `Paramedico` y `Conductor` heredan de la clase abstracta `PersonalOperativo`, compartiendo `#idPersonal`, `#nombreCompleto`, `#disponible` y `+estaHabilitado(): boolean`.
- **Composición (`◆`):** `Ambulancia` `1 ◆── 1..*` `DocumentoHabilitacion` — los documentos de habilitación (SOAT, técnico-mecánica, REPS) no tienen ciclo de vida independiente fuera de la ambulancia.
- **Agregación (`◇`):** `ServicioEmergencia` `0..* ◇── 1` `Ambulancia` — la ambulancia existe con independencia de los servicios puntuales que atiende.
- **Polimorfismo por interfaces:**
  - `ICriterioAsignacion` implementada por `AsignacionCriticaTAM` y `AsignacionEstandarTAB`.
  - `ISuscriptorEventoOperativo` implementada por `MonitorTableroTiempoReal` y `RegistradorAuditoriaInmutable`.

*(Nota de revisión Día 1: en esta versión v1 la clase `ServicioEmergencia` incluye `+exportarReportePDF(): Buffer`, cuya cohesión será evaluada en la lista de chequeo `B7` del Día 2.)*

---

## 2. Patrones de Diseño GoF aplicados (`A3`)

Se aplican **2 patrones de diseño GoF distintos de Singleton**, reflejados directamente sobre las clases del diagrama `A2`:

| Patrón GoF | Problema concreto en SIGMAVITAL | Por qué este patrón | Clases que lo implementan | Qué mejora en mantenibilidad |
|---|---|---|---|---|
| **Strategy** *(Comportamiento)* | La selección automática de ambulancia (`RF-022`) cambia según la complejidad clínica del caso: una emergencia crítica (`Rojo`/`Naranja`) prioriza equipamiento `TAM` y soporte vital avanzado, mientras una urgencia moderada (`Amarillo`/`Verde`) prioriza proximidad con unidad `TAB` (`RN-002`). | Encapsula cada algoritmo de selección detrás de una interfaz común evitando condicionales `if/else` rígidos dentro de `ServicioDespacho`. | Contexto: `ServicioDespacho`<br>Interfaz: `ICriterioAsignacion`<br>Estrategias concretas: `AsignacionCriticaTAM`, `AsignacionEstandarTAB` | Permite incorporar nuevas reglas de despacho (por ejemplo, prioridad por tráfico o red hospitalaria) creando una nueva clase sin modificar `ServicioDespacho`. |
| **Observer** *(Comportamiento)* | Cada asignación o cambio de estado de un servicio (`RF-024`) debe actualizar al instante el panel visual en tiempo real (`RF-028`) y, simultáneamente, quedar registrado en la auditoría inmutable (`RF-055`) sin acoplar el núcleo de despacho a sockets ni a tablas de logs. | Establece una suscripción uno-a-muchos desacoplada donde el sujeto notifica eventos de negocio a múltiples observadores independientes. | Sujeto: `ServicioDespacho`<br>Interfaz: `ISuscriptorEventoOperativo`<br>Observadores: `MonitorTableroTiempoReal`, `RegistradorAuditoriaInmutable` | Permite agregar nuevos canales reactivos (como alertas por correo SMTP o métricas KPI) suscribiéndolos a la interfaz sin alterar la lógica transaccional del despacho. |

---

## 3. Trazabilidad resumida Clases ↔ RF (v1)

| Clase / Interfaz | Requisitos atendidos |
|---|---|
| `Usuario`, `Rol` | `RF-002`, `RF-005`, `RF-007` |
| `PersonalOperativo`, `Paramedico`, `Conductor` | `RF-014`, `RF-016` |
| `Ambulancia`, `DocumentoHabilitacion` | `RF-008`, `RF-011` |
| `SolicitudEmergencia` | `RF-018`, `RF-021` |
| `ServicioEmergencia` | `RF-023`, `RF-024` |
| `ServicioDespacho`, `ICriterioAsignacion`, `AsignacionCriticaTAM`, `AsignacionEstandarTAB` | `RF-022`, `RF-023` |
| `ISuscriptorEventoOperativo`, `MonitorTableroTiempoReal`, `RegistradorAuditoriaInmutable` | `RF-028`, `RF-055` |
