# 🛡️ Building an IT Cybersecurity Homelab Portfolio

[![Linux](https://img.shields.io/badge/OS-Ubuntu%20Server%2022.04%20LTS-E95420?logo=ubuntu&logoColor=white)](#)
[![Security](https://img.shields.io/badge/Focus-Hardening%20%26%20SysAdmin-blue)](#)
[![Status](https://img.shields.io/badge/Status-Completed-success)](#)

Este repositorio documenta la construcción, securización (*hardening*) y administración automatizada de un entorno de laboratorio (**Homelab**) orientado a ciberseguridad y administración de sistemas Linux.

El proyecto está diseñado siguiendo estándares profesionales de la industria y la filosofía de **mínimo privilegio**, **defensa en profundidad** e **infraestructura como código/documentación en Markdown** lista para integración con Obsidian y repositorios públicos.

---

## 📐 Arquitectura de la Red del Homelab

* **Servidor Central:** `Ubuntu Server` (`192.168.233.140`)
* **Clientes de Gestión & Auditoría:**
  * `Windows PowerShell Host` (`C:\Users\sebas\.ssh`)
  * `Ubuntu Client` (`192.168.233.136`)
* **Topología:** Red local privada /24 aislada para pruebas de ciberseguridad defensiva (*Blue Teaming*).

---

## 🗂️ Índice de Hitos y Módulos de Documentación

| Hito | Módulo / Documento | Temática Principal | Tecnologías |
| :---: | :--- | :--- | :--- |
| **01** | [`01-Hardening-Linux-SSH.md`](./01-Hardening-Linux-SSH.md) | Hardening estricto de SSH, claves Ed25519 y deshabilitación de contraseñas. | `OpenSSH`, `Ed25519`, `PowerShell` |
| **02** | [`02-Firewall-UFW.md`](./02-Firewall-UFW.md) | Configuración granular del cortafuegos local y política por defecto *deny incoming*. | `UFW`, `iptables` |
| **03** | [`03-Servicios-Web-HTTPS-Nginx.md`](./03-Servicios-Web-HTTPS-Nginx.md) | Servidor Web seguro, Virtual Hosts, TLS/SSL 2048-bit, HTTP 301 y Security Headers. | `Nginx`, `OpenSSL`, `TLS 1.3` |
| **04** | [`04-Mitigacion-Fuerza-Bruta-Fail2ban.md`](./04-Mitigacion-Fuerza-Bruta-Fail2ban.md) | Sistema de Prevención de Intrusiones (IPS), jaula SSH y bloqueo automático en UFW. | `Fail2ban`, `Auth Logs`, `UFW` |
| **05** | [`05-Automatizacion-Respaldos-Bash-Cron.md`](./05-Automatizacion-Respaldos-Bash-Cron.md) | Scripting en Bash para backups tar.gz, política de retención 7 días y tareas cron. | `Bash`, `Cron`, `Tar`, `Sysadmin` |

---

## 🔑 Resumen de Competencias Técnicas Demostradas

* **Administración de Sistemas Linux:** Gestión de servicios (`systemd`), análisis de logs (`journalctl`, `/var/log`), permisos POSIX y automatización.
* **Hardening y Ciberseguridad Defensiva:** Eliminación de vector de fuerza bruta SSH, cifrado de tráfico web en tránsito con TLS, inyección de cabeceras HTTP de seguridad (`X-Frame-Options`, `X-Content-Type-Options`) y ocultación de banners de versión (`server_tokens off`).
* **Seguridad de Red & IPS:** Implementación de reglas UFW y defensa proactiva en tiempo real mediante detección de patrones en registros de autenticación con `Fail2ban`.
* **Resiliencia & BCP/DR:** Scripting Bash con manejo de errores, rotación automática de archivos y backups programados con `crontab`.

---

## 🛠️ Requisitos e Instalación en Entorno Local

Para replicar este laboratorio en tu propia infraestructura de pruebas:

1. Clonar el repositorio:
   ```bash
   git clone https://github.com/tu-usuario/homelab-cybersecurity-portfolio.git
   cd homelab-cybersecurity-portfolio
   ```
2. Consultar cada archivo `.md` individual para seguir la guía paso a paso con los comandos y configuraciones específicas de cada hito.

---

### 📝 Licencia y Propósito
Este proyecto ha sido desarrollado como portafolio técnico profesional para acreditar habilidades prácticas en administración de sistemas y ciberseguridad.
