# B2 · Modelo Lógico Relacional y Reglas de Transformación — SIGMAVITAL (SGA)

**Autor:** `@darkid8`  
**Diagramas:** [B2-modelo-logico.drawio](./B2-modelo-logico.drawio) · [B2-modelo-logico.svg](./B2-modelo-logico.svg)

---

## 1. Esquema lógico relacional (12 tablas normalizadas en 3FN)

1. `rol(id_rol PK, nombre_rol UQ, descripcion, activo)`
2. `sede(id_sede PK, nombre_sede UQ, ciudad, direccion)`
3. `usuario(id_usuario PK, id_rol FK, nombre_completo, correo UQ, password_hash, intentos_fallidos, bloqueado_hasta, activo)`
4. `personal(id_personal PK, id_usuario FK UQ, tipo_cargo, tarjeta_profesional UQ, vigencia_certificado, disponible)`
5. `paciente(id_paciente PK, tipo_documento, num_documento UQ, nombre_completo, antecedentes)`
6. `telefono_paciente(id_telefono PK, id_paciente FK, numero_telefono, etiqueta)`
7. `ambulancia(id_ambulancia PK, id_sede FK, numero_unidad UQ, placa UQ, tipo_unidad, estado_operativo)`
8. `documento_ambulancia(id_documento PK, id_ambulancia FK, tipo_documento, numero_registro, fecha_vencimiento)`
9. `solicitud_emergencia(id_solicitud PK, id_paciente FK, fecha_solicitud, direccion_evento, tipo_emergencia, prioridad_clinica)`
10. `servicio(id_servicio PK, id_solicitud FK UQ, id_ambulancia FK, estado_servicio, asignacion_manual, motivo_asignacion_manual, hora_asignacion, resultado_atencion, destino_traslado)`
11. `tripulacion_servicio(id_servicio PK/FK, id_personal PK/FK, rol_operativo, hora_asignacion)`
12. `auditoria_evento(id_auditoria PK, id_usuario FK, modulo, accion, entidad_afectada, id_entidad, detalle_json, fecha_hora)`

---

## 2. Cuadro de reglas de transformación aplicadas (`B1 → B2`)

| Regla de transformación | Caso en SIGMAVITAL (B1) | Resultado en el modelo lógico (B2) |
|---|---|---|
| **Relación N:M → tabla intermedia** | Un `SERVICIO` requiere varios miembros de `PERSONAL` y un miembro del `PERSONAL` participa en múltiples `SERVICIO`s. | Tabla `tripulacion_servicio(id_servicio FK, id_personal FK, rol_operativo, hora_asignacion)` con **PK compuesta `(id_servicio, id_personal)`**. |
| **Relación 1:N → FK en el lado «muchos»** | Un `ROL` agrupa varios `USUARIO`s; una `AMBULANCIA` posee varios `DOCUMENTO_AMBULANCIA`; un `PACIENTE` origina varias `SOLICITUD_EMERGENCIA`; una `SEDE` aloja varias `AMBULANCIA`s. | `usuario.id_rol FK`, `documento_ambulancia.id_ambulancia FK`, `solicitud_emergencia.id_paciente FK`, `ambulancia.id_sede FK` y `servicio.id_ambulancia FK`. |
| **Relación 1:1 → FK con restricción `UNIQUE`** | Cada `SOLICITUD_EMERGENCIA` desencadena exactamente un `SERVICIO`, y cada `USUARIO` operativo se vincula a lo sumo a un perfil de `PERSONAL`. | `servicio.id_solicitud FK UNIQUE` y `personal.id_usuario FK UNIQUE`. |
| **Atributo multivaluado → tabla aparte** | Un `PACIENTE` puede registrar uno o varios teléfonos de contacto y de familiares responsables (`RF-018`). | Tabla `telefono_paciente(id_telefono PK, id_paciente FK, numero_telefono, etiqueta)` separada para cumplir 1FN. |
| **Generalización → tabla única con discriminador** | `Paramedico` y `Conductor` comparten identidad, usuario y disponibilidad en `PersonalOperativo`, variando solo su cargo y habilitación. | Tabla única `personal` con columna discriminadora `tipo_cargo CHECK (tipo_cargo IN ('PARAMEDICO','CONDUCTOR'))`, evitando joins innecesarios en despacho ≤ 2 s. |
