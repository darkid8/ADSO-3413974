# A4 · Arquitectura del Software y Decisiones frente a RNF — SIGMAVITAL (SGA)

**Autor:** `@darkid8`  
**Diagramas:** [A4-arquitectura.drawio](./A4-arquitectura.drawio) · [A4-arquitectura.svg](./A4-arquitectura.svg)

---

## 1. Estilo arquitectónico y comunicación entre componentes

SIGMAVITAL adopta una **Arquitectura Cliente-Servidor en 4 Capas Estrictas** complementada con **comunicación orientada a eventos en tiempo real**:
1. **Capa de Presentación (SPA React 18 + Vite + TypeScript):** Renderiza vistas por rol en navegadores de escritorio y tabletas. Se comunica únicamente con la Capa 2 mediante peticiones **API REST JSON sobre `HTTPS (puerto 443)`** y suscripciones **WebSocket (`WSS 443`)**.
2. **Capa de Controladores, Seguridad API y Tiempo Real (Express + Middleware JWT/RBAC + Gateway Socket.IO):** Autentica tokens, aplica RBAC, sanitiza entradas y delega los casos de uso a la Capa 3 sin contener reglas de negocio ni consultas SQL directas.
3. **Capa de Lógica de Negocio y Patrones (Servicios de Dominio):** Ejecuta reglas `RN-001`–`RN-010`, el motor `ServicioDespacho` (`Strategy`) y el publicador de eventos (`Observer`).
4. **Capa de Persistencia (Repositorios + Pool `pg` → PostgreSQL 16):** Única capa autorizada para ejecutar SQL parametrizado sobre PostgreSQL (`TCP 5432` en red privada).

**Regla estricta sin saltos de capa:** La presentación **nunca** accede directamente a la base de datos ni a los repositorios; toda operación atraviesa secuencialmente `Presentación → Controladores/Seguridad → Lógica de Negocio → Persistencia`.

---

## 2. Tabla de decisiones arquitectónicas frente a los RNF

| RNF | Decisión de diseño | Alternativa descartada | Razón del descarte |
|---|---|---|---|
| `RNF-001` Contraseñas con hash + sal | Hashing adaptativo con `bcrypt` (factor de costo ≥ 10) y sal única por usuario en la capa de autenticación; prohibido el cifrado reversible. | Cifrado simétrico AES para contraseñas o hash `SHA-256` simple sin sal. | El cifrado simétrico permite descifrar credenciales si se filtra la clave, y `SHA-256` sin sal es vulnerable a tablas arcoíris y ataques de fuerza bruta por GPU. |
| `RNF-002` Tráfico exclusivo HTTPS/TLS | Proxy inverso Nginx en el nodo de aplicación con certificado `TLS 1.3` (Let's Encrypt), redirección `HTTP 80 → HTTPS 443` y `WSS` para Socket.IO. | Exponer el servidor Node.js directamente por HTTP en puerto 3000 sin TLS. | Expondría tokens JWT, credenciales y datos clínicos de pacientes en texto claro dentro de redes hospitalarias y Wi-Fi de campo. |
| `RNF-004` Protección de datos sensibles (Ley 1581) | Autorización RBAC centralizada en middleware de Capa 2 + cifrado en reposo a nivel de volumen/columna para antecedentes clínicos en PostgreSQL. | Validar permisos RBAC únicamente ocultando menús en el frontend React. | Un usuario malicioso podría invocar directamente los endpoints REST con `curl` o Postman saltándose las validaciones visuales del navegador. |
| `RNF-009` Asignación automática ≤ 2 s | Evaluación en memoria del estado cacheado de flota disponible + consulta indexada en PostgreSQL por `estado_operativo` y `tipo_unidad`, y emisión push por Socket.IO. | Polling HTTP cada 2 segundos desde todos los navegadores cliente contra consultas `JOIN` sin índices. | El polling continuo saturaría el pool de conexiones de PostgreSQL y elevaría la latencia por encima de los 2 segundos bajo carga concurrente. |
| `RNF-013` Disponibilidad mínima 97 % | Empaquetado en contenedores Docker con políticas de reinicio automático (`restart: unless-stopped`), *healthchecks*, monitoreo y respaldo diario automatizado fuera del nodo principal. | Despliegue manual de procesos directamente en el sistema operativo sin contenedores ni *healthchecks*. | Ante un fallo no controlado del proceso Node o actualización de dependencias, la recuperación manual tomaría demasiado tiempo afectando la operación 24/7. |
| *(Estilo)* 4 Capas estrictas | Separación modular `Presentación → Controladores → Negocio → Persistencia` dentro de un monolito modular en contenedores. | Arquitectura de microservicios distribuidos (6+ servicios independientes con broker Kafka). | Para un equipo de 4 desarrolladores y 20+ usuarios concurrentes, los microservicios añaden latencia de red, complejidad operativa y sobrecosto innecesario frente a un monolito modular bien desacoplado. |
