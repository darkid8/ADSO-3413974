# B4 · Diccionario de Datos Completo — SIGMAVITAL (SGA)

**Autor:** `@darkid8`  
**Estándar de nombrado declarado:** Nombres de tablas en **singular** y minúsculas; columnas y restricciones en `snake_case`; llaves primarias nombradas `id_<tabla>`.  
**Cobertura:** **100 % de las 12 tablas** del modelo lógico (`B2`) y **100 % de sus columnas**, alineado en nombres y tipos SQL estándar compatibles con PostgreSQL y SQLite (script `B5`).

| Tabla | Columna | Tipo | Tamaño | Restricciones | Dominio / Regla de negocio |
|---|---|---|---|---|---|
| `rol` | `id_rol` | INTEGER | n/a | PK, NOT NULL | Entero positivo único |
| `rol` | `nombre_rol` | VARCHAR | 50 | NOT NULL, UNIQUE | `ADMIN`, `COORDINADOR`, `PARAMEDICO`, `CONDUCTOR` |
| `rol` | `descripcion` | VARCHAR | 200 | NULL | Descripción de facultades RBAC |
| `rol` | `activo` | INTEGER | n/a | NOT NULL, DEFAULT 1, CHECK (`activo IN (0,1)`) | `1` activo, `0` inactivo |
| `sede` | `id_sede` | INTEGER | n/a | PK, NOT NULL | Entero positivo único |
| `sede` | `nombre_sede` | VARCHAR | 100 | NOT NULL, UNIQUE | Nombre oficial de la base operativa |
| `sede` | `ciudad` | VARCHAR | 80 | NOT NULL | Municipio o ciudad en Colombia |
| `sede` | `direccion` | VARCHAR | 180 | NOT NULL | Dirección física de la sede |
| `usuario` | `id_usuario` | INTEGER | n/a | PK, NOT NULL | Entero positivo único |
| `usuario` | `id_rol` | INTEGER | n/a | FK → `rol(id_rol)`, NOT NULL, ON DELETE RESTRICT | Rol existente en `rol` |
| `usuario` | `nombre_completo` | VARCHAR | 150 | NOT NULL | Nombre del colaborador |
| `usuario` | `correo` | VARCHAR | 180 | NOT NULL, UNIQUE | Correo institucional válido |
| `usuario` | `password_hash` | VARCHAR | 255 | NOT NULL | Hash con sal (`bcrypt`/`Argon2`, `RNF-001`) |
| `usuario` | `intentos_fallidos` | INTEGER | n/a | NOT NULL, DEFAULT 0, CHECK (`intentos_fallidos >= 0 AND intentos_fallidos <= 5`) | Rango `0..5` (`RN-009`) |
| `usuario` | `bloqueado_hasta` | TIMESTAMP | n/a | NULL | Fecha/hora de desbloqueo (`NULL` si libre) |
| `usuario` | `activo` | INTEGER | n/a | NOT NULL, DEFAULT 1, CHECK (`activo IN (0,1)`) | `1` activo, `0` desactivado |
| `personal` | `id_personal` | INTEGER | n/a | PK, NOT NULL | Entero positivo único |
| `personal` | `id_usuario` | INTEGER | n/a | FK → `usuario(id_usuario)`, NOT NULL, UNIQUE, ON DELETE CASCADE | Relación 1:0..1 con `usuario` |
| `personal` | `tipo_cargo` | VARCHAR | 20 | NOT NULL, CHECK (`tipo_cargo IN ('PARAMEDICO','CONDUCTOR')`) | Cargo operativo en campo |
| `personal` | `tarjeta_profesional` | VARCHAR | 40 | NOT NULL, UNIQUE | Registro profesional o licencia |
| `personal` | `vigencia_certificado` | DATE | n/a | NOT NULL | Fecha límite de certificación (`RN-004`) |
| `personal` | `disponible` | INTEGER | n/a | NOT NULL, DEFAULT 1, CHECK (`disponible IN (0,1)`) | `1` disponible, `0` no disponible |
| `paciente` | `id_paciente` | INTEGER | n/a | PK, NOT NULL | Entero positivo único |
| `paciente` | `tipo_documento` | VARCHAR | 10 | NOT NULL, CHECK (`tipo_documento IN ('CC','TI','CE','PA','NN')`) | Tipo de identificación |
| `paciente` | `num_documento` | VARCHAR | 25 | NOT NULL, UNIQUE | Número de documento o código temporal |
| `paciente` | `nombre_completo` | VARCHAR | 150 | NOT NULL | Nombre del paciente |
| `paciente` | `antecedentes` | TEXT | n/a | NULL | Antecedentes clínicos relevantes |
| `telefono_paciente` | `id_telefono` | INTEGER | n/a | PK, NOT NULL | Entero positivo único |
| `telefono_paciente` | `id_paciente` | INTEGER | n/a | FK → `paciente(id_paciente)`, NOT NULL, ON DELETE CASCADE | Paciente propietario del contacto |
| `telefono_paciente` | `numero_telefono` | VARCHAR | 20 | NOT NULL | Teléfono fijo o móvil |
| `telefono_paciente` | `etiqueta` | VARCHAR | 20 | NOT NULL | `PERSONAL`, `FAMILIAR`, `ACUDIENTE` |
| `ambulancia` | `id_ambulancia` | INTEGER | n/a | PK, NOT NULL | Entero positivo único |
| `ambulancia` | `id_sede` | INTEGER | n/a | FK → `sede(id_sede)`, NOT NULL, ON DELETE RESTRICT | Sede base asignada |
| `ambulancia` | `numero_unidad` | VARCHAR | 20 | NOT NULL, UNIQUE | Código interno de unidad (ej. `AMB-01`) |
| `ambulancia` | `placa` | VARCHAR | 10 | NOT NULL, UNIQUE | Placa vehicular única |
| `ambulancia` | `tipo_unidad` | VARCHAR | 3 | NOT NULL, CHECK (`tipo_unidad IN ('TAB','TAM')`) | Modalidad Res. 3100/2017 (`TAB` o `TAM`) |
| `ambulancia` | `estado_operativo` | VARCHAR | 25 | NOT NULL, CHECK (`estado_operativo IN ('DISPONIBLE','EN_SERVICIO','EN_MANTENIMIENTO','FUERA_DE_SERVICIO')`) | Estado operativo en tiempo real (`RN-001`) |
| `documento_ambulancia` | `id_documento` | INTEGER | n/a | PK, NOT NULL | Entero positivo único |
| `documento_ambulancia` | `id_ambulancia` | INTEGER | n/a | FK → `ambulancia(id_ambulancia)`, NOT NULL, ON DELETE CASCADE | Unidad respaldada |
| `documento_ambulancia` | `tipo_documento` | VARCHAR | 30 | NOT NULL, CHECK (`tipo_documento IN ('SOAT','TECNOMECANICA','HABILITACION_REPS')`) | Documento obligatorio (`RN-003`) |
| `documento_ambulancia` | `numero_registro` | VARCHAR | 50 | NOT NULL | Número de póliza o certificado |
| `documento_ambulancia` | `fecha_vencimiento` | DATE | n/a | NOT NULL | Fecha de vigencia (`>=` fecha actual para operar) |
| `solicitud_emergencia` | `id_solicitud` | INTEGER | n/a | PK, NOT NULL | Entero positivo único |
| `solicitud_emergencia` | `id_paciente` | INTEGER | n/a | FK → `paciente(id_paciente)`, NOT NULL, ON DELETE RESTRICT | Paciente atendido |
| `solicitud_emergencia` | `fecha_solicitud` | TIMESTAMP | n/a | NOT NULL | Sello temporal de recepción |
| `solicitud_emergencia` | `direccion_evento` | VARCHAR | 200 | NOT NULL | Dirección o coordenadas del evento |
| `solicitud_emergencia` | `tipo_emergencia` | VARCHAR | 80 | NOT NULL | Clasificación del evento APH |
| `solicitud_emergencia` | `prioridad_clinica` | VARCHAR | 15 | NOT NULL, CHECK (`prioridad_clinica IN ('VERDE','AMARILLO','NARANJA','ROJO')`) | Triage de prioridad (`RF-021`) |
| `servicio` | `id_servicio` | INTEGER | n/a | PK, NOT NULL | Entero positivo único |
| `servicio` | `id_solicitud` | INTEGER | n/a | FK → `solicitud_emergencia(id_solicitud)`, NOT NULL, UNIQUE, ON DELETE RESTRICT | Relación 1:1 con solicitud |
| `servicio` | `id_ambulancia` | INTEGER | n/a | FK → `ambulancia(id_ambulancia)`, NOT NULL, ON DELETE RESTRICT | Ambulancia despachada |
| `servicio` | `estado_servicio` | VARCHAR | 20 | NOT NULL, CHECK (`estado_servicio IN ('SOLICITADO','ASIGNADO','EN_RUTA','EN_ATENCION','TRASLADO','FINALIZADO','CANCELADO')`) | Máquina de estados (`RF-024`) |
| `servicio` | `asignacion_manual` | INTEGER | n/a | NOT NULL, DEFAULT 0, CHECK (`asignacion_manual IN (0,1)`) | `0` automática, `1` manual |
| `servicio` | `motivo_asignacion_manual` | TEXT | n/a | NULL | Obligatorio si `asignacion_manual = 1` (`RN-007`) |
| `servicio` | `hora_asignacion` | TIMESTAMP | n/a | NOT NULL | Instante exacto de despacho |
| `servicio` | `resultado_atencion` | TEXT | n/a | NULL | Obligatorio al cerrar (`RN-005`) |
| `servicio` | `destino_traslado` | VARCHAR | 150 | NULL | IPS receptora o atención en sitio |
| `tripulacion_servicio` | `id_servicio` | INTEGER | n/a | PK, FK → `servicio(id_servicio)`, NOT NULL, ON DELETE CASCADE | Parte de PK compuesta |
| `tripulacion_servicio` | `id_personal` | INTEGER | n/a | PK, FK → `personal(id_personal)`, NOT NULL, ON DELETE RESTRICT | Parte de PK compuesta |
| `tripulacion_servicio` | `rol_operativo` | VARCHAR | 30 | NOT NULL | Rol en el servicio (`PARAMEDICO_LIDER`, `CONDUCTOR`) |
| `tripulacion_servicio` | `hora_asignacion` | TIMESTAMP | n/a | NOT NULL | Marca temporal de vinculación |
| `auditoria_evento` | `id_auditoria` | INTEGER | n/a | PK, NOT NULL | Entero positivo único |
| `auditoria_evento` | `id_usuario` | INTEGER | n/a | FK → `usuario(id_usuario)`, NULL, ON DELETE SET NULL | Usuario actor (`NULL` si evento del sistema) |
| `auditoria_evento` | `modulo` | VARCHAR | 50 | NOT NULL | Módulo afectado |
| `auditoria_evento` | `accion` | VARCHAR | 30 | NOT NULL | `LOGIN`, `BLOQUEO`, `INSERT`, `UPDATE`, `DESPACHO`, `CIERRE` |
| `auditoria_evento` | `entidad_afectada` | VARCHAR | 60 | NOT NULL | Nombre de la tabla afectada |
| `auditoria_evento` | `id_entidad` | INTEGER | n/a | NULL | Identificador del registro afectado |
| `auditoria_evento` | `detalle_json` | TEXT | n/a | NOT NULL | Valores anteriores/posteriores en JSON |
| `auditoria_evento` | `fecha_hora` | TIMESTAMP | n/a | NOT NULL | Registro cronológico inmutable (`RN-010`) |
