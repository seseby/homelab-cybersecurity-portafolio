# Fase 3: Mitigación de Fuerza Bruta e Intrusiones con Fail2ban

## 🎯 Objetivo
Desplegar y configurar un Sistema de Prevención de Intrusiones (IPS) basado en **Fail2ban** para monitorizar en tiempo real los registros de autenticación (`/var/log/auth.log`), detectar patrones de ataques automatizados de fuerza bruta sobre SSH e inyectar reglas de bloqueo dinámicas en el firewall **UFW**.

---

## ⚙️ 1. Instalación y Configuración de `jail.local`

Se instaló el demonio `fail2ban` y se creó una configuración persistente personalizada en `/etc/fail2ban/jail.local` para evitar que las actualizaciones del paquete sobrescriban los parámetros de seguridad.

### Parámetros Globales y de Jaula (`[DEFAULT]` y `[sshd]`)
```ini
[DEFAULT]
# Tiempo de bloqueo inicial tras sobrepasar el límite
bantime  = 10m

# Ventana de tiempo evaluada para contabilizar fallos
findtime = 10m

# Umbral máximo de reintentos fallidos permitidos
maxretry = 3

# Integración directa con el firewall UFW
banaction = ufw

[sshd]
enabled = true
port    = ssh
logpath = %(sshd_log)s
backend = %(sshd_backend)s
```

**Arranque y verificación del servicio:**
```bash
sudo systemctl enable --now fail2ban
sudo fail2ban-client status
```
![[Pasted image 20261007145521.png]]
---

## 🧪 2. Prueba de Concepto: Simulación de Ataque de Fuerza Bruta

Se realizaron múltiples intentos de inicio de sesión SSH no autorizados desde el cliente cliente/atacante con IP `192.168.233.136`.
![[Pasted image 20261007145541.png]]
### A. Detección y Baneo Automático
Tras sobrepasar los 3 intentos fallidos permitidos, Fail2ban interceptó el evento en `/var/log/auth.log` e inyectó una regla de rechazo dinámico en UFW.

**Estado del servicio durante la intrusión:**
```text
sebastian@ubuntuserver:~$ sudo fail2ban-client status sshd
Status for the jail: sshd
|- Filter
|  |- Currently failed: 1
|  |- Total failed:     4
|  `- File list:        /var/log/auth.log
`- Actions
   |- Currently banned: 1
   |- Total banned:     1
   `- Banned IP list:   192.168.233.136
```

### B. Verificación de la Regla Creada en UFW
```text
sebastian@ubuntuserver:~$ sudo ufw status
Status: active

To                         Action      From
--                         ------      ----
Anywhere                   REJECT      192.168.233.136
22/tcp                     ALLOW       Anywhere
80/tcp                     ALLOW       Anywhere
Nginx Full                 ALLOW       Anywhere
```

---

## 🛠️ 3. Procedimiento de Unban (Resolución de Incidencias)

Para simular la recuperación del servicio ante un falso positivo o tras la resolución de un incidente, se removió manualmente la IP de la lista negra:

```bash
sudo fail2ban-client set sshd unbanip 192.168.233.136
```

**Verificación posterior al desbloqueo:**
```text
Status for the jail: sshd
|- Filter
|  |- Currently failed: 1
|  |- Total failed:     4
|  `- File list:        /var/log/auth.log
`- Actions
   |- Currently banned: 0
   |- Total banned:     1
   `- Banned IP list:
```

---
