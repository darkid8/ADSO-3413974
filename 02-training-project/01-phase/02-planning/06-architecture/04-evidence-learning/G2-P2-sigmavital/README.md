# README de entrega · Guía 2: Diseño de la solución

## 1. Datos de la entrega

| Campo | Valor |
|---|---|
| Producto | P2 (modelo de datos y verificación) |
| Usuario de GitHub del autor | `@darkid8` |
| Ficha | 3413974 |
| Caso elegido (nombre del proyecto) | SIGMAVITAL — Sistema de Gestión de Ambulancias (SGA) |
| Enlace al informe de análisis o SRS del caso (ruta en tu fork) | `02-training-project/01-phase/01-analysis/02-requirements/04-evidence-learning/SRS_SIGMAVITAL_SGA.md` |
| Cuenta de GitHub con la que haces los commits | `@darkid8` |

## 2. Origen del insumo y trabajo en equipo

| Pregunta | Respuesta |
|---|---|
| ¿El SRS / informe de análisis lo elaboró un equipo? ¿Cuántas personas? | Sí, el SRS base de SIGMAVITAL fue elaborado por un equipo de 4 aprendices (más el Instructor como Product Owner). |
| ¿Qué parte del SRS es tuya? | `@darkid8` fue el Desarrollador Backend responsable de las tablas núcleo y restricciones de datos. Para esta entrega individual diseño y normalizo el modelo relacional de **12 tablas** que soporta el subconjunto de 14 RF críticos. |
| ¿Los artefactos de esta entrega los hiciste tú solo? | Sí, la transformación conceptual→lógica, la normalización `0FN→3FN`, el diccionario de datos, el script SQL, las políticas y la lista de chequeo son individuales de `@darkid8`. |
| ¿Otro aprendiz usó o te compartió archivos de esta entrega? | No. |

## 3. Qué reutilicé, qué ajusté y qué hice nuevo

| Artefacto | Archivo en esta carpeta | Origen (ruta en mi fork o «nuevo») | Qué ajusté o agregué |
|---|---|---|---|
| B1. Modelo conceptual | `B1-modelo-conceptual.drawio`, `B1-modelo-conceptual.svg`, `B1-modelo-conceptual.md` | `02-training-project/01-phase/01-analysis/02-requirements/04-evidence-learning/SRS_SIGMAVITAL_SGA.md` (§6) y `03-execute/20-week/02-optional-activity/` | Depuré las 23 entidades del SRS a las 9 entidades núcleo prehospitalarias en notación Pata de Gallo con cardinalidad `(mín,máx)` y justificación de BD relacional. |
| B2. Modelo lógico y cuadro de reglas | `B2-modelo-logico.drawio`, `B2-modelo-logico.svg`, `B2-modelo-logico-y-reglas.md` | `SRS_SIGMAVITAL_SGA.md` (§6.2) | Transformé las 9 entidades en 12 tablas relacionales en 3FN agregando tabla intermedia `tripulacion_servicio`, tabla multivaluada `telefono_paciente`, tabla `sede` y cuadro formal de reglas de transformación. |
| B3. Evidencia de normalización | `B3-normalizacion.md` | Nuevo | Documenté paso a paso `0FN → 1FN → 2FN → 3FN` con dependencias funcionales escritas para 2 tablas propias (`despacho_tripulacion_0fn` con llave compuesta y `ficha_ambulancia_sede_0fn` con dependencia transitiva). |
| B4. Diccionario de datos | `B4-diccionario-datos.md` | `SRS_SIGMAVITAL_SGA.md` (§6.2) | Completé el 100 % de las 12 tablas y todas sus columnas con estándar `snake_case`, tipos, tamaños, restricciones `CHECK`/`FK`/`ON DELETE` y dominios. |
| B5. Script SQL y evidencia | `B5-schema-sigmavital.sql`, `B5-evidencia-ejecucion.log`, `B5-evidencia-ejecucion.md` | Nuevo | Implementé el DDL completo de las 12 tablas (`12 CHECK`, `11 FK` con `ON DELETE`) y lo ejecuté sin errores en `SQLite 3`. |
| B6. Políticas de seguridad y roles | `B6-politicas-seguridad-y-roles.md` | Nuevo | Definí 6 políticas concretas (integridad, confidencialidad con hash+sal y TLS + Ley 1581/2012, disponibilidad con respaldo diario y prueba mensual) y matriz de 4 roles × 12 tablas. |
| B7. Lista de chequeo diligenciada | `B7-lista-chequeo-verificacion.md` | Nuevo | Evalué 24 criterios medibles con severidad sobre P1 y P2, registrando y corrigiendo 4 hallazgos (`H-01` a `H-04`). |

**Qué reutilicé (resumen en 3 a 5 líneas):**
Partí del listado de entidades y diccionario parcial de la sección 6 del `SRS_SIGMAVITAL_SGA.md` y de la práctica previa de MER de la semana 20 (`03-execute/20-week/02-optional-activity/`).

**Qué ajusté para llevarlo al estándar de la rúbrica (resumen en 3 a 5 líneas):**
Eliminé tablas de módulos excluidos (financiero/PQRS/proveedores), separé el atributo multivaluado de teléfonos de pacientes en `telefono_paciente`, extraje `sede` para eliminar la dependencia transitiva en `ambulancia` y estandaricé todas las restricciones `CHECK` y `ON DELETE` para garantizar compatibilidad real en `B5`.

**Qué hice completamente nuevo (resumen en 3 a 5 líneas):**
Elaboré el cuadro formal de reglas de transformación, las demostraciones paso a paso `0FN → 3FN` de dos tablas propias, el diccionario al 100 %, el script SQL verificado en motor real con datos de prueba, las 6 políticas de seguridad con matriz de roles y la lista de chequeo de 24 criterios sobre P1 y P2.

## 4. Autoverificación de mínimos

**Si es P2:**
- [x] B1 Modelo conceptual: ≥ 6 entidades (9 entidades), cardinalidades, ≥ 1 N:M y ≥ 1 1:N
- [x] B2 Modelo lógico: ≥ 8 tablas (12 tablas) con PK/FK y cuadro de reglas de transformación
- [x] B3 Normalización: ≥ 2 tablas de 0FN a 3FN con dependencias funcionales (llave compuesta + dependencia transitiva)
- [x] B4 Diccionario de datos completo (100 % de tablas y columnas)
- [x] B5 Script SQL ejecutado sin errores (evidencia adjunta) y `ON DELETE` en ≥ 3 FK (`11` FK y `12 CHECK`)
- [x] B6 ≥ 6 políticas de seguridad (con hash y sal en contraseñas y TLS) y matriz de ≥ 3 roles (`4` roles)
- [x] B7 Lista de chequeo de ≥ 20 criterios (`24` criterios), diligenciada sobre P1 y P2, con evidencia

## 5. Historial de commits

| Día | Qué avancé (mensaje del commit) |
|---|---|
| `2026-11-26` (Día 1) | `feat(g2-p2): estructurar modelos conceptual B1, logico B2, normalizacion 3FN B3 y diccionario B4` ([`f06fcfd`](https://github.com/darkid8/ADSO-3413974/commit/f06fcfd)) |
| `2026-11-27` (Día 2) | `feat(g2-p2): implementar script SQL B5 verificado, politicas B6 y lista de chequeo B7` ([`b88fbd0`](https://github.com/darkid8/ADSO-3413974/commit/b88fbd0)) |

## 6. Uso de inteligencia artificial (declaración obligatoria)

| Herramienta | Para qué la usé | Qué verifiqué o cambié después |
|---|---|---|
| Asistente IA (Antigravity) | Apoyo en estructuración tabular del diccionario de datos, revisión de dependencias funcionales, redacción SQL y generación XML `.drawio` / `.svg`. | Verifiqué manualmente que cada columna de `B4` coincida 100 % con `B2` y `B5`, ejecuté el script SQL en `sqlite3.exe` comprobando `0` errores y validé las políticas `B6` contra la Ley 1581/2012. |

## 7. Enlaces

- Informe de análisis / SRS del caso: `02-training-project/01-phase/01-analysis/02-requirements/04-evidence-learning/SRS_SIGMAVITAL_SGA.md`
- Carpeta de esta entrega en GitHub: `https://github.com/darkid8/ADSO-3413974/tree/main/02-training-project/01-phase/02-planning/06-architecture/04-evidence-learning/G2-P2-sigmavital`
- Enlaces internos: [B1 Conceptual](./B1-modelo-conceptual.md) · [B2 Lógico](./B2-modelo-logico-y-reglas.md) · [B3 Normalización](./B3-normalizacion.md) · [B4 Diccionario](./B4-diccionario-datos.md) · [B5 SQL](./B5-schema-sigmavital.sql) · [B5 Evidencia](./B5-evidencia-ejecucion.md) · [B6 Seguridad](./B6-politicas-seguridad-y-roles.md) · [B7 Verificación](./B7-lista-chequeo-verificacion.md)

## 8. Declaración de autoría

Declaro que los artefactos de esta carpeta son de mi autoría, que lo que reutilicé de mi trabajo del año o de otras fuentes está indicado en la sección 3, que no entregué como propio material del instructor ni de otros aprendices, y que puedo explicar cada artefacto en la verificación oral.

Usuario de GitHub: `@darkid8` · Fecha: `2026-11-27`
