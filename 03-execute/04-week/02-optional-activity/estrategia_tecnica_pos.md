# Blueprint Técnico: Ecosistema Omnicanal para Retail Mediano
**Proyecto: Sincronización POS-Cloud & Experiencia de Usuario**

## 1. Visión de la Arquitectura
Para garantizar el cumplimiento de los requerimientos de concurrencia (15+ usuarios simultáneos) y la alta disponibilidad del 99.5%, se propone una arquitectura de **Microservicios Desacoplados**.

### 1.1 Stack Tecnológico Recomendado
* **Backend:** Node.js con NestJS (escalabilidad modular).
* **Frontend Web:** React.js con enfoque *Mobile-First*.
* **POS Desktop:** Electron.js (permite ejecución local con sincronización en la nube).
* **Base de Datos:** PostgreSQL para transacciones seguras y Redis para el caché de inventario en tiempo real.

---

## 2. Estrategia de Sincronización de Inventario
Uno de los puntos críticos identificados es la discrepancia de stock entre el punto físico y la web.

| Componente | Mecanismo | Beneficio |
| :--- | :--- | :--- |
| **Webhooks de Venta** | Disparo inmediato tras cada factura en POS. | Evita vender productos agotados en la web. |
| **Batch Update** | Sincronización masiva cada 30 minutos. | Consistencia total de precios y promociones. |
| **Circuit Breaker** | Manejo de fallos en la conexión a internet. | El POS sigue operando aunque se caiga la nube. |

---

## 3. Seguridad y Control de Acceso
Dado que el sistema será operado por 30 empleados con distintos niveles de responsabilidad, se implementará un modelo **RBAC (Role-Based Access Control)**.

* **Nivel Operativo (Cajeros):** Acceso restringido a facturación, apertura/cierre de caja y consulta de precios.
* **Nivel Logístico (Inventario):** Gestión de stock, alertas de umbral mínimo y entrada de mercancía.
* **Nivel Administrativo:** Creación de promociones, reportes financieros y auditoría de sesiones (Timeout de 30 min).

---

## 4. Flujo del Carrito de Cotización (Fase 1)
Basado en que la mayoría de los usuarios prefiere reservar y recoger en tienda:

1. **Selección:** El usuario navega por el catálogo responsivo.
2. **Validación:** El sistema verifica el stock real mediante una API de consulta al POS.
3. **Reserva:** Se genera un código QR único para el cliente.
4. **Pick-up:** El cajero escanea el QR en el POS, el cual precarga la venta para facturación inmediata, optimizando el tiempo de espera.

---

## 5. Roadmap de Implementación Técnica

### Fase A: El Núcleo (Semanas 1-4)
* Modelado de base de datos unificada (Ventas, Inventario, Usuarios).
* Desarrollo del módulo de facturación con soporte para lectura de código de barras (< 1s).

### Fase B: Integración Web (Semanas 5-8)
* Desarrollo del catálogo web sincronizado.
* Implementación del motor de promociones automáticas (2x1, descuentos fijos).

### Fase C: Despliegue y Pruebas (Semanas 9-12)
* Pruebas de carga para asegurar estabilidad con 15 usuarios concurrentes.
* Capacitación al personal del supermercado.
