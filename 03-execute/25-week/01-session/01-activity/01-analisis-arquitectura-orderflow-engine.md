# Evidencia Semana 25: Análisis Arquitectónico y de Lógica de Negocio — Orderflow Engine

**Programa:** Análisis y Desarrollo de Software (ADSO - Ficha 3413974)  
**Semana:** 25  
**Fecha:** 17 de Octubre de 2026  
**Fase:** 03 - Ejecución (`03-execute/25-week/01-session/01-activity`)  
**Materia/Área:** Arquitectura de Software, Motores Transaccionales y Pruebas Técnicas de Alto Desempeño  
**Objeto de Estudio:** Repositorio de Documentación `orderflow-engine-docs-main` (Prueba Técnica Tech Lead)

---

## 1. Resumen Ejecutivo del Sistema

El proyecto **Orderflow Engine** es un motor de precios (*pricing engine*) y confirmación idempotente de pedidos diseñado para un marketplace B2B de bebidas a gran escala que opera en múltiples países (Colombia, Ecuador, Guatemala y Perú) y múltiples marcas comerciales.

El sistema fue concebido como una solución de nivel **Tech Lead** para resolver un fallo recurrente y crítico de consistencia reportado en sistemas productivos previos:
> *"En tres releases anteriores se reportaron pedidos confirmados a los clientes en la interfaz, pero que posteriormente no aparecían registrados en la base de datos ni en el historial de pedidos (confirmed but missing)."*

Para mitigar este y otros fallos financieros, el sistema se basa en cuatro garantías arquitectónicas innegociables:
1. **G-1 (Total Cotizado = Total Confirmado):** Una cotización se almacena de forma sellada (*insert-only*). El pedido confirmado únicamente referencia la cotización (`quote_id`) y no almacena montos propios ni recalcula precios.
2. **G-2 (Precisión Monetaria Absoluta):** Eliminación total de variables de punto flotante binario (`float`, `double`). Uso estricto de `Money(BigDecimal)` con redondeo a nivel de línea para concordar con la facturación electrónica.
3. **G-3 (Invariante del 201 Created):** La respuesta HTTP `201 Created` solo se serializa y emite **después** de completarse con éxito el `COMMIT` en la base de datos relacional.
4. **G-4 (Efectos Externos Seguros):** Ninguna llamada de red externa (ERP, notificaciones Push) se ejecuta dentro de la transacción SQL. Se emplea el patrón **Transactional Outbox** con deduplicación por `event_id`.

---

## 2. Topología y Arquitectura del Sistema

### 2.1 Enfoque Arquitectónico: Monolito Modular Hexagonal
En lugar de una arquitectura de microservicios distribuida que introduciría transacciones de dos fases (2PC) o complejas sagas para coordinar crédito, cotizaciones y pedidos, la solución opta por un **Monolito Modular con Arquitectura Hexagonal (Ports & Adapters)** respaldado por PostgreSQL:

```
                    ┌────────────────────────────────────────────────────────┐
                    │               orderflow-engine-web                     │
                    │         (Angular Standalone + Nginx Proxy)             │
                    └─────────────────────────┬──────────────────────────────┘
                                              │ HTTP /api/v1/ (Single Origin)
                                              ▼
┌───────────────────────────────────────────────────────────────────────────────────────────┐
│                                  orderflow-engine-api                                     │
│                                                                                           │
│   ┌───────────────────────────────── adapters.in.web ─────────────────────────────────┐   │
│   │  QuotesController · OrdersController · ProductsController · ProblemDetailsAdvice  │   │
│   └─────────────────────────────────────────┬─────────────────────────────────────────┘   │
│                                             │ Invocación de Casos de Uso                  │
│   ┌─────────────────────────────────────────▼─────────────────────────────────────────┐   │
│   │                         Capa de Aplicación (Use Cases)                            │   │
│   │    quoting: CreateQuoteUseCase, GetQuoteUseCase, ListProductsUseCase              │   │
│   │    ordering: ConfirmOrderUseCase (Transaccional ACID), GetOrderUseCase, History   │   │
│   │    outbox: OutboxRelay, RetentionHousekeepingJob                                  │   │
│   └────────────────────┬───────────────────────────────────────┬──────────────────────┘   │
│                        │ Implementa / Consulta                 │ Usa (Dependencia hacia   │
│                        ▼                                       │ el centro)               │
│   ┌──────────────────────────────────────────────┐             │                          │
│   │         pricing.domain (Puro / Core)         │             │                          │
│   │  Money · PricingEngine · Levers (Tier,       │             │                          │
│   │  Combo, Gift) · Tax & Rounding · Breakdown   │             │                          │
│   │  *(Sin dependencias de Spring, DB o Red)*    │             │                          │
│   └──────────────────────────────────────────────┘             │                          │
│                        ▲                                       │                          │
│                        │ Puertos Secundarios (Driven Ports)   │                          │
│   ┌────────────────────┴───────────────────────────────────────▼──────────────────────┐   │
│   │                          adapters.out (Infraestructura)                           │   │
│   │  persistence: JdbcClient Repositories (PostgreSQL con bloqueos explícitos SQL)    │   │
│   │  push / erp: Pasarelas de integración asíncrona desacopladas por el Outbox        │   │
│   └─────────────────────────────────────────┬─────────────────────────────────────────┘   │
└─────────────────────────────────────────────┼─────────────────────────────────────────────┘
                                              ▼
                                 ┌───────────────────────────┐
                                 │     PostgreSQL 17         │
                                 │  (ACID, Locks, Outbox)    │
                                 └───────────────────────────┘
```

### 2.2 Principio de Pureza del Dominio
- El paquete `pricing.domain` solo depende de la biblioteca estándar de Java (JDK).
- Se prohíben anotaciones de frameworks (`@Transactional`, `@Service`), accesos al reloj del sistema no parametrizados o conexiones JDBC dentro del dominio.
- Esta pureza permite ejecutar **Golden Tests deterministas** mediante fixtures JSON reproducibles al 100%.

---

## 3. Funcionamiento de la Capa Web y Frontend (`orderflow-engine-web`)

El frontend está implementado en Angular moderno con componentes Standalone y servido a través de Nginx. Nginx actúa como proxy inverso de `/api/` hacia la API interna, eliminando la necesidad de habilitar CORS en el backend y evitando riesgos de seguridad por orígenes cruzados.

### 3.1 Componentes Defensivos a Nivel de UI
La especificación establece que los problemas de diseño y usabilidad se corrigen en la arquitectura de los componentes base y no pantalla por pantalla:

1. **Prevención de Texto Truncado (`ui-text`):**
   - Prohíbe el uso de elipsis (`text-overflow: ellipsis`) o recorte de líneas (`line-clamp`).
   - Aplica `overflow-wrap: anywhere` y `min-width: 0` en cuadrículas flexibles.
   - Los importes monetarios se colocan en celdas con `flex: none` o `auto`, de modo que los nombres extensos de tiendas o productos se envuelvan verticalmente sin partir jamás una cifra numérica ni ocultar información vital para el tendero.
2. **Prevención de Controles Ocultos por Teclado (`ui-action-bar`):**
   - La barra de confirmación inferior utiliza `100dvh` y se vincula dinámicamente con `visualViewport` y `env(safe-area-inset-bottom)`.
   - Cuando el usuario abre el teclado virtual en su móvil para digitar cantidades, la barra de acción se reposiciona por encima del teclado, evitando que el botón de confirmación quede inaccesible.
3. **Escalamiento Uniforme de Imágenes (`ui-product-image`):**
   - Define un contenedor con propiedad `aspect-ratio` fija y `object-fit: contain`, garantizando que imágenes de botellas, latas o cajas en proporciones heterogéneas se desplieguen sin deformación, con respaldo a placeholder SVG local si la imagen no carga.
4. **Cliente Tonto en Finanzas (*Dumb Client*):**
   - El frontend **jamás ejecuta operaciones aritméticas ni redondeos monetarios**. Recibe las cantidades formateadas como `string` desde la API y únicamente las presenta mediante una tubería (*pipe*) visual.

### 3.2 Idempotencia en el Cliente
- Al presionar por primera vez "Confirmar pedido", la aplicación web genera un UUID que almacena en el `sessionStorage` local como `Idempotency-Key`.
- El botón de confirmación se deshabilita de inmediato para evitar envíos dobles por pulsaciones rápidas (*double tapping*).
- Si la conexión se interrumpe, se presenta un error 5xx de red o el usuario recarga la página, el cliente reenvía exactamente la misma clave, garantizando que el servidor responda con el pedido existente marcado como `Idempotent-Replayed: true`.

---

## 4. Análisis Crítico: ¿Qué le puede faltar y qué posibles errores técnicos y de lógica de negocio existen?

A pesar del nivel técnico excepcional de la documentación analizada, un examen profundo desde la perspectiva de producción y operaciones de negocio a escala revela vacíos, riesgos y puntos ciegos:

### 4.1 Falta de Reserva y Manejo de Inventario (El Vínculo Faltante)
- **Problema de Lógica de Negocio:** La arquitectura se enfoca exhaustivamente en la cotización sellada y el cupo de crédito, pero **ignora por completo el control y la reserva de existencias (stock/inventario)**.
- **Riesgo Operativo:** Un cliente puede cotizar 200 cajas de cerveza con un TTL de 15 minutos. En el minuto 14, otro comprador adquiere el inventario remanente en el almacén físico. Cuando el primer cliente presiona "Confirmar", el motor genera exitosamente la orden (`201 Created`), pero cuando el evento llega al ERP mediante el Outbox, el distribuidor físico ya no cuenta con mercancía para despachar. Se asume un compromiso comercial y legal no respaldado por la realidad física del almacén.

### 4.2 Ausencia de Revocación de Cotizaciones en Escenarios de Crisis (*Quote Revocation*)
- **Riesgo Financiero:** En el ADR-0001 se asume de manera consciente el riesgo de que un error en la carga de precios (*pricing glitch*) o una fuerte devaluación de divisas se mantendrá activo hasta que caduquen las cotizaciones abiertas (TTL de 15 min).
- **Impacto Real:** En situaciones de compras masivas automatizadas (*bots* o compras coordinadas), 15 minutos representan una ventana suficiente para generar pérdidas económicas de gran magnitud al distribuidor. El sistema carece de un endpoint administrativo de emergencia para revocar de inmediato cotizaciones en estado `OPEN` asociadas a una regla o producto defectuoso.

### 4.3 Cuello de Botella y Contención en Concurrencia de Crédito
- **Punto Crítico Técnico:** La deducción del cupo crediticio se realiza mediante:
  ```sql
  UPDATE credit_accounts 
  SET consumed = consumed + :total 
  WHERE tenant_id = :tenant 
    AND customer_id = :customer 
    AND consumed + :total <= credit_limit;
  ```
- **Limitación:** Este comando adquiere un bloqueo exclusivo de fila en PostgreSQL. Si una gran cadena comercial opera decenas de cajas o sucursales que envían pedidos concurrentes debitando de la misma cuenta matriz, todas las transacciones se serializan en esa única fila. Si el tráfico es alto y el tiempo de espera supera el `lock_timeout`, el sistema responderá con errores `409 IDEMPOTENCY_KEY_IN_PROGRESS`, degradando severamente la experiencia de compra de los clientes más valiosos.

### 4.4 Inconsistencias Fiscales en Devoluciones y Notas de Crédito sobre Combos
- **Conflicto Normativo:** El algoritmo de prorrateo de combos (BR-03) utiliza el método del resto mayor para distribuir el descuento proporcionalmente entre los artículos del paquete para derivar la base imponible de cada producto.
- **Vulnerabilidad de Negocio:** Las legislaciones tributarias de la región (DIAN en Colombia, SUNAT en Perú, SRI en Ecuador) imponen normas muy estrictas sobre la anulación o devolución parcial de promociones empaquetadas. Si el cliente devuelve solo uno de los productos de un combo facturado, el reembolso de la base gravable modificada puede generar saldos fiscales a favor indebidos o penalidades tributarias por distorsión artificial de la tarifa de IVA.

### 4.5 Desfase Asimétrico en Consistencia Eventual ante Rechazos Definitivos del ERP
- **Falla en el Ciclo de Vida del Outbox:** El sistema garantiza consistencia fuerte local (pedido + crédito + outbox en la misma BD) y consistencia eventual hacia el ERP.
- **Escenario Huérfano:** Si el ERP rechaza definitivamente el pedido (error 4xx no recuperable, por ejemplo: cuenta del cliente suspendida en SAP por morosidad externa, o código postal bloqueado por orden judicial), el evento en `outbox_events` pasa a estado `DEAD`.
- **Efecto Secundario Grave:** El pedido permanece en estado `CONFIRMED` en el motor, el crédito del cliente continúa consumido (`consumed`), pero el ERP nunca despachará la mercancía. Al haberse declarado fuera de alcance los mecanismos de cancelación y compensación (*compensating transactions / sagas*), la resolución de estos incidentes queda relegada a engorrosas conciliaciones manuales de base de datos.

---

## 5. Mejoras Sugeridas para la Arquitectura

1. **Incorporación de Inventario en Dos Fases:**
   - Implementar un bloqueo temporal (*soft reservation*) de inventario durante la cotización, con liberación automática si la cotización expira sin confirmarse.
2. **Patrón Saga Compensatoria para Eventos `DEAD` del Outbox:**
   - Diseñar un flujo de compensación que, ante un fallo permanente de integración en el ERP, libere el cupo de crédito retenido en el ledger y transicione el pedido a un estado `REJECTED_BY_DISTRIBUTOR`, notificando al cliente de inmediato.
3. **Mecanismo de Circuit Breaker y Revocación Global:**
   - Agregar una tabla de revocación `quote_revocations (tenant_id, product_id, revoked_at)` que permita invalidar selectivamente cotizaciones abiertas antes de que se confirme una transacción basada en datos erróneos de catálogo.
4. **Desacoplamiento de Saldo para Cuentas de Alto Volumen:**
   - Reemplazar la actualización directa del saldo por un modelo de acumulación basada en eventos (*event-sourced balance*) o cuentas de sub-crédito por sucursal para mitigar la contención de bloqueos de fila.

---

## 6. Conclusión de la Evidencia

La carpeta `orderflow-engine-docs-main` representa un estándar sobresaliente en diseño de software empresarial, combinando especificación formal, pruebas de mutación (PIT al 100%), trazabilidad de requerimientos y aislamiento transaccional limpio. 

No obstante, al llevar este diseño a un ecosistema de producción B2B en vivo, los desafíos prioritarios no residirán en la aritmética de precios, sino en la interacción entre la consistencia del pedido, la disponibilidad física del stock y la resiliencia operativa frente a los sistemas heredados (ERP/WMS).
