# Evidencia Semana 25: 5 Preguntas Técnicas y de Lógica de Negocio — Orderflow Engine

**Programa:** Análisis y Desarrollo de Software (ADSO - Ficha 3413974)  
**Semana:** 25  
**Fecha:** 17 de Octubre de 2026  
**Fase:** 03 - Ejecución (`03-execute/25-week/02-optional-activity`)  
**Materia/Área:** Evaluación de Arquitectura, Lógica de Negocio y Reglas Críticas en Sistemas Transaccionales  
**Fuente de Estudio:** `orderflow-engine-docs-main`

---

## Introducción

Las siguientes cinco preguntas técnicas y de lógica de negocio tienen como propósito desafiar la comprensión del aprendiz sobre el funcionamiento interno de **Orderflow Engine**, incentivando un análisis crítico propio del rol de **Tech Lead / Arquitecto de Software**.

A diferencia de cuestionarios teóricos estándar, estas preguntas exploran casos de borde (*edge cases*), inconsistencias del mundo real, restricciones de concurrencia y aspectos regulatorios y fiscales que no están resueltos de forma explícita en la especificación original.

> **Instrucciones para el estudiante:**  
> A continuación se formula cada pregunta acompañada de su **contexto documental** y de una **guía con sugerencias de enfoque**. Utiliza estas pautas y conceptos clave para elaborar y fundamentar tus propias respuestas y propuestas de solución técnica.

---

### Pregunta 1: Desfase entre la Cotización Sellada y la Disponibilidad Física de Inventario (Stock)

#### Contexto en la Documentación
La especificación establece como garantía primordial la **G-1: "El total cotizado es el total confirmado"**, respaldado por cotizaciones selladas de solo inserción con un tiempo de vida (TTL) de 15 minutos. Sin embargo, en el alcance (SPEC §1) el inventario físico no forma parte del modelo relacional ni de la validación de la cotización.

#### La Pregunta
> **¿Cómo resuelve la arquitectura de Orderflow Engine el escenario donde un cliente cotiza con éxito productos con alta rotación comercial y, al intentar confirmarlos 14 minutos después, el almacén físico del distribuidor ya no cuenta con existencias suficientes? Dado que el motor emite un HTTP 201 Created y deduce el cupo de crédito antes de que el ERP procese el pedido de forma asíncrona, ¿cuál es el impacto comercial y legal, y cómo debería evolucionar la arquitectura para evitar compromisos de entrega no ejecutables?**

#### 💡 Sugerencias y Guía de Enfoque para Responder
Para responder a esta pregunta de forma completa, se sugiere estructurar la respuesta considerando los siguientes aspectos:
- **Analizar el problema de coherencia:** Explica la discrepancia entre la promesa comercial que recibe el usuario en pantalla y la realidad del inventario en los almacenes del distribuidor. ¿Qué implicaciones legales o contractuales tiene generar una orden confirmada que luego no se puede despachar?
- **Patrones de reserva temporal de inventario:** Investiga cómo plataformas de alto volumen (e-commerce o aerolíneas) implementan el concepto de *Soft Allocation* (reserva temporal) vs *Hard Allocation* (reserva comprometida).
- **Ciclo de vida sincronizado con el TTL:** Plantea en qué momento del flujo (cotización o confirmación) debería interactuar el motor con el stock y qué debería ocurrir si los 15 minutos de la cotización expiran sin confirmación.
- **Conceptos clave sugeridos para la respuesta:** *Two-Phase Inventory Reservation, TTL de reserva, eventos de expiración, consistencia eventual vs inmediata de stock*.

---

### Pregunta 2: Manejo de Eventos Muertos en el Outbox (`DEAD`) y Ausencia de Sagas Compensatorias

#### Contexto en la Documentación
En el flujo de la confirmación (SPEC §7.4), los efectos secundarios hacia el ERP y notificaciones Push se gestionan mediante el patrón **Transactional Outbox**. Si el ERP falla por errores recuperables, se aplican reintentos exponenciales con fluctuación (*jitter*). Sin embargo, tras agotar los intentos máximos o recibir un error 4xx no reintentable del ERP, el evento pasa irreversiblemente al estado `DEAD` y se incrementa la métrica `outbox_dead`.

#### La Pregunta
> **Si un evento del Outbox transiciona al estado `DEAD` debido a un rechazo permanente en el ERP (por ejemplo, el cliente fue suspendido legalmente por la autoridad fiscal o el producto fue retirado del mercado por regulación sanitaria), el pedido ya fue marcado como `CONFIRMED` en la base de datos y el crédito del cliente fue consumido en el ledger. ¿Por qué la falta de un mecanismo de compensación transaccional (Saga Compensatoria) representa una vulnerabilidad operativa crítica y qué procedimiento estructurado se requiere para sanear el estado del sistema?**

#### 💡 Sugerencias y Guía de Enfoque para Responder
Para formular una respuesta robusta, se recomienda abordar los siguientes puntos:
- **Identificar el estado huérfano:** Describe en qué estado quedan las tablas `orders`, `credit_accounts` y `credit_ledger` frente a la realidad del ERP cuando un evento muere (`DEAD`). ¿Puede el cliente volver a usar ese crédito consumido?
- **El patrón Saga y Transacciones Compensatorias:** Explica cómo funciona una saga orquestada o coreografiada cuando un paso posterior falla de manera no recuperable.
- **Definir la lógica de compensación:** Plantea qué operaciones de base de datos deberían ejecutarse para revertir el saldo de crédito y actualizar el estado de la orden (por ejemplo, crear un movimiento negativo de auditoría en el ledger en vez de un borrado destructivo).
- **Conceptos clave sugeridos para la respuesta:** *Transactional Outbox, Estado DEAD, Transacción Compensatoria, Inmutabilidad del Ledger, Idempotencia de Reversión*.

---

### Pregunta 3: Contención Concurrente en Bloqueos de Fila de Cuentas de Crédito

#### Contexto en la Documentación
El modelo de datos y el flujo transaccional de confirmación (SPEC §7.1 y DATA-MODEL §8) imponen un orden estricto de adquisición de bloqueos:
$$\text{idempotency\_key} \longrightarrow \text{quote} \longrightarrow \text{credit\_account}$$
La deducción del crédito se realiza mediante un `UPDATE` condicional directo sobre la columna `consumed` de la tabla `credit_accounts`.

#### La Pregunta
> **¿Qué ocurre cuando una gran cadena de minimercados o una franquicia con múltiples puntos de venta sincronizados opera bajo una misma cuenta corporativa de crédito y envía decenas de confirmaciones por segundo simultáneamente? ¿Por qué la serialización a nivel de fila en PostgreSQL provoca tiempos de espera que pueden derivar en un `409 IDEMPOTENCY_KEY_IN_PROGRESS` y cómo podría optimizarse el modelo para permitir alto rendimiento de confirmaciones concurrentes?**

#### 💡 Sugerencias y Guía de Enfoque para Responder
Al elaborar la respuesta, se sugiere enfocar el análisis en:
- **Mecanismos de bloqueo en bases de datos:** Analiza qué tipo de bloqueo adquiere el comando `UPDATE ... WHERE customer_id = ...` (bloqueo exclusivo a nivel de fila en PostgreSQL) y cómo se comporta una cola de transacciones concurrentes compitiendo por el mismo registro.
- **Impacto del `lock_timeout`:** Explica por qué una alta contención hace que las transacciones excedan el tiempo límite y qué experimenta el usuario final cuando el sistema arroja el error 409 de concurrencia.
- **Estrategias alternativas de particionamiento de saldo:** Investiga y propone técnicas como la partición del crédito en "bolsas" (*credit buckets / subcuentas* por sucursal) o el uso de saldos agregados basados únicamente en inserciones (*append-only ledger*) con control optimista.
- **Conceptos clave sugeridos para la respuesta:** *Row-Level Locks (X-Lock), Contención de recursos, Lock Timeout, Credit Buckets, Optimistic vs Pessimistic Locking*.

---

### Pregunta 4: Implicaciones Fiscales del Prorrateo de Combos ante Devoluciones Parciales

#### Contexto en la Documentación
La regla de negocio **BR-03 (Combos y Asignación)** establece que el descuento de un paquete promocional se distribuye entre los productos participantes de forma proporcional a su valor bruto utilizando el **método del resto mayor** (*largest remainder method*). El resultado se almacena en `quote_line_adjustments` con el único fin de calcular la base gravable neta de cada línea ([SPEC §3](file:///c:/Users/User/OneDrive/Escritorio/orderflow-engine-docs-main/spec/SPEC.md#L121)).

#### La Pregunta
> **En un pedido de bebidas donde se aplica un combo compuesto por productos con distintas tarifas tributarias (por ejemplo, Gaseosa con IVA del 19% y Snacks con IVA del 5%), ¿cómo garantiza el algoritmo del resto mayor que no existan discrepancias fiscales en la facturación electrónica, y qué contingencia contable y tributaria ocurre si el cliente solicita una devolución o nota de crédito parcial de solo una parte del combo?**

#### 💡 Sugerencias y Guía de Enfoque para Responder
Para responder adecuadamente, orienta la reflexión hacia los siguientes aspectos tributarios y lógicos:
- **El método del resto mayor:** Explica brevemente por qué una división matemática simple genera decimales infinitos o residuos de redondeo y cómo el algoritmo asegura que la suma de bases imponibles más impuestos sea exactamente igual al total cobrado.
- **Diferencia de tarifas de IVA:** Evalúa qué sucede cuando los productos del combo no comparten la misma tasa fiscal. ¿Por qué es obligatorio prorratear el descuento antes de calcular el IVA y no sobre el total consolidado?
- **El dilema de la devolución parcial:** Analiza qué sucede si el cliente devuelve únicamente el snack (gravado al 5%) conservando la gaseosa (al 19%). ¿Debe devolverse al precio de lista o al precio neto prorrateado? ¿Permiten las autoridades tributarias (DIAN, SUNAT, SRI) notas de crédito fraccionadas sobre paquetes promocionales indivisibles?
- **Conceptos clave sugeridos para la respuesta:** *Base Imponible Neta, Largest Remainder Method, Facturación Electrónica por Línea, Notas de Crédito Parciales, Indivisibilidad de Ofertas Comerciales*.

---

### Pregunta 5: Riesgo Financiero por Cotizaciones Selladas en Escenarios de Error Humano o Inflación Severa (*Quote Revocation*)

#### Contexto en la Documentación
El principio de arquitectura **P-02** y la decisión **DEC-07** decretan que una cotización sellada jamás se actualiza ni se recalcula:
> *"A quote is sealed: its lines and discount components are insert-only... A price change applies only to new quotes. Open quotes keep the old price until they expire (TTL 15 minutes)."*
En el documento de decisiones arquitectónicas (ADR-0001), este comportamiento se cataloga como un riesgo aceptado.

#### La Pregunta
> **¿Qué consecuencias financieras enfrenta el negocio si un analista comercial comete un error tipográfico grave en el catálogo (por ejemplo, publica un licor prémium a \$2.500 en lugar de \$250.000) o si ocurre una devaluación abrupta de la moneda local durante una jornada comercial de alta demanda? Si el sistema no dispone de un mecanismo de revocación de cotizaciones abiertas (*Quote Revocation*), ¿cómo se mitiga la exposición al riesgo en los 15 minutos de vigencia de las cotizaciones emitidas antes de la corrección?**

#### 💡 Sugerencias y Guía de Enfoque para Responder
Considera estructurar la propuesta de respuesta alrededor de:
- **Magnitud del riesgo comercial:** Describe cómo la automatización de compras (scripts, bots o difusión masiva en redes) puede explotar una ventana de 15 minutos ante un error de precio (*pricing glitch*).
- **Inmutabilidad vs Necesidad de Intervención:** Explica la disyuntiva entre mantener la garantía G-1 (determinismo y confianza para el cliente) y la supervivencia financiera del negocio ante catástrofes operativas.
- **Propuesta de diseño para la revocación:** Sugiere cómo podría implementarse un mecanismo de invalidación de emergencia (por ejemplo, una tabla de revocación o lista negra de SKUs con marca de tiempo) que se consulte antes de confirmar la orden sin violar la pureza del motor de precios.
- **Códigos de estado y experiencia de usuario:** Define qué código HTTP y qué tipo de mensaje debería recibir el usuario si su cotización fue revocada antes de confirmar (por ejemplo, un HTTP 409 con una acción clara como "Recotizar con precios actualizados").
- **Conceptos clave sugeridos para la respuesta:** *Quote Revocation, Pricing Glitch, Ventana de Exposición (TTL), Circuit Breakers Administrativos, Manejo de Errores RFC 9457*.

---

## Conclusión y Recomendaciones para la Evaluación

Al responder a estas cinco preguntas, el aprendiz debe evitar respuestas de una sola línea o definiciones genéricas. La evaluación busca demostrar capacidad para:
1. Contrastar las decisiones de diseño del documento con los problemas operacionales del comercio real.
2. Identificar riesgos ocultos y proponer patrones arquitectónicos estándar de la industria (Sagas, Reservas de dos fases, Outbox, Concurrencia Optimista).
3. Defender la consistencia de los datos sin descuidar la experiencia del usuario y el cumplimiento legal/tributario.
