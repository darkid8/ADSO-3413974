# B3 · Evidencia de Normalización Paso a Paso (`0FN → 3FN`) — SIGMAVITAL (SGA)

**Autor:** `@darkid8`  
**Alcance:** Normalización completa de **2 tablas propias** del modelo de SIGMAVITAL: (1) una tabla transaccional con **llave compuesta** (`2FN`) y (2) una tabla maestra con **dependencia transitiva** (`3FN`).

---

## Caso 1 · Tabla con llave compuesta: `despacho_tripulacion_0fn`

### Estado inicial (`0FN`)
`despacho_tripulacion_0fn(id_servicio, id_personal, estado_servicio, id_ambulancia, placa_ambulancia, nombre_personal, tipo_cargo, telefonos_contacto_paciente, rol_operativo, hora_asignacion)`  
- **Llave primaria compuesta:** `(id_servicio, id_personal)`
- **Problema inicial:** `telefonos_contacto_paciente` almacena varios números separados por coma en una misma celda (p. ej. `"3001112233, 3104445566"`).

### Paso 1: `0FN → 1FN` (Eliminar grupos repetitivos y atributos no atómicos)
- **Violación detectada:** `telefonos_contacto_paciente` no es atómico.
- **Transformación:** Se extrae el atributo multivaluado a la tabla independiente `telefono_paciente(id_telefono PK, id_paciente FK, numero_telefono, etiqueta)`.
- **Estado en 1FN:** `despacho_tripulacion_1fn(id_servicio, id_personal, estado_servicio, id_ambulancia, placa_ambulancia, nombre_personal, tipo_cargo, rol_operativo, hora_asignacion)` con PK `(id_servicio, id_personal)`.

### Paso 2: `1FN → 2FN` (Eliminar dependencias funcionales parciales sobre llave compuesta)
- **Dependencias funcionales (DF) escritas:**
  - `DF1 (completa): (id_servicio, id_personal) → rol_operativo, hora_asignacion`
  - `DF2 (parcial sobre id_servicio): id_servicio → estado_servicio, id_ambulancia, placa_ambulancia`
  - `DF3 (parcial sobre id_personal): id_personal → nombre_personal, tipo_cargo`
- **Violación detectada:** `estado_servicio`, `id_ambulancia`, `placa_ambulancia` dependen únicamente de `id_servicio` (no de toda la llave compuesta), y `nombre_personal`, `tipo_cargo` dependen únicamente de `id_personal`.
- **Transformación:** Se separan los atributos que dependen de una sola parte de la llave en sus entidades propias.
- **Estado en 2FN:**
  - `tripulacion_servicio(id_servicio PK/FK, id_personal PK/FK, rol_operativo, hora_asignacion)` *(sin dependencias parciales)*
  - `servicio_2fn(id_servicio PK, estado_servicio, id_ambulancia, placa_ambulancia)`
  - `personal(id_personal PK, nombre_personal, tipo_cargo)` *(enlazado a `usuario`)*

### Paso 3: `2FN → 3FN` (Eliminar dependencias funcionales transitivas)
- **Dependencias funcionales (DF) en `servicio_2fn`:**
  - `DF4: id_servicio → id_ambulancia`
  - `DF5 (transitiva): id_ambulancia → placa_ambulancia` (por tanto `id_servicio → id_ambulancia → placa_ambulancia`)
- **Violación detectada:** El atributo no clave `placa_ambulancia` depende de otro atributo no clave (`id_ambulancia`), generando redundancia y anomalías de actualización si cambia la unidad o su placa.
- **Transformación:** Se mueve `placa_ambulancia` a la tabla `ambulancia` dejando solo la FK `id_ambulancia` en `servicio`.
- **Estado final en 3FN:**
  - `tripulacion_servicio(id_servicio PK/FK, id_personal PK/FK, rol_operativo, hora_asignacion)`
  - `servicio(id_servicio PK, id_solicitud FK UQ, id_ambulancia FK, estado_servicio, ...)`
  - `ambulancia(id_ambulancia PK, id_sede FK, placa, ...)`
  - `personal(id_personal PK, id_usuario FK UQ, tipo_cargo, ...)`

---

## Caso 2 · Tabla con dependencia transitiva: `ficha_ambulancia_sede_0fn`

### Estado inicial (`0FN`)
`ficha_ambulancia_sede_0fn(id_ambulancia, numero_unidad, placa, tipo_unidad, id_sede, nombre_sede, ciudad_sede, direccion_sede, documentos_vigentes)`  
- **Llave primaria:** `id_ambulancia`
- **Problema inicial:** `documentos_vigentes` agrupa en un solo campo varios documentos separados por punto y coma (`"SOAT-101 (2027-05); RTM-202 (2027-02)"`).

### Paso 1: `0FN → 1FN` (Atomicidad y eliminación de listas)
- **Violación detectada:** `documentos_vigentes` es un grupo repetitivo en una sola columna.
- **Transformación:** Se crea la tabla hija `documento_ambulancia(id_documento PK, id_ambulancia FK, tipo_documento, numero_registro, fecha_vencimiento)`.
- **Estado en 1FN:** `ambulancia_sede_1fn(id_ambulancia PK, numero_unidad, placa, tipo_unidad, id_sede, nombre_sede, ciudad_sede, direccion_sede)`.

### Paso 2: `1FN → 2FN` (Verificación de llave simple)
- **Dependencias funcionales (DF) escritas:**
  - `DF1: id_ambulancia → numero_unidad, placa, tipo_unidad, id_sede, nombre_sede, ciudad_sede, direccion_sede`
- **Verificación:** Al tener llave primaria simple (`id_ambulancia`), no existen dependencias parciales. La tabla cumple **2FN**.

### Paso 3: `2FN → 3FN` (Eliminar dependencia transitiva hacia sede)
- **Dependencias funcionales (DF) escritas:**
  - `DF2: id_ambulancia → id_sede`
  - `DF3 (transitiva): id_sede → nombre_sede, ciudad_sede, direccion_sede`
  - Por transitividad: `id_ambulancia → id_sede → nombre_sede, ciudad_sede, direccion_sede`
- **Violación detectada:** Los atributos `nombre_sede`, `ciudad_sede` y `direccion_sede` no describen a la ambulancia directamente sino a la `sede` (`id_sede`), un atributo no clave. Si una sede cambia de dirección, habría que actualizar múltiples filas de ambulancias.
- **Transformación:** Se extrae la entidad `sede` con su llave primaria `id_sede` y se mantiene únicamente `id_sede` como llave foránea en `ambulancia`.
- **Estado final en 3FN:**
  - `sede(id_sede PK, nombre_sede, ciudad, direccion)`
  - `ambulancia(id_ambulancia PK, id_sede FK, numero_unidad, placa, tipo_unidad, estado_operativo)`
  - `documento_ambulancia(id_documento PK, id_ambulancia FK, tipo_documento, numero_registro, fecha_vencimiento)`

**Conclusión de normalización:** Las **12 tablas** del modelo lógico `B2` se encuentran completamente en **3FN**, libres de grupos repetitivos, dependencias parciales y dependencias transitivas.
