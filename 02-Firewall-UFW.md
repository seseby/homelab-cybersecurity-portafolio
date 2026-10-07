# Hito 2: Configuración Granular del Firewall (UFW)

## 🎯 Objetivo
Implementar una política de seguridad perimetral basada en el principio de mínimo privilegio en el servidor Ubuntu (`192.168.233.140`), denegando todo el tráfico entrante no solicitado y habilitando únicamente los puertos indispensables para la administración remota (SSH) y el servicio web (HTTP).

---

## ⚙️ 1. Política por Defecto y Reglas de Tráfico
Se estableció una postura defensiva por defecto (*Default Deny*) para el tráfico entrante, permitiendo únicamente las conexiones salientes requeridas para actualizaciones del sistema y resolución de nombres.

* **Política global aplicada:**
  * **Tráfico Entrante (Incoming):** `deny` (Denegar todo por defecto)
  * **Tráfico Saliente (Outgoing):** `allow` (Permitir todo por defecto)
  * **Tráfico Enrutado (Routed):** `disabled`

* **Comandos de configuración ejecutados:**
  ```bash
  sudo ufw default deny incoming
  sudo ufw default allow outgoing
  sudo ufw allow 22/tcp
  sudo ufw allow 80/tcp
  sudo ufw enable
  ```

---

## 🔍 2. Auditoría y Estado Actual del Firewall
Se auditó la activación del demonio UFW y las reglas mediante el comando de diagnóstico `sudo ufw status verbose`.

### Estado del Demonio y Registro de Eventos:
* **Estado:** `active`
* **Nivel de Registro (Logging):** `on (low)` (Registra paquetes bloqueados e intentos de conexión en `/var/log/ufw.log`).

### Tabla de Reglas Activas:

| Puerto / Protocolo | Acción | Origen | Propósito / Servicio |
| :--- | :--- | :--- | :--- |
| `22/tcp` | `ALLOW IN` | `Anywhere` | Administración remota por SSH |
| `80/tcp` | `ALLOW IN` | `Anywhere` | Tráfico HTTP (Servidor Nginx) |
| `22/tcp (v6)` | `ALLOW IN` | `Anywhere (v6)` | Soporte SSH sobre IPv6 |
| `80/tcp (v6)` | `ALLOW IN` | `Anywhere (v6)` | Soporte HTTP sobre IPv6 |

---

## 🧪 3. Verificación de Conectividad y Filtrado
1. **Comprobación de servicios permitidos:**
   * Conexión SSH activa y funcional desde el cliente en el puerto `22/tcp`.
   * Petición HTTP atendida por Nginx en el puerto `80/tcp`.
2. **Filtrado de puertos no autorizados:**
   * Todo intento de conexión hacia servicios o puertos no declarados explícitamente es bloqueado automáticamente por la política *default deny*.

---

## 📝 4. Comandos de Mantenimiento y Diagnóstico
```bash
# Consultar reglas enumeradas para gestión o eliminación
sudo ufw status numbered

# Monitorear eventos del firewall en tiempo real
sudo tail -f /var/log/ufw.log
```
