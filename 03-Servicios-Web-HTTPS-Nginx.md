# Fase 2: Servicios Web Avanzados y Cifrado HTTPS/TLS (Nginx)

## 🎯 Objetivo
Hacer evolucionar el servidor web Nginx desde una configuración por defecto hacia una arquitectura web segura y aislada en producción. Se implementó un Server Block propio, cifrado SSL/TLS con certificados de 2048 bits mediante OpenSSL, redirección automática obligatoria de HTTP (80) a HTTPS (443), ocultamiento de firma del demonio (`server_tokens off`) y aplicación de cabeceras de seguridad (*Security Headers*).

---

## 🛠️ 1. Estructura del Sitio y Server Block Aislado
Se creó el directorio dedicado para el sitio web y se desvinculó de la página por defecto de Nginx:

* **Directorio raíz del sitio:** `/va/homelab/html`
* **Permisos:** Propietario asignado al usuario sin privilegios para evitar ejecución como root.
* **Archivo de configuración del sitio:** `/etc/nginx/sites-available/homelab`
* **Activación del Virtual Host:**
  ```bash
  sudo ln -s /etc/nginx/sites-available/homelab /etc/nginx/sites-enabled/
  ```

---

## 🔒 2. Generación del Certificado TLS/SSL con OpenSSL
Para habilitar la capa de transporte seguro (HTTPS) en el entorno de laboratorio local, se generó un certificado autofirmado de 2048 bits y su clave privada correspondiente:

```bash
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/ssl/private/nginx-selfsigned.key \
  -out /etc/ssl/certs/nginx-selfsigned.crt \
  -subj "/C=ES/ST=State/L=City/O=Homelab/OU=IT/CN=192.168.233.140"
```

---

## ⚙️ 3. Configuración del Servidor Web Endurecido (`/etc/nginx/sites-available/homelab`)

```nginx
# Redirección obligatoria de HTTP a HTTPS
server {
    listen 80;
    server_name 192.168.233.140;
    return 301 https://$host$request_uri;
}

# Servidor Web Seguro (HTTPS)
server {
    listen 443 ssl;
    server_name 192.168.233.140;

    root /var/www/homelab/html;
    index index.html;

    # Certificados SSL/TLS
    ssl_certificate /etc/ssl/certs/nginx-selfsigned.crt;
    ssl_certificate_key /etc/ssl/private/nginx-selfsigned.key;

    # Protocolos seguros (TLS 1.2 y 1.3 únicamente)
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;

    # Ocultar versión del demonio Nginx (Footprinting prevention)
    server_tokens off;

    # Cabeceras de Seguridad (Security Headers)
    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-Content-Type-Options "nosniff";
    add_header X-XSS-Protection "1; mode=block";

    location / {
        try_files $uri $uri/ =404;
    }
}
```

---

## 🛡️ 4. Reglas del Firewall (UFW)
Se actualizó la política del firewall para permitir el tráfico web cifrado:

```bash
sudo ufw allow 'Nginx Full'
```
* **Estado final de UFW:** Permite `22/tcp` (SSH endurecido), `80/tcp` (HTTP para redirección) y `443/tcp` (HTTPS cifrado).

---

## 🧪 5. Verificación y Auditoría de Respuestas HTTP/HTTPS

### A. Verificación de Redirección Automática (HTTP 80 -> HTTPS 443)
```powershell
curl.exe -I http://192.168.233.140
```
![[imagen1.png]]
* **Resultado:** `HTTP/1.1 301 Moved Permanently` apuntando a `https://192.168.233.140`.

### B. Verificación de Conexión Segura HTTPS y Cabeceras
```powershell
curl.exe -kI https://192.168.233.140
```
![[Pasted image 20261007145321.png]]
* **Resultado:** `HTTP/1.1 200 OK`.
* **Cabeceras confirmadas:** `X-Frame-Options: SAMEORIGIN`, `X-Content-Type-Options: nosniff`, `X-XSS-Protection: 1; mode=block`.
* **Seguridad adicional:** La cabecera `Server` omite el número de versión exacta del demonio Nginx.

---
