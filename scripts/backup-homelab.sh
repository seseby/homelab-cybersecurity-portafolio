#!/bin/bash

# ===========================================================================>
# Script de Respaldo Automatizado - Homelab Cybersecurity
# ===========================================================================>

# Directorio donde se almacenarán los backups
BACKUP_DIR="/var/backups/homelab"

# Fecha y hora para identificar cada backup
DATE=$(date +%Y-%m-%d_%H%M%S)

# Nombre completo del archivo de backup
BACKUP_FILE="$BACKUP_DIR/homelab_backup_$DATE.tar.gz"

# Archivo de registro
LOG_FILE="/var/log/homelab_backup.log"


# ===========================================================================>
# CREAR DIRECTORIO DE BACKUPS
# ===========================================================================>

# Asegurar que el directorio de respaldos existe
mkdir -p "$BACKUP_DIR"

echo "[$(date)] Starting Homelab Backup Process..." >> "$LOG_FILE"


# ===========================================================================>
# CREAR BACKUP
# ===========================================================================>

# Comprimir los archivos de configuración y el sitio web
tar -czf "$BACKUP_FILE" \
    /etc/ssh/sshd_config \
    /etc/nginx/sites-available \
    /etc/fail2ban/jail.local \
    /var/www/homelab \
    2>> "$LOG_FILE"


# ===========================================================================>
# COMPROBAR RESULTADO
# ===========================================================================>

if [ $? -eq 0 ]; then

    echo "[$(date)] SUCCESS: Backup created at $BACKUP_FILE" >> "$LOG_FILE"


    # =======================================================================>
    # ROTACIÓN DE BACKUPS
    # =======================================================================>

    # Eliminar backups de más de 7 días
    find "$BACKUP_DIR" \
        -type f \
        -name "homelab_backup_*.tar.gz" \
        -mtime +7 \
        -delete \
        2>> "$LOG_FILE"

    echo "[$(date)] Retention policy applied (removed backups older than 7 da>
        >> "$LOG_FILE"

else

    echo "[$(date)] ERROR: Backup failed!" >> "$LOG_FILE"

fi