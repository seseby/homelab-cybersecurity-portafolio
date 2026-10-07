# 🛡️ IT Cybersecurity Homelab Portfolio

![Status](https://img.shields.io/badge/Status-In%20Progress-yellow)
![Platform](https://img.shields.io/badge/OS-Ubuntu%20Server%2024.04%20LTS-orange)
![Security](https://img.shields.io/badge/Focus-Defensive%20Security%20%26%20Sysadmin-blue)
![License](https://img.shields.io/badge/License-MIT-green)

## 📌 Resumen Ejecutivo

Este repositorio documenta el despliegue, aseguramiento (*hardening*) y administración de un entorno de laboratorio Linux (**Ubuntu Server 24.04 LTS**). El objetivo del proyecto es aplicar controles de ciberseguridad defensiva a nivel de host, filtrado de tráfico de red, aseguramiento de servicios web HTTPS, mitigación reactiva de ataques de fuerza bruta y políticas de respaldo local con pruebas de restauración.

---

## 📐 Arquitectura y Topología de Red

El laboratorio se estructura en una red interna privada (`192.168.233.0/24`) aislada mediante hipervisor:

| Host / Nodo | Rol | Dirección IP | Función Principal |
| :--- | :--- | :--- | :--- |
| **`ubuntuserver`** | Servidor Principal | `192.168.233.140` | Servidor web Nginx, bastión SSH, UFW, Fail2ban |
| **`ubuntuclient`** | Cliente de Gestión | `192.168.233.136` | Equipo autorizado para administración SSH y pruebas |
| **`winadmin`** | Estación Admin | `192.168.233.1` | Auditoría externa, PowerShell, pruebas HTTP/HTTPS |

---

## 🗂️ Estructura del Repositorio y Módulos

El proyecto está organizado en 5 hitos técnicos secuenciales:

```text
.
├── README.md                              # Documentación general del portafolio
├── LICENSE                                # Licencia de código abierto MIT
├── 01-Hardening-Linux-SSH.md              # Hito 01: Configuración estricta de SSH
├── 02-Firewall-UFW.md                     # Hito 02: Filtrado granular con UFW
├── 03-Servicios-Web-HTTPS-Nginx.md        # Hito 03: Despliegue de Nginx y TLS/SSL
├── 04-Mitigacion-Fuerza-Bruta-Fail2ban.md # Hito 04: H-IPS reactivo con Fail2ban
├── 05-Automatizacion-Respaldos-Bash-Cron.md # Hito 05: Script de backup y restauración
├── configs/                               # Archivos de configuración limpios
├── scripts/                               # Scripts de automatización en Bash
└── assets/                                # Capturas de pantalla y evidencias
```

---

## 🚀 Resumen Técnico de los Hitos

### 🔑 [Hito 01: Hardening Estricto del Servicio SSH](01-Hardening-Linux-SSH.md)
* **Despliegue de Llaves:** Generación de pares de llaves **Ed25519** y desactivación total de `PasswordAuthentication`.
* **Mínimo Privilegio:** Restricción de acceso mediante `AllowUsers`, `PermitRootLogin no` y `MaxAuthTries 3`.
* **Auditoría Runtime:** Verificación efectiva de parámetros mediante `sudo sshd -T` para descartar sobreescrituras en `/etc/ssh/sshd_config.d/`.

### 🧱 [Hito 02: Configuración del Firewall Perimetral (UFW)](02-Firewall-UFW.md)
* **Política por Defecto:** Denegación implícita de tráfico entrante (`default deny incoming`).
* **Reglas Granulares:** Restricción del puerto `22/tcp` exclusivamente a la IP autorizada (`192.168.233.136`).
* **Servicios Web:** Apertura explícita de puertos `80/tcp` (HTTP) y `443/tcp` (HTTPS).

### 🔒 [Hito 03: Aseguramiento de Servicios Web con Nginx y TLS](03-Servicios-Web-HTTPS-Nginx.md)
* **Cifrado TLS/SSL:** Generación de certificado OpenSSL con extensión **Subject Alternative Name (SAN)**.
* **Redirección HTTPS:** Configuración de respuesta HTTP 301 para forzar conexiones cifradas.
* **Cabeceras HTTP de Seguridad:** Inyección con directiva `always;` de **HSTS**, **CSP** (`default-src 'self'`), `X-Frame-Options DENY` y `X-Content-Type-Options nosniff`.

### 🚨 [Hito 04: Prevención de Intrusiones Basada en Host (Fail2ban)](04-Mitigacion-Fuerza-Bruta-Fail2ban.md)
* **Protección Reactiva:** Análisis en tiempo real de `/var/log/auth.log` ante fallos de autenticación.
* **Prevención de Autobaneo:** Configuración de `ignoreip` para evitar el bloqueo del nodo de administración.
* **Simulación y Unban:** Registro de eventos de bloqueo e inyección dinámica de reglas `REJECT` en UFW.

### 💾 [Hito 05: Automatizacion de Respaldos y Prueba de Restauracion](05-Automatizacion-Respaldos-Bash-Cron.md)
* **Script Bash:** Compresión en tarball (`.tar.gz`) de sitio web, configs SSH, Nginx, UFW y certificados SSL.
* **Programación Cron:** Tarea automatizada diaria a las 02:00 AM con rotación a 7 días.
* **Prueba de Recuperación:** Verificación de integridad mediante simulacro de restauración (*Restore Drill*).
---

## 💻 Instalación y Uso

Para replicar o revisar este repositorio en tu entorno local:

```bash
# Clonar el repositorio
git clone https://github.com/seseby/homelab-cybersecurity-portafolio.git

# Acceder al directorio
cd homelab-cybersecurity-portafolio
```

---

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Consulta el archivo [LICENSE](LICENSE) para más detalles.
