# Modelo Entidad-Relación Conceptual (v2 Verificada) — SIGMAVITAL (SGA)

**Autor:** `@darkid8`  
**Versión:** 2.0 (Día 2 — 2026-11-27 · Corregidos hallazgos `H-04` y `H-05`: añadido `hora_incorporacion` en `TRIPULACION_SERVICIO` y agregada entidad débil `HISTORIAL_ESTADO_SERVICIO`)  
**Notación declarada:** **Pata de Gallo (Crow's Foot)** con cardinalidad y participación `(mín,máx)`.  
**Diagramas:** [05-mer-conceptual.drawio](./05-mer-conceptual.drawio) · [05-mer-conceptual.svg](./05-mer-conceptual.svg)

---

## 1. Entidades del núcleo prehospitalario (11 entidades)

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
| `TRIPULACION_SERVICIO` | **Asociativa (N:M)** | `(id_servicio, id_personal)` | `rol_operativo`, `hora_incorporacion` |
| `HISTORIAL_ESTADO_SERVICIO` | **Débil** (depende de `SERVICIO`) | `id_historial` | `id_servicio (FK)`, `estado_anterior`, `estado_nuevo`, `fecha_cambio` |

## 2. Resolución de relaciones exigidas (`Rubricas_G1.md` §5.1 d)
- **Relación N:M resuelta con atributos propios:** `SERVICIO (1,N)` ↔ `PERSONAL (0,N)` mediante la entidad asociativa `TRIPULACION_SERVICIO` con atributos propios `rol_operativo` y `hora_incorporacion`.
- **Entidades débiles:** `DOCUMENTO_UNIDAD` depende de `AMBULANCIA (1,1)` — `(1,N)` y `HISTORIAL_ESTADO_SERVICIO` depende de `SERVICIO (1,1)` — `(1,N)` para trazabilidad REPS (`RF-024`, `RNF-028`).
