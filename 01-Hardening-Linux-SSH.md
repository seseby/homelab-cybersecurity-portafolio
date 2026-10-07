# Hito 01: Hardening Estricto del Servicio SSH

## 🎯 Objetivo
Eliminar la superficie de ataque por fuerza bruta sobre el servicio SSH en el servidor Ubuntu (`192.168.233.140`), restringiendo el acceso exclusivamente a clientes autorizados mediante llaves criptográficas asimétricas (Ed25519) y aplicando la política de mínimo privilegio.

---

## 🔑 1. Aprovisionamiento de Claves Criptográficas
Se generaron pares de claves SSH utilizando el algoritmo moderno **Ed25519** en los clientes autorizados (Windows PowerShell y Ubuntu Client) y se exportaron las claves públicas hacia el servidor.

* **Comando de generación (Cliente):**
  ```powershell
  ssh-keygen -t ed25519 -C "admin-homelab"
  ```
* **Comando de despliegue de clave pública desde PowerShell:**
  ```powershell
  Get-Content C:\Users\sebas\.ssh\id_ed25519.pub | ssh sebastian@192.168.233.140 "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
  ```
* **Verificación de permisos estrictos en el servidor:**
  ```bash
  chmod 700 ~/.ssh
  chmod 600 ~/.ssh/authorized_keys
  ```

---

## ⚙️ 2. Modificaciones de Seguridad en `/etc/ssh/sshd_config`
Se editaron las directivas principales en la configuración del demonio SSH (`sshd`):

| Directiva | Valor Aplicado | Justificación de Ciberseguridad |
| :--- | :--- | :--- |
| `PubkeyAuthentication` | `yes` | Habilita la autenticación mediante par de llaves pública/privada. |
| `PasswordAuthentication` | `no` | **Inhabilita el acceso por contraseña**, mitigando ataques de diccionario y fuerza bruta. |
| `PermitRootLogin` | `no` | Impide el inicio de sesión directo como `root`, forzando el uso de cuentas de usuario estándar y `sudo`. |
| `PermitEmptyPasswords` | `no` | Deniega el acceso a cuentas que no tengan contraseña configurada. |
| `MaxAuthTries` | `3` | Limita el número de reintentos de autenticación por conexión para mitigar el escaneo activo. |
| `AllowUsers` | `sebastian` | Restringe el acceso SSH exclusivamente a los usuarios explícitamente autorizados. |

**Validación sintáctica y reinicio seguro del servicio:**
Antes de aplicar la configuración, se valida la sintaxis para evitar bloqueos accidentales de gestión:

```bash
sudo sshd -t
sudo systemctl reload ssh
```

---

## 🧪 3. Auditoría y Verificación de Seguridad

### A. Verificación de la Configuración Efectiva en Tiempo de Ejecución (Runtime)
Debido a que Ubuntu Server puede procesar archivos de configuración secundarios en `/etc/ssh/sshd_config.d/*.conf`, se verifica la directiva efectiva procesada por el demonio OpenSSH:

```bash
sudo sshd -T | grep -i passwordauthentication
```
* **Salida obtenida:** ![[imagen11.png]]

### B. Prueba de Estrés / Intento de Login por Contraseña
Se ejecutó un intento deliberado de autenticación omitiendo las llaves públicas desde un cliente no autorizado:

```powershell
ssh -o PubkeyAuthentication=no sebastian@192.168.233.140
```

* **Resultado obtenido:** `Permission denied (publickey)`.
* **Conclusión:** El servidor rechaza cualquier solicitud que no presente una firma criptográfica válida en `authorized_keys`.
![[imagen12.png]]
---
