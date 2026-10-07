# Hito 02: Configuración de Firewall Perimetral con UFW

## 🎯 Objetivo
Implementar una política de filtrado de tráfico basada en el principio de mínimo privilegio mediante **UFW (Uncomplicated Firewall)** en el servidor Ubuntu (`192.168.233.140`), restringiendo los accesos administrativos exclusivamente a IPs autorizadas y exponiendo de forma segura los servicios web.

---

## 🛡️ 1. Definición de Políticas por Defecto
Se establece una postura de seguridad defensiva por defecto (*Default Deny*), bloqueando todo el tráfico entrante no solicitado y permitiendo las conexiones salientes:

```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
```

---

## 🔒 2. Reglas de Filtrado Específicas

### A. Restricción del Acceso SSH por IP de Origen
En lugar de exponer el puerto administrativo a cualquier origen (`Anywhere`), se aplica el principio de mínimo privilegio restringiendo SSH exclusivamente a la dirección IP de la estación de administración (`192.168.233.136`):

```bash
sudo ufw allow from 192.168.233.136 to any port 22 proto tcp comment "SSH restrictivo desde cliente admin"
```

### B. Apertura de Servicios Web Puertos 80 (HTTP) y 443 (HTTPS)
Para dar servicio web y permitir la redirección automática a HTTPS se habilitan los puertos específicos:

```bash
sudo ufw allow 80/tcp comment "HTTP Web Server"
sudo ufw allow 443/tcp comment "HTTPS Secure Web Server"
```

> **Nota de Diseño:** Se omitió el uso de perfiles genéricos como `Nginx Full` para evitar duplicidad de reglas en la tabla de UFW y mantener un control de auditoría limpio puerto por puerto.

---

## 📊 3. Habilitación y Verificación del Estado

Se activa el firewall y se consulta la tabla de reglas activa:

```bash
sudo ufw enable
sudo ufw status verbose
```

### Tabla de Reglas Activas Obtenida:

```text
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), disabled (routed)
New profiles: skip

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW IN    192.168.233.136
80/tcp                     ALLOW IN    Anywhere
443/tcp                    ALLOW IN    Anywhere
80/tcp (v6)                ALLOW IN    Anywhere (v6)
443/tcp (v6)               ALLOW IN    Anywhere (v6)
```

---

## 🧪 4. Pruebas de Verificación
1. **Desde la IP autorizada (`192.168.233.136`):**
   * Conexión SSH: **Exitosa** (`ssh sebastian@192.168.233.140`).
   * Conexión Web: **Exitosa** (`curl -I http://192.168.233.140`).
2. **Simulación desde IP no autorizada / Escaneo de puertos:**
   * La solicitud al puerto 22 desde cualquier otra dirección IP del segmento es **descartada** (*Filtered/Dropped*) por UFW, previniendo el descubrimiento del servicio SSH.
