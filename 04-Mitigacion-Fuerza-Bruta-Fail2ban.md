# Hito 04: Mitigación de Fuerza Bruta con Fail2ban (H-IPS Basado en Logs)

## 🎯 Objetivo
Implementar un sistema de prevención de intromisiones basado en host (H-IPS reactivo) mediante **Fail2ban** en el servidor Ubuntu (`192.168.233.140`), monitorizando los registros de autenticación en tiempo real para bloquear dinámicamente direcciones IP mediante reglas automáticas en el firewall UFW ante intentos fallidos reiterados.

---

## ⚙️ 1. Instalación y Configuración de Jaula (`jail.local`)

Se instaló el servicio y se creó el archivo de configuración local para evitar que las actualizaciones del paquete sobrescriban los parámetros personalizados:

```bash
sudo apt update && sudo apt install fail2ban -y
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sudo nano /etc/fail2ban/jail.local
```

### Configuración de Parámetros Globales y Jaula SSH (`[sshd]`):

```ini
[DEFAULT]
# Excluir la IP de administración para evitar el autobaneo accidental
ignoreip = 127.0.0.1/8 ::1 192.168.233.136

# Tiempo de bloqueo (10 minutos)
bantime  = 10m
# Ventana de tiempo para contabilizar reintentos
findtime = 10m
# Número máximo de fallos permitidos
maxretry = 3
# Integración directa con UFW
banaction = ufw

[sshd]
enabled = true
port    = ssh
logpath = %(sshd_log)s
backend = %(sshd_backend)s
```

**Reinicio del servicio:**
```bash
sudo systemctl restart fail2ban
```

---

## 🧪 2. Prueba de Concepto: Simulación de Ataque y Análisis de Registros

### A. Ejecución de Ataque Simulado
Dado que la autenticación por contraseña está deshabilitada (`PasswordAuthentication no`), la simulación de intentos fallidos se realizó forzando solicitudes de contraseña sin clave pública o con usuarios inexistentes desde la máquina cliente (`192.168.233.136`):

```bash
ssh -o PubkeyAuthentication=no usuariofalso@192.168.233.140
```
![[Pasted image 20261007191355.png]]
*(Se ejecutaron 4 intentos fallidos consecutivos).*

### B. Inspección del Log de Autenticación (`/var/log/auth.log`)
El servidor registró las anomalías en el log del sistema:

![[imagen15.png]]

---

## 📊 3. Verificación de Baneo Automático en UFW y Desbloqueo Manual

### A. Estado de la Jaula en Fail2ban
```bash
sudo fail2ban-client status sshd
```

![[imagen16.png]]

### B. Inyección Automática de Regla en UFW
Fail2ban inyectó una regla de rechazo dinámico al inicio de la cadena de UFW:

```bash
sudo ufw status
```

![[imagen17.png]]

### C. Procedimiento de Unban (Desbloqueo de Gestión)
Se verificó el procedimiento operativo para levantar el bloqueo administrativo sobre la IP:

```bash
sudo fail2ban-client set sshd unbanip 192.168.233.136
```
![[imagen18.png]]
---

