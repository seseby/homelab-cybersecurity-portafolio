# 🛡️ Homelab Cybersecurity & Systems Hardening Portfolio

![Status](https://img.shields.io/badge/Status-In%20Progress-orange)
![OS](https://img.shields.io/badge/OS-Ubuntu%20Server%2022.04%20LTS-E95420)
![Security](https://img.shields.io/badge/Security-Hardening%20%26%20Defense-blue)
![License](https://img.shields.io/badge/License-MIT-green)

Repositorio de documentación técnica y evidencias del despliegue, endurecimiento (*hardening*) y administración segura de un entorno **Homelab de Ciberseguridad Defensiva**.

---

## 📌 Visión General y Arquitectura

Este laboratorio documenta la implementación de medidas de seguridad a nivel de host, filtrado perimetral, cifrado de transporte, prevención de intrusiones mediante análisis de logs y automatización de respaldos en un servidor Linux Ubuntu Server.

### Topología de Red

```text
[ Cliente / Atacante ] ── (192.168.233.136)
          │
          ▼
[ Firewall UFW / Fail2ban H-IPS ]
          │
          ├─► SSH (22/tcp) ──────► Auth por Clave Ed25519 (Password Auth: OFF)
          ├─► HTTP (80/tcp) ─────► Redirección 301 a HTTPS
          └─► HTTPS (443/tcp) ───► Nginx + TLS 1.2/1.3 + Security Headers
```

---

## 📚 Módulos del Proyecto

| Módulo | Documento | Descripción Técnica |
| :--- | :--- | :--- |
| **01** | [`01-Hardening-Linux-SSH.md`](./01-Hardening-Linux-SSH.md) | Desactivación de autenticación por contraseña, claves Ed25519 y verificación runtime con `sshd -T`. |
| **02** | [`02-Firewall-UFW.md`](./02-Firewall-UFW.md) | Política por defecto *Deny All*, apertura estricta de servicios e inspección de reglas. |
| **03** | [`03-Servicios-Web-HTTPS-Nginx.md`](./03-Servicios-Web-HTTPS-Nginx.md) | Server Block en Nginx, certificados SSL/TLS (2048-bit), redirección HTTP 301 y cabeceras de seguridad. |
| **04** | [`04-Mitigacion-Fuerza-Bruta-Fail2ban.md`](./04-Mitigacion-Fuerza-Bruta-Fail2ban.md) | Prevención de intrusiones basada en host (H-IPS), análisis de `/var/log/auth.log` y baneo dinámico UFW. |
| **05** | [`05-Automatizacion-Respaldos-Bash-Cron.md`](./05-Automatizacion-Respaldos-Bash-Cron.md) | Script en Bash para backup de configuraciones críticas y sitio web, retención de 7 días y programación vía `cron`. |

---

## 🔍 Desafíos Técnicos y Lecciones Aprendidas (Troubleshooting)

1. **Verificación de Configuración SSH Efectiva (`sshd -T`):**
   * *Desafío:* La directiva `PasswordAuthentication no` en `/etc/ssh/sshd_config` puede ser sobrescrita por archivos en `/etc/ssh/sshd_config.d/*.conf`.
   * *Solución:* Verificación runtime obligatoria con `sudo sshd -T | grep -i passwordauthentication` y pruebas de acceso denegado con `ssh -o PubkeyAuthentication=no`.

2. **Diferencias entre `curl` en PowerShell e Invoke-WebRequest:**
   * *Desafío:* En Windows PowerShell, `curl` es un alias de `Invoke-WebRequest`, rechazando parámetros nativos como `-kI`.
   * *Solución:* Ejecución explícita de `curl.exe` para validar cabeceras HTTP/HTTPS y respuestas 301.

3. **Inyección Dinámica de Reglas con Fail2ban:**
   * *Desafío:* Validar que Fail2ban no solo detecte el ataque, sino que active la acción defensiva a nivel de firewall.
   * *Solución:* Prueba de concepto con intentos fallidos simulados, verificación de regla `REJECT` en `ufw status` y procedimiento de desbloqueo manual mediante `fail2ban-client set sshd unbanip`.

---

## 🖼️ Evidencias y Capturas de Pantalla

Las capturas de pantalla, salidas de consola y logs reales del sistema se almacenan en el directorio [`/assets`](./assets)

---

## 🚀 Clonado e Instalación

Para replicar o revisar la documentación localmente:

```bash
git clone https://github.com/seseby/homelab-cybersecurity-portafolio.git
cd homelab-cybersecurity-portafolio
```

---

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Consulta el archivo [`LICENSE`](./LICENSE) para más detalles.
