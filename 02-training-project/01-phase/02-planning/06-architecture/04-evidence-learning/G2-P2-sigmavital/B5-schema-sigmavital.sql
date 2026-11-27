-- ============================================================================
-- B5 · Script SQL de Creación y Verificación — SIGMAVITAL (SGA)
-- Autor: @darkid8
-- Alineado 100 % con B2-modelo-logico-y-reglas.md y B4-diccionario-datos.md
-- ============================================================================

PRAGMA foreign_keys = ON;

CREATE TABLE rol (
  id_rol       INTEGER PRIMARY KEY,
  nombre_rol   VARCHAR(50) NOT NULL UNIQUE,
  descripcion  VARCHAR(200),
  activo       INTEGER NOT NULL DEFAULT 1,
  CONSTRAINT ck_rol_activo CHECK (activo IN (0, 1))
);

CREATE TABLE sede (
  id_sede      INTEGER PRIMARY KEY,
  nombre_sede  VARCHAR(100) NOT NULL UNIQUE,
  ciudad       VARCHAR(80) NOT NULL,
  direccion    VARCHAR(180) NOT NULL
);

CREATE TABLE usuario (
  id_usuario         INTEGER PRIMARY KEY,
  id_rol             INTEGER NOT NULL,
  nombre_completo    VARCHAR(150) NOT NULL,
  correo             VARCHAR(180) NOT NULL UNIQUE,
  password_hash      VARCHAR(255) NOT NULL,
  intentos_fallidos  INTEGER NOT NULL DEFAULT 0,
  bloqueado_hasta    TIMESTAMP,
  activo             INTEGER NOT NULL DEFAULT 1,
  CONSTRAINT fk_usuario_rol FOREIGN KEY (id_rol)
    REFERENCES rol (id_rol) ON DELETE RESTRICT,
  CONSTRAINT ck_usuario_intentos CHECK (intentos_fallidos >= 0 AND intentos_fallidos <= 5),
  CONSTRAINT ck_usuario_activo CHECK (activo IN (0, 1))
);

CREATE TABLE personal (
  id_personal           INTEGER PRIMARY KEY,
  id_usuario            INTEGER NOT NULL UNIQUE,
  tipo_cargo            VARCHAR(20) NOT NULL,
  tarjeta_profesional   VARCHAR(40) NOT NULL UNIQUE,
  vigencia_certificado  DATE NOT NULL,
  disponible            INTEGER NOT NULL DEFAULT 1,
  CONSTRAINT fk_personal_usuario FOREIGN KEY (id_usuario)
    REFERENCES usuario (id_usuario) ON DELETE CASCADE,
  CONSTRAINT ck_personal_cargo CHECK (tipo_cargo IN ('PARAMEDICO', 'CONDUCTOR')),
  CONSTRAINT ck_personal_disp CHECK (disponible IN (0, 1))
);

CREATE TABLE paciente (
  id_paciente      INTEGER PRIMARY KEY,
  tipo_documento   VARCHAR(10) NOT NULL,
  num_documento    VARCHAR(25) NOT NULL UNIQUE,
  nombre_completo  VARCHAR(150) NOT NULL,
  antecedentes     TEXT,
  CONSTRAINT ck_paciente_tdoc CHECK (tipo_documento IN ('CC', 'TI', 'CE', 'PA', 'NN'))
);

CREATE TABLE telefono_paciente (
  id_telefono      INTEGER PRIMARY KEY,
  id_paciente      INTEGER NOT NULL,
  numero_telefono  VARCHAR(20) NOT NULL,
  etiqueta         VARCHAR(20) NOT NULL,
  CONSTRAINT fk_tel_paciente FOREIGN KEY (id_paciente)
    REFERENCES paciente (id_paciente) ON DELETE CASCADE
);

CREATE TABLE ambulancia (
  id_ambulancia     INTEGER PRIMARY KEY,
  id_sede           INTEGER NOT NULL,
  numero_unidad     VARCHAR(20) NOT NULL UNIQUE,
  placa             VARCHAR(10) NOT NULL UNIQUE,
  tipo_unidad       VARCHAR(3) NOT NULL,
  estado_operativo  VARCHAR(25) NOT NULL,
  CONSTRAINT fk_amb_sede FOREIGN KEY (id_sede)
    REFERENCES sede (id_sede) ON DELETE RESTRICT,
  CONSTRAINT ck_amb_tipo CHECK (tipo_unidad IN ('TAB', 'TAM')),
  CONSTRAINT ck_amb_estado CHECK (estado_operativo IN ('DISPONIBLE', 'EN_SERVICIO', 'EN_MANTENIMIENTO', 'FUERA_DE_SERVICIO'))
);

CREATE TABLE documento_ambulancia (
  id_documento       INTEGER PRIMARY KEY,
  id_ambulancia      INTEGER NOT NULL,
  tipo_documento     VARCHAR(30) NOT NULL,
  numero_registro    VARCHAR(50) NOT NULL,
  fecha_vencimiento  DATE NOT NULL,
  CONSTRAINT fk_doc_ambulancia FOREIGN KEY (id_ambulancia)
    REFERENCES ambulancia (id_ambulancia) ON DELETE CASCADE,
  CONSTRAINT ck_doc_tipo CHECK (tipo_documento IN ('SOAT', 'TECNOMECANICA', 'HABILITACION_REPS'))
);

CREATE TABLE solicitud_emergencia (
  id_solicitud       INTEGER PRIMARY KEY,
  id_paciente        INTEGER NOT NULL,
  fecha_solicitud    TIMESTAMP NOT NULL,
  direccion_evento   VARCHAR(200) NOT NULL,
  tipo_emergencia    VARCHAR(80) NOT NULL,
  prioridad_clinica  VARCHAR(15) NOT NULL,
  CONSTRAINT fk_sol_paciente FOREIGN KEY (id_paciente)
    REFERENCES paciente (id_paciente) ON DELETE RESTRICT,
  CONSTRAINT ck_sol_prioridad CHECK (prioridad_clinica IN ('VERDE', 'AMARILLO', 'NARANJA', 'ROJO'))
);

CREATE TABLE servicio (
  id_servicio               INTEGER PRIMARY KEY,
  id_solicitud              INTEGER NOT NULL UNIQUE,
  id_ambulancia             INTEGER NOT NULL,
  estado_servicio           VARCHAR(20) NOT NULL,
  asignacion_manual         INTEGER NOT NULL DEFAULT 0,
  motivo_asignacion_manual  TEXT,
  hora_asignacion           TIMESTAMP NOT NULL,
  resultado_atencion        TEXT,
  destino_traslado          VARCHAR(150),
  CONSTRAINT fk_srv_solicitud FOREIGN KEY (id_solicitud)
    REFERENCES solicitud_emergencia (id_solicitud) ON DELETE RESTRICT,
  CONSTRAINT fk_srv_ambulancia FOREIGN KEY (id_ambulancia)
    REFERENCES ambulancia (id_ambulancia) ON DELETE RESTRICT,
  CONSTRAINT ck_srv_estado CHECK (estado_servicio IN ('SOLICITADO', 'ASIGNADO', 'EN_RUTA', 'EN_ATENCION', 'TRASLADO', 'FINALIZADO', 'CANCELADO')),
  CONSTRAINT ck_srv_manual CHECK (asignacion_manual IN (0, 1))
);

CREATE TABLE tripulacion_servicio (
  id_servicio      INTEGER NOT NULL,
  id_personal      INTEGER NOT NULL,
  rol_operativo    VARCHAR(30) NOT NULL,
  hora_asignacion  TIMESTAMP NOT NULL,
  PRIMARY KEY (id_servicio, id_personal),
  CONSTRAINT fk_trip_servicio FOREIGN KEY (id_servicio)
    REFERENCES servicio (id_servicio) ON DELETE CASCADE,
  CONSTRAINT fk_trip_personal FOREIGN KEY (id_personal)
    REFERENCES personal (id_personal) ON DELETE RESTRICT
);

CREATE TABLE auditoria_evento (
  id_auditoria      INTEGER PRIMARY KEY,
  id_usuario        INTEGER,
  modulo            VARCHAR(50) NOT NULL,
  accion            VARCHAR(30) NOT NULL,
  entidad_afectada  VARCHAR(60) NOT NULL,
  id_entidad        INTEGER,
  detalle_json      TEXT NOT NULL,
  fecha_hora        TIMESTAMP NOT NULL,
  CONSTRAINT fk_aud_usuario FOREIGN KEY (id_usuario)
    REFERENCES usuario (id_usuario) ON DELETE SET NULL
);

-- ============================================================================
-- Datos de prueba sintéticos (ficticios) para verificar integridad referencial
-- ============================================================================

INSERT INTO rol (id_rol, nombre_rol, descripcion, activo)
VALUES (1, 'COORDINADOR', 'Coordinador Operativo de Despacho', 1),
       (2, 'PARAMEDICO', 'Personal asistencial APH', 1),
       (3, 'CONDUCTOR', 'Conductor de unidad TAB/TAM', 1);

INSERT INTO sede (id_sede, nombre_sede, ciudad, direccion)
VALUES (1, 'Sede Norte Demo', 'Neiva', 'Calle 10 # 1-00');

INSERT INTO usuario (id_usuario, id_rol, nombre_completo, correo, password_hash, intentos_fallidos, activo)
VALUES (1, 1, 'Coordinador Demo 1', 'coord.demo@sigmavital.local', '$2b$12$saltsinteticohashbcryptdemo000000000000000000001', 0, 1),
       (2, 2, 'Paramedico Demo 1', 'param.demo@sigmavital.local', '$2b$12$saltsinteticohashbcryptdemo000000000000000000002', 0, 1),
       (3, 3, 'Conductor Demo 1', 'cond.demo@sigmavital.local', '$2b$12$saltsinteticohashbcryptdemo000000000000000000003', 0, 1);

INSERT INTO personal (id_personal, id_usuario, tipo_cargo, tarjeta_profesional, vigencia_certificado, disponible)
VALUES (1, 2, 'PARAMEDICO', 'TP-APH-9001', '2027-12-31', 1),
       (2, 3, 'CONDUCTOR', 'LIC-C2-8002', '2027-10-15', 1);

INSERT INTO paciente (id_paciente, tipo_documento, num_documento, nombre_completo, antecedentes)
VALUES (1, 'CC', '1000000001', 'Paciente Prueba Uno', 'Sin alergias conocidas');

INSERT INTO telefono_paciente (id_telefono, id_paciente, numero_telefono, etiqueta)
VALUES (1, 1, '3000000001', 'FAMILIAR');

INSERT INTO ambulancia (id_ambulancia, id_sede, numero_unidad, placa, tipo_unidad, estado_operativo)
VALUES (1, 1, 'TAM-04', 'OKS412', 'TAM', 'DISPONIBLE');

INSERT INTO documento_ambulancia (id_documento, id_ambulancia, tipo_documento, numero_registro, fecha_vencimiento)
VALUES (1, 1, 'HABILITACION_REPS', 'REPS-2026-004', '2027-06-30');

INSERT INTO solicitud_emergencia (id_solicitud, id_paciente, fecha_solicitud, direccion_evento, tipo_emergencia, prioridad_clinica)
VALUES (1, 1, '2026-11-27 08:15:00', 'Carrera 5 # 20-10', 'Trauma severo', 'ROJO');

INSERT INTO servicio (id_servicio, id_solicitud, id_ambulancia, estado_servicio, asignacion_manual, hora_asignacion, resultado_atencion, destino_traslado)
VALUES (1, 1, 1, 'ASIGNADO', 0, '2026-11-27 08:15:01', NULL, NULL);

INSERT INTO tripulacion_servicio (id_servicio, id_personal, rol_operativo, hora_asignacion)
VALUES (1, 1, 'PARAMEDICO_LIDER', '2026-11-27 08:15:01'),
       (1, 2, 'CONDUCTOR', '2026-11-27 08:15:01');

INSERT INTO auditoria_evento (id_auditoria, id_usuario, modulo, accion, entidad_afectada, id_entidad, detalle_json, fecha_hora)
VALUES (1, 1, 'EMERGENCIAS', 'DESPACHO', 'servicio', 1, '{"estado":"ASIGNADO","unidad":"TAM-04"}', '2026-11-27 08:15:01');

-- Consultas de verificación
SELECT COUNT(*) AS total_tablas_creadas FROM sqlite_master WHERE type = 'table';

SELECT s.id_servicio, a.numero_unidad, a.tipo_unidad, sol.prioridad_clinica,
       p.tipo_cargo, ts.rol_operativo, s.estado_servicio
FROM servicio s
JOIN ambulancia a ON a.id_ambulancia = s.id_ambulancia
JOIN solicitud_emergencia sol ON sol.id_solicitud = s.id_solicitud
JOIN tripulacion_servicio ts ON ts.id_servicio = s.id_servicio
JOIN personal p ON p.id_personal = ts.id_personal;
