# 🚀 Guía Completa: Instalar Moodle Local para Probar el Plugin

## Opción 1: Bitnami Moodle Stack (Más Fácil) ⭐

### Ventajas
- ✅ Instalador todo-en-uno
- ✅ Configuración automática
- ✅ Funciona en Windows, Mac, Linux
- ✅ Incluye Apache, MySQL, PHP
- ✅ Listo en 20-30 minutos

### Pasos de Instalación

#### 1. Descargar Bitnami Moodle

Visita: https://bitnami.com/stack/moodle/installer

Descarga la versión para tu sistema operativo.

#### 2. Instalar

**Windows:**
```bash
# Ejecuta el instalador .exe
# Sigue el wizard:
# - Acepta términos
# - Elige directorio (ej: C:\Bitnami\moodle-4.4.0)
# - Configura usuario admin
# - Configura contraseña
```

**Linux:**
```bash
chmod +x bitnami-moodle-*-linux-x64-installer.run
sudo ./bitnami-moodle-*-linux-x64-installer.run
```

**Mac:**
```bash
# Abre el .dmg y sigue el instalador
```

#### 3. Iniciar Moodle

**Windows:**
```bash
# Usa el "Manager Tool" de Bitnami
# O manualmente:
cd C:\Bitnami\moodle-4.4.0
ctlscript.bat start
```

**Linux/Mac:**
```bash
cd /opt/bitnami/moodle
sudo ./ctlscript.sh start
```

#### 4. Acceder a Moodle

Abre tu navegador:
```
http://localhost/moodle
```

Credenciales por defecto:
- Usuario: `user` (o el que configuraste)
- Contraseña: (la que configuraste)

#### 5. Instalar el Plugin

**Windows:**
```bash
# Copia tu plugin
xcopy /E /I moodle-plugin "C:\Bitnami\moodle-4.4.0\apps\moodle\htdocs\mod\aiassignment"
```

**Linux/Mac:**
```bash
sudo cp -r moodle-plugin /opt/bitnami/moodle/apps/moodle/htdocs/mod/aiassignment
sudo chown -R bitnami:bitnami /opt/bitnami/moodle/apps/moodle/htdocs/mod/aiassignment
```

#### 6. Activar el Plugin en Moodle

1. Inicia sesión como administrador
2. Ve a: **Site administration → Notifications**
3. Moodle detectará el nuevo plugin
4. Haz clic en **"Upgrade Moodle database now"**
5. Confirma la instalación

#### 7. Configurar API Key

1. Ve a: **Site administration → Plugins → Activity modules → AI Assignment**
2. Ingresa tu **OpenAI API Key**
3. (Opcional) Cambia el modelo
4. Guarda cambios

#### 8. Probar el Plugin

1. Ve a un curso (o crea uno nuevo)
2. Activa la edición
3. Agrega una actividad → **AI Assignment**
4. Crea un problema de prueba
5. Envía una respuesta como estudiante
6. Verifica la evaluación automática

---

## Opción 2: XAMPP (Windows)

### Ventajas
- ✅ Control total
- ✅ Familiar para desarrolladores Windows
- ✅ Fácil de configurar

### Pasos de Instalación

#### 1. Instalar XAMPP

Descarga: https://www.apachefriends.org/

Instala con:
- ✅ Apache
- ✅ MySQL
- ✅ PHP (7.4 o superior)

#### 2. Descargar Moodle

```bash
cd C:\xampp\htdocs
git clone https://github.com/moodle/moodle.git
cd moodle
git checkout MOODLE_404_STABLE
```

O descarga el ZIP desde: https://download.moodle.org/

#### 3. Crear Base de Datos

1. Inicia XAMPP Control Panel
2. Inicia Apache y MySQL
3. Abre phpMyAdmin: http://localhost/phpmyadmin
4. Crea una base de datos:
   - Nombre: `moodle`
   - Collation: `utf8mb4_unicode_ci`

#### 4. Crear Directorio de Datos

```bash
mkdir C:\moodledata
```

Asegúrate de que tenga permisos de escritura.

#### 5. Instalar Moodle

Visita: http://localhost/moodle

Sigue el instalador:
- Idioma: Español
- Directorio de datos: `C:\moodledata`
- Base de datos:
  - Tipo: MySQL
  - Host: localhost
  - Nombre: moodle
  - Usuario: root
  - Contraseña: (vacía por defecto en XAMPP)

#### 6. Instalar el Plugin

```bash
xcopy /E /I moodle-plugin C:\xampp\htdocs\moodle\mod\aiassignment
```

#### 7. Activar el Plugin

1. Ve a: Site administration → Notifications
2. Actualiza la base de datos
3. Configura tu API key

---

## Opción 3: Docker (Linux/Mac/Windows)

### Ventajas
- ✅ Aislado del sistema
- ✅ Fácil de eliminar
- ✅ Reproducible
- ✅ Rápido de configurar

### Requisitos
- Docker instalado
- Docker Compose instalado

### Pasos de Instalación

#### 1. Crear docker-compose.yml

```yaml
version: '3'
services:
  mariadb:
    image: mariadb:10.6
    environment:
      MYSQL_ROOT_PASSWORD: moodle
      MYSQL_DATABASE: moodle
      MYSQL_USER: moodle
      MYSQL_PASSWORD: moodle
    volumes:
      - mariadb_data:/var/lib/mysql

  moodle:
    image: bitnami/moodle:4.4
    ports:
      - "8080:8080"
      - "8443:8443"
    environment:
      MOODLE_DATABASE_HOST: mariadb
      MOODLE_DATABASE_NAME: moodle
      MOODLE_DATABASE_USER: moodle
      MOODLE_DATABASE_PASSWORD: moodle
      MOODLE_USERNAME: admin
      MOODLE_PASSWORD: admin123
      MOODLE_EMAIL: admin@example.com
    volumes:
      - moodle_data:/bitnami/moodle
      - ./moodle-plugin:/bitnami/moodle/mod/aiassignment
    depends_on:
      - mariadb

volumes:
  mariadb_data:
  moodle_data:
```

#### 2. Iniciar Moodle

```bash
docker-compose up -d
```

#### 3. Acceder

```
http://localhost:8080
```

Credenciales:
- Usuario: `admin`
- Contraseña: `admin123`

#### 4. Instalar el Plugin

El plugin ya está montado en el contenedor. Solo necesitas:

1. Ve a: Site administration → Notifications
2. Actualiza la base de datos
3. Configura tu API key

#### 5. Detener Moodle

```bash
docker-compose down
```

#### 6. Eliminar Todo

```bash
docker-compose down -v
```

---

## Opción 4: Instalación Manual (Linux)

### Para Ubuntu/Debian

```bash
# 1. Instalar dependencias
sudo apt update
sudo apt install apache2 mysql-server php php-mysql php-xml php-curl php-zip php-gd php-mbstring php-xmlrpc php-soap php-intl git

# 2. Configurar MySQL
sudo mysql_secure_installation
sudo mysql -u root -p
CREATE DATABASE moodle DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'moodleuser'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON moodle.* TO 'moodleuser'@'localhost';
FLUSH PRIVILEGES;
EXIT;

# 3. Descargar Moodle
cd /var/www/html
sudo git clone https://github.com/moodle/moodle.git
cd moodle
sudo git checkout MOODLE_404_STABLE

# 4. Crear directorio de datos
sudo mkdir /var/moodledata
sudo chown -R www-data:www-data /var/moodledata
sudo chmod -R 777 /var/moodledata

# 5. Configurar permisos
sudo chown -R www-data:www-data /var/www/html/moodle

# 6. Configurar Apache
sudo nano /etc/apache2/sites-available/moodle.conf
```

Contenido del archivo:
```apache
<VirtualHost *:80>
    ServerAdmin admin@example.com
    DocumentRoot /var/www/html/moodle
    ServerName localhost

    <Directory /var/www/html/moodle>
        Options FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/moodle_error.log
    CustomLog ${APACHE_LOG_DIR}/moodle_access.log combined
</VirtualHost>
```

```bash
# 7. Activar sitio
sudo a2ensite moodle.conf
sudo a2enmod rewrite
sudo systemctl restart apache2

# 8. Instalar Moodle
# Visita: http://localhost/moodle
# Sigue el instalador web

# 9. Instalar plugin
sudo cp -r /ruta/a/tu/moodle-plugin /var/www/html/moodle/mod/aiassignment
sudo chown -R www-data:www-data /var/www/html/moodle/mod/aiassignment
```

---

## 🧪 Verificar Instalación

### 1. Verificar que Moodle funciona

```
http://localhost/moodle
```

### 2. Verificar que el plugin está instalado

1. Inicia sesión como admin
2. Ve a: Site administration → Plugins → Activity modules
3. Busca "AI Assignment"

### 3. Crear un curso de prueba

1. Site administration → Courses → Manage courses and categories
2. Create new course
3. Nombre: "Curso de Prueba"
4. Guarda

### 4. Agregar actividad AI Assignment

1. Entra al curso
2. Turn editing on
3. Add an activity or resource
4. Selecciona "AI Assignment"
5. Configura un problema simple
6. Guarda

### 5. Probar como estudiante

1. Enroll un usuario como estudiante
2. Inicia sesión como ese estudiante
3. Envía una respuesta
4. Verifica que recibas evaluación automática

---

## 🔧 Solución de Problemas

### Error: "Plugin not found"
```bash
# Verifica la ubicación
ls /ruta/a/moodle/mod/aiassignment

# Debe contener:
# - version.php
# - lib.php
# - view.php
# - etc.
```

### Error: "Database error"
```bash
# Verifica permisos de base de datos
# Verifica que install.xml esté bien formateado
```

### Error: "No API key configured"
```bash
# Ve a: Site administration → Plugins → Activity modules → AI Assignment
# Configura tu OpenAI API key
```

### Moodle muy lento
```bash
# Aumenta memoria PHP
sudo nano /etc/php/8.1/apache2/php.ini

# Cambia:
memory_limit = 256M
max_execution_time = 300
```

---

## 📊 Comparación de Opciones

| Opción | Tiempo | Dificultad | Mejor Para |
|--------|--------|------------|------------|
| **Bitnami** | 30 min | ⭐ Baja | Principiantes, pruebas rápidas |
| **XAMPP** | 45 min | ⭐⭐ Media | Windows, desarrollo |
| **Docker** | 15 min | ⭐⭐ Media | Desarrolladores, aislamiento |
| **Manual** | 60 min | ⭐⭐⭐ Alta | Producción, control total |

---

## 🎯 Recomendación

**Para empezar rápido:**
```
1. Usa test-environment/ para validar el evaluador (5 min)
2. Instala Bitnami Moodle Stack (30 min)
3. Instala el plugin (5 min)
4. Prueba con casos reales (15 min)
```

**Total: ~1 hora para tener todo funcionando**

---

## 📞 Siguiente Paso

Una vez instalado Moodle:

1. Lee `moodle-plugin/MANUAL_USUARIO.md`
2. Sigue `moodle-plugin/INSTALACION.md`
3. Configura tu API key
4. Crea problemas de prueba
5. Prueba el flujo completo

¡Buena suerte! 🚀
