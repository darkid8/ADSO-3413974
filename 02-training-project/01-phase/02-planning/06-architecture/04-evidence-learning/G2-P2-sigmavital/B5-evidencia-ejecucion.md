# B5 · Evidencia de Ejecución del Script SQL — SIGMAVITAL (SGA)

**Autor:** `@darkid8`  
**Script SQL:** [B5-schema-sigmavital.sql](./B5-schema-sigmavital.sql)  
**Log completo de salida:** [B5-evidencia-ejecucion.log](./B5-evidencia-ejecucion.log)

---

## 1. Resumen de verificación en motor real (`SQLite 3` con `PRAGMA foreign_keys = ON`)

- **Estado de ejecución:** `0 errores` (bandera `-bail`, fecha `2026-11-27 08:08:39`).
- **Tablas creadas (`12 / 12`):** `rol`, `sede`, `usuario`, `personal`, `paciente`, `telefono_paciente`, `ambulancia`, `documento_ambulancia`, `solicitud_emergencia`, `servicio`, `tripulacion_servicio`, `auditoria_evento`.
- **Restricciones verificadas:**
  - `12` restricciones `CHECK` (`ck_rol_activo`, `ck_usuario_intentos`, `ck_usuario_activo`, `ck_personal_cargo`, `ck_personal_disp`, `ck_paciente_tdoc`, `ck_amb_tipo`, `ck_amb_estado`, `ck_doc_tipo`, `ck_sol_prioridad`, `ck_srv_estado`, `ck_srv_manual`).
  - `11` llaves foráneas todas con acción referencial `ON DELETE` explícita (`RESTRICT`, `CASCADE` y `SET NULL` en `auditoria_evento`).
  - Integridad referencial y consultas `JOIN` comprobadas con carga sintética de prueba en todas las tablas:
    - `total_tablas_creadas = 12`
    - Servicio `#1` (`TAM-04`, `TAM`, `ROJO`, `ASIGNADO`) enlazado correctamente con `PARAMEDICO_LIDER` y `CONDUCTOR`.
