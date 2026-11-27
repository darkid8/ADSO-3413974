# A6 · Vista de Despliegue — SIGMAVITAL (SGA)

**Autor:** `@darkid8`  
**Diagramas:** [A6-despliegue.drawio](./A6-despliegue.drawio) · [A6-despliegue.svg](./A6-despliegue.svg)

---

## 1. Nodos físicos/virtuales, artefactos y protocolos (`4 nodos + respaldo externo`)

| Nodo | Artefactos que aloja | Conexión (protocolo y puerto) | Decisión que responde a un RNF |
|---|---|---|---|
| **Nodo Cliente** *(Navegador Desktop / Tableta APH)* | Bundle SPA React 18 + Vite (`HTML5`, `JS`, `CSS`) | `HTTPS :443` y `WSS :443` hacia el Proxy Inverso Nginx | `RNF-002`: Todo el tráfico de credenciales, pacientes y estados en tiempo real viaja cifrado con TLS 1.3 sin requerir software nativo (`RST-03`). |
| **Nodo Proxy Inverso** *(Contenedor Nginx TLS)* | `nginx.conf`, certificado `Let's Encrypt TLS 1.3`, compresión Gzip/Brotli | `HTTP :3000` y `WebSocket` en red Docker interna hacia Aplicación | `RNF-002` y `RNF-011`: Terminación SSL centralizada, redirección automática HTTP→HTTPS, cabeceras de seguridad y caché de activos estáticos. |
| **Nodo Servidor de Aplicación** *(Contenedor Node.js 20)* | API REST Express (`JWT`, `RBAC`, `bcrypt`), Motor de Despacho (`Strategy/Observer`), Servidor `Socket.IO` | `TCP :5432` en red privada aislada hacia Nodo de Datos | `RNF-009` y `RNF-013`: Política `restart: unless-stopped`, *healthcheck* `/api/health`, pool de conexiones y evaluación en memoria para despacho ≤ 2 s y disponibilidad ≥ 97 %. |
| **Nodo Servidor de Datos** *(Contenedor PostgreSQL 16)* | Base de datos `sigmavital` (12 tablas 3FN + `auditoria_evento`), script automático `pg_dump` | Solo acepta conexiones desde la IP interna del contenedor Node (`TCP :5432`) | `RNF-004` y `RNF-021`: Puerto `5432` cerrado hacia Internet pública; volumen cifrado en reposo para datos sensibles de pacientes (`Ley 1581/2012`). |
| **Nodo Respaldo Externo** *(Almacenamiento Offsite)* | Copias diarias cifradas (`pg_dump`), retención 30 días | `SFTP :22` cifrado desde el servidor de datos (tarea `cron` diaria) | `RNF-029`: Garantiza recuperación ante desastres con `RPO ≤ 24 h` y `RTO ≤ 4 h` en ubicación distinta al nodo principal. |
