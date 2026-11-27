# B1 · Modelo Conceptual de Datos — SIGMAVITAL (SGA)

**Autor:** `@darkid8`  
**Notación declarada:** **Pata de Gallo (Crow's Foot)** con cardinalidad `(mín,máx)` y verbo descriptivo en cada relación.  
**Diagramas:** [B1-modelo-conceptual.drawio](./B1-modelo-conceptual.drawio) · [B1-modelo-conceptual.svg](./B1-modelo-conceptual.svg)

---

## 1. Justificación de Base de Datos Relacional
El modelo de datos de SIGMAVITAL se estructura para un SGBD relacional (**PostgreSQL**) porque el negocio prehospitalario requiere: (a) consistencia ACID estricta para impedir asignación doble de una misma ambulancia (`RN-001`), (b) integridad referencial verificada sobre habilitaciones REPS/SOAT y trazabilidad de servicios (`RN-003`, `RF-024`), y (c) estructura tabular estable para auditorías normativas a 5 años (`RNF-021`).

---

## 2. Entidades del modelo conceptual (9 entidades)

| Entidad | Identificador (PK) | Atributos clave | Requisitos que soporta |
|---|---|---|---|
| `ROL` | `id_rol` | `nombre_rol`, `descripcion`, `activo` | `RF-005` |
| `USUARIO` | `id_usuario` | `nombre_completo`, `correo`, `password_hash`, `intentos_fallidos` | `RF-002`, `RF-007` |
| `PERSONAL` | `id_personal` | `tipo_cargo`, `tarjeta_profesional`, `vigencia_certificado`, `estado_disponibilidad` | `RF-014`, `RF-016` |
| `SEDE` | `id_sede` | `nombre_sede`, `ciudad`, `direccion` | `RF-008`, `RF-010` |
| `AMBULANCIA` | `id_ambulancia` | `numero_unidad`, `placa`, `tipo_unidad`, `estado_operativo` | `RF-008`, `RF-028` |
| `DOCUMENTO_AMBULANCIA` | `id_documento` | `tipo_documento`, `numero_registro`, `fecha_vencimiento` | `RF-011` |
| `PACIENTE` | `id_paciente` | `tipo_documento`, `num_documento`, `nombre_completo`, `telefonos` *(multivaluado)* | `RF-018` |
| `SOLICITUD_EMERGENCIA` | `id_solicitud` | `fecha_hora`, `direccion_evento`, `tipo_emergencia`, `prioridad_clinica` | `RF-021` |
| `SERVICIO` | `id_servicio` | `estado_servicio`, `asignacion_manual`, `hora_asignacion`, `resultado_atencion` | `RF-022`, `RF-023`, `RF-024` |

## 3. Relaciones y cardinalidades
- `ROL` `(1,1)` **asigna** `(0,N)` `USUARIO` (1:N).
- `USUARIO` `(1,1)` **vincula** `(0,1)` `PERSONAL` (1:0..1).
- `PERSONAL` `(1,N)` **atiende** `(0,N)` `SERVICIO` (**N:M**).
- `PACIENTE` `(1,1)` **origina** `(1,N)` `SOLICITUD_EMERGENCIA` (1:N).
- `SOLICITUD_EMERGENCIA` `(1,1)` **desencadena** `(1,1)` `SERVICIO` (1:1).
- `AMBULANCIA` `(1,1)` **ejecuta** `(0,N)` `SERVICIO` (1:N).
- `SEDE` `(1,1)` **aloja** `(0,N)` `AMBULANCIA` (1:N).
- `AMBULANCIA` `(1,1)` **acredita** `(1,N)` `DOCUMENTO_AMBULANCIA` (1:N).
