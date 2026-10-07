# Hito 4: Automatización de Respaldos en Bash y Programación con Cron

## 🎯 Objetivo
Diseñar e implementar una solución automatizada de copias de seguridad para garantizar la resiliencia y recuperación ante desastres en el servidor Ubuntu (`192.168.233.140`), comprimiendo las configuraciones críticas del sistema y el contenido web, aplicando una política de retención de 7 días y programando su ejecución periódica mediante el demonio `cron`.

---

## 📜 1. Script de Respaldo en Bash (`/usr/local/bin/backup-homelab.sh`)

Se desarrolló un script en Bash ejecutable por el usuario `root` que realiza las siguientes operaciones:
* Garantiza la existencia del directorio objetivo `/var/backups/homelab`.
* Genera un paquete comprimido (`.tar.gz`) etiquetado con marca de tiempo precisa (`YYYY-MM-DD_HHMMSS`).
* Empaqueta los archivos de configuración de seguridad y servicios web:
  * `/etc/ssh/sshd_config` (Configuración del demonio SSH)
  * `/etc/nginx/sites-available` (Virtual Hosts de Nginx)
  * `/etc/fail2ban/jail.local` (Reglas del IPS Fail2ban)
  * `/var/www/homelab` (Archivos fuente del sitio web)
* Registra el estado de la operación en `/var/log/homelab_backup.log`.
* Ejecuta una rutina de rotación que elimina automáticamente backups con antigüedad mayor a 7 días.

### Código del Script:
```bash
#!/bin/bash

# ==============================================================================
# Script de Respaldo Automatizado - Homelab Cybersecurity
# ==============================================================================

# Directorio donde se almacenarán los backups
BACKUP_DIR="/var/backups/homelab"

# Fecha y hora para identificar cada backup
DATE=$(date +%Y-%m-%d_%H%M%S)

# Nombre completo del archivo de backup
BACKUP_FILE="$BACKUP_DIR/homelab_backup_$DATE.tar.gz"

# Archivo de registro
LOG_FILE="/var/log/homelab_backup.log"


# ==============================================================================
# CREAR DIRECTORIO DE BACKUPS
# ==============================================================================

# Asegurar que el directorio de respaldos existe
mkdir -p "$BACKUP_DIR"

echo "[$(date)] Starting Homelab Backup Process..." >> "$LOG_FILE"


# ==============================================================================
# CREAR BACKUP
# ==============================================================================

# Comprimir los archivos de configuración y el sitio web
tar -czf "$BACKUP_FILE" \
    /etc/ssh/sshd_config \
    /etc/nginx/sites-available \
    /etc/fail2ban/jail.local \
    /var/www/homelab \
    2>> "$LOG_FILE"


# ==============================================================================
# COMPROBAR RESULTADO
# ==============================================================================
if [ $? -eq 0 ]; then

    echo "[$(date)] SUCCESS: Backup created at $BACKUP_FILE" >> "$LOG_FILE"


    # ==========================================================================
    # ROTACIÓN DE BACKUPS
    # ==========================================================================

    # Eliminar backups de más de 7 días
    find "$BACKUP_DIR" \
        -type f \
        -name "homelab_backup_*.tar.gz" \
        -mtime +7 \
        -delete \
        2>> "$LOG_FILE"

    echo "[$(date)] Retention policy applied (removed backups older than 7 days)." \
        >> "$LOG_FILE"

else

    echo "[$(date)] ERROR: Backup failed!" >> "$LOG_FILE"

fi
```

**Asignación de Permisos:**
```bash
sudo chmod +x /usr/local/bin/backup-homelab.sh
```

---

## 🧪 2. Pruebas de Ejecución Manual y Registro de Logs

Se ejecutó el script manualmente para verificar el empaquetado, la integridad del archivo resultante y la escritura en la bitácora de eventos.

* **Comando de prueba:**
  ```bash
  sudo /usr/local/bin/backup-homelab.sh
  ```

* **Inspección de archivos generados (`/var/backups/homelab`):**
  ```bash
  ls -lh /var/backups/homelab/
  # Resultado: homelab_backup_2026-10-07_124015.tar.gz (12 KB)
  ```
![[Pasted image 20261007145816.png]]
* **Inspección del registro de bitácora (`/var/log/homelab_backup.log`):**
  ```text
  [mié 07 oct 2026 12:40:15 UTC] Starting Homelab Backup Process...
  [mié 07 oct 2026 12:40:15 UTC] SUCCESS: Backup created at /var/backups/homelab/homelab_backup_2026-10-07_124015.tar.gz
  [mié 07 oct 2026 12:40:15 UTC] Retention policy applied (removed backups older than 7 days).
  ```

---

## ⏰ 3. Programación con el Demonio Cron

Para garantizar la ejecución desatendida del respaldo de forma diaria a las **02:00 AM**, se registró la tarea en la tabla de programación de `root`.

* **Comando de edición:**
  ```bash
  sudo crontab -e
  ```

* **Línea registrada:**
  ```cron
  0 2 * * * /usr/local/bin/backup-homelab.sh
  ```

* **Verificación de la programación:**
  ```bash
  sudo crontab -l
  ```
![[Pasted image 20261007145839.png]]
---

