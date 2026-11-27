# Modelo Entidad-Relación Conceptual (v1) — SIGMAVITAL (SGA)

**Autor:** `@darkid8`  
**Notación declarada:** **Pata de Gallo (Crow's Foot)** con cardinalidad y participación `(mín,máx)`.  
**Diagramas:** [05-mer-conceptual.drawio](./05-mer-conceptual.drawio) · [05-mer-conceptual.svg](./05-mer-conceptual.svg)

---

## 1. Entidades del núcleo prehospitalario (10 entidades en v1)

| Entidad | Tipo | Identificador (PK) | Atributos principales |
|---|---|---|---|
| `ROL` | Fuerte | `id_rol` | `nombre_rol`, `activo` |
| `USUARIO` | Fuerte | `id_usuario` | `id_rol (FK)`, `correo`, `password_hash` |
| `PERSONAL` | Fuerte | `id_personal` | `id_usuario (FK)`, `tipo_cargo`, `estado_disponibilidad` |
| `SEDE` | Fuerte | `id_sede` | `nombre_sede`, `ciudad` |
| `AMBULANCIA` | Fuerte | `id_ambulancia` | `id_sede (FK)`, `placa`, `tipo_unidad`, `estado_operativo` |
| `DOCUMENTO_UNIDAD` | **Débil** (depende de `AMBULANCIA`) | `id_documento` | `id_ambulancia (FK)`, `tipo_doc`, `fecha_vencimiento` |
| `PACIENTE` | Fuerte | `id_paciente` | `documento`, `nombre_completo` |
| `SOLICITUD_EMERGENCIA` | Fuerte | `id_solicitud` | `id_paciente (FK)`, `prioridad_clinica`, `direccion_evento` |
| `SERVICIO` | Fuerte | `id_servicio` | `id_solicitud (FK)`, `id_ambulancia (FK)`, `estado`, `destino_traslado` |
| `TRIPULACION_SERVICIO` | **Asociativa (N:M)** | `(id_servicio, id_personal)` | `rol_operativo` *(en Día 2 se completará atributo de marca temporal tras verificación)* |

## 2. Resolución de relaciones exigidas
- **Relación N:M resuelta:** `SERVICIO (1,N)` ↔ `PERSONAL (0,N)` se resuelve mediante la entidad asociativa `TRIPULACION_SERVICIO`.
- **Entidad débil:** `DOCUMENTO_UNIDAD` depende existencialmente de `AMBULANCIA (1,1)` — `(1,N)`.
