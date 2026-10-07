# Laboratorio de Ciberseguridad en Ubuntu Server

Laboratorio práctico de ciberseguridad enfocado en hardening de Linux, seguridad de red, seguridad web, prevención de fuerza bruta y automatización de respaldos con pruebas de restauración.

| Parámetro | Detalle |
| :--- | :--- |
| **Estado** | ![Estado](https://img.shields.io/badge/Estado-En_Progreso-yellow) |
| **Plataforma** | VMware Workstation / VirtualBox |
| **Sistema Operativo** | Ubuntu Server 24.04 LTS |
| **Tecnologías** | Linux \| SSH \| UFW \| Nginx \| TLS \| Fail2ban \| Bash \| Cron |

---

## 🎯 Descripción y Objetivos

Este proyecto documenta la implementación, verificación y auditoría de controles de seguridad fundamentales en un entorno de servidor Linux. El objetivo principal es aplicar el principio de mínimo privilegio y validar técnicamente que cada servicio configurado responda adecuadamente ante intentos de acceso no autorizados.

---

## 📊 Resumen Ejecutivo

* **Hardening SSH:** Autenticación exclusiva por clave asimétrica Ed25519 y desactivación efectiva de contraseñas.
* **Firewall con UFW:** Política por defecto de denegación (`default deny`) y restricción de acceso SSH únicamente desde la IP de administración.
* **Servidor Web HTTPS:** Servidor Nginx con TLS 1.2/1.3, redirección 301 obligatoria y cabeceras de seguridad HTTP activas (`always`).
* **Prevención de Fuerza Bruta:** Fail2ban monitoreando registros de autenticación (`auth.log`) con bloqueo automático de IPs y lista blanca administrativa (`ignoreip`).
* **Automatización de Respaldos:** Script en Bash ejecutable por `cron` que empaqueta configuraciones críticas y realiza verificaciones de restauración.

---

## 🏗️ Arquitectura del Laboratorio

```text
       ┌─────────────────────────────────────────┐
       │     Cliente de Administración Windows    │
       │           IP: 192.168.233.136           │
       └────────────────────┬────────────────────┘
                            │
                            │  SSH (22/tcp) - Restringido por IP
                            │  HTTP (80/tcp) / HTTPS (443/tcp)
                            ▼
       ┌─────────────────────────────────────────┐
       │          Servidor Ubuntu Target         │
       │           IP: 192.168.233.140           │
       ├─────────────────────────────────────────┤
       │  • OpenSSH (Hardened - Solo Ed25519)    │
       │  • UFW Firewall (Filtro por IP/Puerto)   │
       │  • Nginx Web Server (HTTPS & Headers)   │
       │  • Fail2ban (Análisis de auth.log)      │
       │  • Backup & Restore Drill (Bash + Cron) │
       └─────────────────────────────────────────┘
```

---

## 📚 Hitos del Proyecto

1. **[Hito 01: Hardening de SSH](01-hardening/ssh.md)** — Configuración de claves Ed25519, desactivación de accesos por contraseña y verificación de la configuración efectiva en tiempo de ejecución (`sshd -T`).
2. **[Hito 02: Firewall y Control de Acceso con UFW](02-network-security/ufw.md)** — Reglas restrictivas por IP de origen, eliminación de redundancias y política global de denegación entrante.
3. **[Hito 03: Servicios Web Seguros con Nginx y TLS](03-web-security/nginx-tls.md)** — Implementación de certificados TLS, cifrados seguros, redirección HTTP a HTTPS y cabeceras de protección.
4. **[Hito 04: Prevención de Fuerza Bruta con Fail2ban](04-intrusion-prevention/fail2ban.md)** — Protección contra ataques de diccionario basada en análisis de logs, jaulas personalizadas y exclusión de la IP administrativa.
5. **[Hito 05: Respaldos Automatizados y Prueba de Restauración](05-backup-recovery/backup-restore.md)** — Script en Bash para empaquetado de datos/configuraciones, programación en `cron` y prueba de extracción de recuperación.

---

## 🧪 Pruebas y Evidencias (Testing & Evidence)

| Control Evaluado | Escenario de Prueba | Resultado Esperado | Evidencia Visual |
| :--- | :--- | :--- | :--- |
| **SSH Hardening** | Conexión con `PubkeyAuthentication=no` | Rechazo con `Permission denied (publickey)` | `screenshots/ssh-hardening.png` |
| **UFW Firewall** | Escaneo de puertos y verificación de tabla | Solo puertos 80, 443 (Anywhere) y 22 (Solo 192.168.233.136) abiertos | `screenshots/ufw-status.png` |
| **Nginx HTTPS** | Inspección de cabeceras HTTP con `curl -I` | Redirección 301 a HTTPS y presencia de cabeceras de seguridad | `screenshots/nginx-headers.png` |
| **Fail2ban** | Intentos fallidos repetidos en logs | Bloqueo de la IP atacante y registro en `jail.local` | `screenshots/fail2ban-ban.png` |
| **Respaldos** | Ejecución de script y descompresión en `/tmp` | Generación del `.tar.gz` e integridad de archivos comprobada | `screenshots/backup-restore.png` |

---

## 📁 Estructura del Repositorio

```text
homelab-cybersecurity-portafolio/
│
├── 01-Hardening-Linux-SSH
├── 02-Firewall-UFW
├── 03-Servicios-Web-HTTPS-Nginx
├── 04-Mitigacion-Fuerza-Bruta-Fail2ban
├── 05-Automatizacion-Respaldos-Bash-Cron
│
├── configs/
│   ├── jail2ban
│	│	└── jail.local
│   ├── nginx
│	│	└── nginx-homelab
│   └── ssh
│		└── sshd_config
│
├── scripts/
│   └── backup-homelab.sh
│
├── assets/
│   
│
├── LICENSE
└── README.md
```

> **Nota sobre configuraciones:** Los archivos almacenados en la carpeta `configs/` corresponden a plantillas de ejemplo sanitizadas. Se han retirado o neutralizado claves privadas, contraseñas y valores específicos del entorno.

---

## 🚀 Hoja de Ruta (Roadmap)

### Fase 1 — Hardening de Infraestructura

- [x] SSH Hardening 
- [x] UFW Firewall 
- [x] Nginx + HTTPS -
- [x]  Fail2ban 
- [x] Backup & Restore

### Fase 2 — Detección y Monitoreo

- [ ] Wazuh SIEM

### Fase 3 — Simulación de Ataques

- [ ] Nmap 
- [ ] Hydra 
- [ ] Traffic analysis

### Fase 4 — Respuesta a Incidentes

- [ ] Incident investigation 
- [ ] Detection → Analysis → Containment → Recovery
---

## 🧠 Lo que aprendí (Lessons Learned)

Este proyecto me ha permitido comprender y poner a prueba los siguientes principios clave:

* **La configuración efectiva debe validarse en runtime:** Un archivo de configuración como `sshd_config` no garantiza el comportamiento final si existen archivos secundarios que lo sobrescriben (`sshd_config.d/`). Evaluar con `sshd -T` es indispensable.
* **Las reglas de firewall deben probarse desde múltiples orígenes:** Verificar un firewall implica comprobar tanto que la IP autorizada puede conectarse como que cualquier otra IP es bloqueada.
* **Las cabeceras de seguridad requieren la directiva `always`:** En Nginx, si no se especifica `always;` al definir las cabeceras `add_header`, estas no se enviarán en páginas de error (4xx/5xx).
* **Un respaldo solo es válido si se ha probado su restauración:** La creación de archivos `.tar.gz` es únicamente la mitad del proceso; comprobar la integridad en una extracción de prueba es lo que garantiza la recuperación.
* **Los controles de seguridad deben ser medibles y reproducibles:** Documentar los comandos de verificación y las salidas reales aporta transparencia y rigor técnico a la administración de sistemas.

---

## 📜 Licencia

Este proyecto está bajo la Licencia **MIT** - consulta el archivo [LICENSE](LICENSE) para más detalles.
