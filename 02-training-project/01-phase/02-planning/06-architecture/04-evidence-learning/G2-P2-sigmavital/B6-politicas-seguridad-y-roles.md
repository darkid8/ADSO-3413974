# B6 · Políticas de Seguridad de Datos y Matriz de Roles — SIGMAVITAL (SGA)

**Autor:** `@darkid8`  
**Marco normativo:** Ley 1581 de 2012 (Habeas Data), Decreto 1074 de 2015, Resolución 3100 de 2017 (REPS), ISO/IEC 27001 y reglas `RNF-001`–`RNF-004`, `RNF-029`, `RN-010`.

---

## 1. Políticas de seguridad de la información (6 políticas concretas: 2 por principio)

| Principio | ID | Política concreta aplicada sobre tablas/columnas de SIGMAVITAL |
|---|---|---|
| **Integridad** | `POL-INT-01` | **Integridad referencial y restricciones de dominio en BD:** Todas las 12 tablas ejecutan llaves primarias, llaves foráneas con acción referencial explícita (`ON DELETE RESTRICT` en `servicio.id_ambulancia`, `servicio.id_solicitud`, `usuario.id_rol`, `ambulancia.id_sede`) y `12 CHECK` que impiden estados inválidos en `ambulancia.tipo_unidad`, `servicio.estado_servicio` y `solicitud_emergencia.prioridad_clinica`. |
| **Integridad** | `POL-INT-02` | **Inmutabilidad *append-only* del registro de auditoría (`RN-010`):** La tabla `auditoria_evento` admite únicamente inserciones (`INSERT`) generadas desde la lógica del backend; se revocan los privilegios `UPDATE` y `DELETE` para todos los roles de aplicación (incluido `Administrador`), garantizando trazabilidad íntegra a 5 años. |
| **Confidencialidad** | `POL-CON-01` | **Credenciales con hash + sal y transporte cifrado TLS (`RNF-001`, `RNF-002`):** La columna `usuario.password_hash` almacena únicamente hashes generados con **hash y sal única (`bcrypt` costo 12 o `Argon2id`)** —nunca contraseñas cifradas reversiblemente ni texto plano—; todo el tráfico entre navegador, API REST y Socket.IO viaja cifrado mediante **TLS 1.3 (`HTTPS :443` / `WSS :443`)**. |
| **Confidencialidad** | `POL-CON-02` | **Tratamiento de datos personales y clínicos (Ley 1581 de 2012 / `RNF-004`):** Los datos de `paciente` (`num_documento`, `nombre_completo`, `antecedentes`) y `telefono_paciente` se recolectan con finalidad exclusiva de atención prehospitalaria y traslado asistencial informada y autorizada por el titular o acudiente (o por urgencia vital legalmente exceptuada); la columna `paciente.antecedentes` se protege con cifrado en reposo `AES-256` y acceso filtrado por RBAC en backend. |
| **Disponibilidad** | `POL-DIS-01` | **Respaldo automático diario externo (`RNF-029`):** Ejecución automatizada diaria a las `02:00 a. m.` mediante `pg_dump` comprimido y cifrado, transferido vía `SFTP :22` a un nodo de almacenamiento externo distinto al servidor principal, con retención mínima de **30 copias consecutivas** (`RPO ≤ 24 h`, `RTO ≤ 4 h`). |
| **Disponibilidad** | `POL-DIS-02` | **Prueba mensual programada de restauración y alta disponibilidad (`RNF-013`, `RNF-015`):** El primer domingo de cada mes se ejecuta una prueba verificada de restauración del respaldo sobre entorno aislado dejando acta de validación de integridad de las 12 tablas; los contenedores Docker aplican `restart: unless-stopped` y *healthchecks* continuos para sostener ≥ `97 %` de disponibilidad. |

---

## 2. Matriz de permisos de roles contra las 12 tablas (`RBAC`)

| Tabla | `Administrador` | `Coordinador Operativo` | `Paramédico` | `Analista Directivo` |
|---|---|---|---|---|
| `rol` | `SELECT, INSERT, UPDATE` | `SELECT` | Sin acceso | Sin acceso |
| `sede` | `SELECT, INSERT, UPDATE` | `SELECT` | `SELECT` | `SELECT` |
| `usuario` | `SELECT, INSERT, UPDATE` *(desactivación lógica)* | `SELECT` *(solo su perfil / tripulación)* | `SELECT` *(solo su perfil)* | `SELECT` *(solo su perfil)* |
| `personal` | `SELECT, INSERT, UPDATE` | `SELECT, UPDATE` *(disponibilidad)* | `SELECT` *(solo su ficha)* | `SELECT` *(estadístico)* |
| `paciente` | `SELECT` *(auditoría)* | `SELECT, INSERT, UPDATE` | `SELECT, UPDATE` *(solo servicios asignados)* | Sin acceso a datos nominales |
| `telefono_paciente` | `SELECT` | `SELECT, INSERT, UPDATE` | `SELECT` *(solo servicios asignados)* | Sin acceso |
| `ambulancia` | `SELECT, INSERT, UPDATE` | `SELECT, UPDATE` *(estado operativo)* | `SELECT` | `SELECT` |
| `documento_ambulancia` | `SELECT, INSERT, UPDATE` | `SELECT` | `SELECT` | `SELECT` |
| `solicitud_emergencia` | `SELECT` | `SELECT, INSERT, UPDATE` | `SELECT` *(solo asignadas)* | `SELECT` *(agregado)* |
| `servicio` | `SELECT` | `SELECT, INSERT, UPDATE` *(asignar/cancelar)* | `SELECT, UPDATE` *(estados y cierre APH)* | `SELECT` *(solo lectura)* |
| `tripulacion_servicio` | `SELECT` | `SELECT, INSERT, UPDATE` | `SELECT` *(solo sus turnos)* | `SELECT` |
| `auditoria_evento` | `SELECT` *(nunca `UPDATE`/`DELETE`)* | Sin acceso | Sin acceso | `SELECT` *(indicadores)* |
