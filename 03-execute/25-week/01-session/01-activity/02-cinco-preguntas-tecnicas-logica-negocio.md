# Evidencia Semana 25: 5 Preguntas Técnicas y de Lógica de Negocio — Orderflow Engine

**Programa:** Análisis y Desarrollo de Software (ADSO - Ficha 3413974)  
**Semana:** 25  
**Fecha:** 17 de Octubre de 2026  
**Fase:** 03 - Ejecución (`03-execute/25-week/01-session/01-activity`)  
**Materia/Área:** Evaluación de Arquitectura, Lógica de Negocio y Reglas Críticas en Sistemas Transaccionales  
**Fuente de Estudio:** `orderflow-engine-docs-main`

---

## Introducción

Las siguientes cinco preguntas técnicas y de lógica de negocio están orientadas a evaluar en profundidad el funcionamiento del sistema, cuestionar sus supuestos subyacentes y analizar cómo responde la arquitectura ante situaciones límite del mundo real. 

No son preguntas triviales ni teóricas básicas; son cuestionamientos de nivel **Tech Lead / Arquitecto de Software** que abordan los vacíos entre la teoría de la especificación y los desafíos operativos de una plataforma de comercio electrónico mayorista B2B.

---

### Pregunta 1: Desfase entre la Cotización Sellada y la Disponibilidad Física de Inventario (Stock)

#### Contexto en la Documentación
La especificación establece como garantía primordial la **G-1: "El total cotizado es el total confirmado"**, respaldado por cotizaciones selladas de solo inserción con un tiempo de vida (TTL) de 15 minutos. Sin embargo, en el alcance (SPEC §1) el inventario físico no forma parte del modelo relacional ni de la validación de la cotización.

#### La Pregunta
> **¿Cómo resuelve la arquitectura de Orderflow Engine el escenario donde un cliente cotiza con éxito productos con alta rotación comercial y, al intentar confirmarlos 14 minutos después, el almacén físico del distribuidor ya no cuenta con existencias suficientes? Dado que el motor emite un HTTP 201 Created y deduce el cupo de crédito antes de que el ERP procese el pedido de forma asíncrona, ¿cuál es el impacto comercial y legal, y cómo debería evolucionar la arquitectura para evitar compromisos de entrega no ejecutables?**

#### Análisis y Solución de Negocio
- **Falla Actual:** El motor confirma el pedido y asegura al tendero que su compra fue procesada (`confirmed`), descontando su cupo crediticio. Sin embargo, cuando el evento del Outbox llega al ERP, el sistema central rechaza el despacho por falta de stock (*stockout*). Esto reproduce exactamente una variante del defecto que el sistema buscaba resolver: para el cliente el pedido existe y le fue cobrado, pero para el distribuidor físico el pedido no puede entregarse.
- **Respuesta Técnica Recomendada:**
  1. Debe implementarse un mecanismo de **Reserva Suave de Inventario (*Soft Allocation / Two-Phase Inventory*)** en el momento en que se genera la cotización (`POST /api/v1/quotes`), vinculando una reserva temporal con el mismo TTL de 15 minutos.
  2. Si el cliente confirma la orden, la reserva pasa a estado comprometido definitivo en la misma transacción ACID de confirmación.
  3. Si la cotización expira sin confirmarse, el proceso de limpieza (*housekeeping*) o un evento programado libera automáticamente el stock retenido hacia el catálogo general.

---

### Pregunta 2: Manejo de Eventos Muertos en el Outbox (`DEAD`) y Ausencia de Sagas Compensatorias

#### Contexto en la Documentación
En el flujo de la confirmación (SPEC §7.4), los efectos secundarios hacia el ERP y notificaciones Push se gestionan mediante el patrón **Transactional Outbox**. Si el ERP falla por errores recuperables, se aplican reintentos exponenciales con fluctuación (*jitter*). Sin embargo, tras agotar los intentos máximos o recibir un error 4xx no reintentable del ERP, el evento pasa irreversiblemente al estado `DEAD` y se incrementa la métrica `outbox_dead`.

#### La Pregunta
> **Si un evento del Outbox transiciona al estado `DEAD` debido a un rechazo permanente en el ERP (por ejemplo, el cliente fue suspendido legalmente por la autoridad fiscal o el producto fue retirado del mercado por regulación sanitaria), el pedido ya fue marcado como `CONFIRMED` en la base de datos y el crédito del cliente fue consumido en el ledger. ¿Por qué la falta de un mecanismo de compensación transaccional (Saga Compensatoria) representa una vulnerabilidad operativa crítica y qué procedimiento estructurado se requiere para sanear el estado del sistema?**

#### Análisis y Solución de Negocio
- **Falla Actual:** El supuesto **A-09** (*"Cancellation and credit release are out of scope"*) deja al sistema en un estado inconsistente en casos de borde. El cliente visualiza el pedido como confirmado en la pantalla de "Mis Pedidos" y su cupo disponible disminuyó de forma irrevocable, pero el pedido nunca llegará a su negocio.
- **Respuesta Técnica Recomendada:**
  1. Implementar el patrón **Saga con Transacciones Compensatorias**. Al detectarse una transición a `DEAD` con causa de negocio definitiva, debe dispararse automáticamente un evento de compensación:
     ```sql
     -- Transacción compensatoria de reversión
     INSERT INTO credit_ledger (tenant_id, order_id, amount, movement_type) 
     VALUES (:tenant, :order, -:total, 'COMPENSATION_RELEASE');
     
     UPDATE credit_accounts 
     SET consumed = consumed - :total 
     WHERE tenant_id = :tenant AND customer_id = :customer;
     
     UPDATE orders 
     SET status = 'REJECTED_ERP_FAILURE' 
     WHERE id = :orderId;
     ```
  2. Publicar una notificación de corrección al cliente informando la no procedencia de la orden y reponiendo de inmediato su capacidad de compra.

---

### Pregunta 3: Contención Concurrente en Bloqueos de Fila de Cuentas de Crédito

#### Contexto en la Documentación
El modelo de datos y el flujo transaccional de confirmación (SPEC §7.1 y DATA-MODEL §8) imponen un orden estricto de adquisición de bloqueos:
$$\text{idempotency\_key} \longrightarrow \text{quote} \longrightarrow \text{credit\_account}$$
La deducción del crédito se realiza mediante un `UPDATE` condicional directo sobre la columna `consumed` de la tabla `credit_accounts`.

#### La Pregunta
> **¿Qué ocurre cuando una gran cadena de minimercados o una franquicia con múltiples puntos de venta sincronizados opera bajo una misma cuenta corporativa de crédito y envía decenas de confirmaciones por segundo simultáneamente? ¿Por qué la serialización a nivel de fila en PostgreSQL provoca tiempos de espera que pueden derivar en un `409 IDEMPOTENCY_KEY_IN_PROGRESS` y cómo podría optimizarse el modelo para permitir alto rendimiento de confirmaciones concurrentes?**

#### Análisis y Solución de Negocio
- **Falla Actual:** Cada confirmación que paga a crédito debe adquirir un bloqueo exclusivo (`X-lock`) sobre la misma fila `(tenant_id, customer_id)` de `credit_accounts`. Las demás transacciones deben esperar secuencialmente la finalización del `COMMIT` de la anterior. Ante ráfagas de pedidos, las colas de bloqueo exceden el `lock_timeout`, disparando errores 409 y obligando a los clientes a reintentar.
- **Respuesta Técnica Recomendada:**
  1. **Segmentación de Cupo (*Credit Buckets*):** Dividir el límite de crédito en subcuentas o bolsas asignadas a cada sucursal o terminal.
  2. **Contabilidad en Modo Solo Inserción (*Append-Only Credit Ledger*):** En lugar de bloquear y modificar un acumulador central (`consumed`), registrar únicamente las reservas en el libro mayor (`credit_ledger`) y verificar la disponibilidad calculando saldos mediante ventanas temporales o estructuras de datos en memoria ultrarrápidas con control de concurrencia optimista (*Optimistic Concurrency Control*).

---

### Pregunta 4: Implicaciones Fiscales del Prorrateo de Combos ante Devoluciones Parciales

#### Contexto en la Documentación
La regla de negocio **BR-03 (Combos y Asignación)** establece que el descuento de un paquete promocional se distribuye entre los productos participantes de forma proporcional a su valor bruto utilizando el **método del resto mayor** (*largest remainder method*). El resultado se almacena en `quote_line_adjustments` con el único fin de calcular la base gravable neta de cada línea ([SPEC §3](file:///c:/Users/User/OneDrive/Escritorio/orderflow-engine-docs-main/spec/SPEC.md#L121)).

#### La Pregunta
> **En un pedido de bebidas donde se aplica un combo compuesto por productos con distintas tarifas tributarias (por ejemplo, Gaseosa con IVA del 19% y Snacks con IVA del 5%), ¿cómo garantiza el algoritmo del resto mayor que no existan discrepancias fiscales en la facturación electrónica, y qué contingencia contable y tributaria ocurre si el cliente solicita una devolución o nota de crédito parcial de solo una parte del combo?**

#### Análisis y Solución de Negocio
- **Falla Actual:** El sistema distribuye el descuento a nivel de línea para que:
  $$\text{Total} = \sum \text{Neto Línea} + \sum \text{Impuesto Línea}$$
  Sin embargo, si se autoriza la devolución parcial de un solo producto del combo, el cliente devolvería un bien que fiscalmente se facturó con un precio artificialmente rebajado. Al anular solo esa línea en una nota crédito electrónica ante la autoridad tributaria (DIAN en Colombia o SUNAT en Perú), se rompe la integridad comercial del paquete indivisible, exponiendo a la empresa a sanciones por evasión involuntaria de impuestos o deducción errónea de IVA.
- **Respuesta Técnica Recomendada:**
  1. La regla de negocio debe exigir **indivisibilidad en devoluciones de combos**: o se devuelve el paquete íntegro con todas sus líneas asociadas al identificador `COMBO:<id>`, o la nota de crédito no puede emitirse de forma automática.
  2. Las líneas del comprobante de venta deben conservar el enlace al identificador original de la regla promocional para auditar la traza del descuento en caso de fiscalización tributaria.

---

### Pregunta 5: Riesgo Financiero por Cotizaciones Selladas en Escenarios de Error Humano o Inflación Severa (*Quote Revocation*)

#### Contexto en la Documentación
El principio de arquitectura **P-02** y la decisión **DEC-07** decretan que una cotización sellada jamás se actualiza ni se recalcula:
> *"A quote is sealed: its lines and discount components are insert-only... A price change applies only to new quotes. Open quotes keep the old price until they expire (TTL 15 minutes)."*
En el documento de decisiones arquitectónicas (ADR-0001), este comportamiento se cataloga como un riesgo aceptado.

#### La Pregunta
> **¿Qué consecuencias financieras enfrenta el negocio si un analista comercial comete un error tipográfico grave en el catálogo (por ejemplo, publica un licor prémium a \$2.500 en lugar de \$250.000) o si ocurre una devaluación abrupta de la moneda local durante una jornada comercial de alta demanda? Si el sistema no dispone de un mecanismo de revocación de cotizaciones abiertas (*Quote Revocation*), ¿cómo se mitiga la exposición al riesgo en los 15 minutos de vigencia de las cotizaciones emitidas antes de la corrección?**

#### Análisis y Solución de Negocio
- **Falla Actual:** Durante los 15 minutos de vida de la cotización, cualquier cliente o script automatizado que haya obtenido una cotización con el precio erróneo puede ejecutar la confirmación (`POST /api/v1/orders`), obligando al sistema por diseño a confirmar el pedido a \$2.500 sin posibilidad de rechazo.
- **Respuesta Técnica Recomendada:**
  1. Diseñar el ciclo de vida de la cotización para soportar un estado explícito de anulación por emergencia:
     $$\text{OPEN} \xrightarrow{\text{revocación administrativa}} \text{REVOKED}$$
  2. Implementar una tabla de **Revocación Global de Precios**:
     ```sql
     CREATE TABLE quote_revocations (
       tenant_id TEXT NOT NULL,
       sku TEXT NULL,
       rule_id TEXT NULL,
       revoked_at TIMESTAMPTZ NOT NULL,
       reason TEXT NOT NULL
     );
     ```
  3. En el paso 2 de la confirmación transaccional (SPEC §7.1), antes de validar la orden, verificar:
     ```sql
     SELECT 1 FROM quote_revocations 
     WHERE tenant_id = :tenant 
       AND revoked_at > :quoteCreatedAt 
       AND (sku IN (:skus) OR rule_id IN (:rules));
     ```
     Si existe coincidencia, rechazar la confirmación con el código HTTP `409 QUOTE_REVOKED`, informando al cliente que los precios han sido actualizados por inconsistencia y obligando a una nueva cotización.

---

## Conclusión

El análisis de estas cinco preguntas demuestra que, si bien la arquitectura de **Orderflow Engine** implementa soluciones magistrales para la idempotencia, el redondeo monetario y el aislamiento de efectos secundarios, los límites del sistema en producción están determinados por su interacción con el mundo físico (inventario), las regulaciones tributarias (notas de crédito) y la gestión de contingencias operativas (revocación y compensación). 

Estas consideraciones resultan esenciales en la formación de un Analista y Desarrollador de Software con proyección a roles de liderazgo técnico.
