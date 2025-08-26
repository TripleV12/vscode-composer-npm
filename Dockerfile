# Usa la última imagen oficial de code-server como base.
# Esta imagen ya viene con un entorno de VS Code preconfigurado.
FROM codercom/code-server:latest

# Cambia al usuario 'root' temporalmente para poder instalar software.
# El usuario por defecto 'coder' no tiene los permisos necesarios.
USER root

# Actualiza la lista de paquetes del sistema operativo y
# luego instala las herramientas necesarias para el desarrollo.
# La bandera '-y' acepta automáticamente la instalación.
RUN apt-get update && apt-get install -y \
    # 'curl' es una herramienta para transferir datos con URLs.
    curl \
    # 'git-lfs' maneja archivos grandes en Git. Útil para repositorios pesados.
    git-lfs \
    # 'default-mysql-client' es el cliente de línea de comandos para bases de datos MySQL.
    # Permite a tu contenedor conectarse y gestionar una DB MySQL.
    default-mysql-client \
    # 'postgresql-client' es el cliente para bases de datos PostgreSQL.
    # Te permite conectarte a una DB PostgreSQL desde el contenedor.
    postgresql-client \
    # 'php-cli' es la interfaz de línea de comandos para PHP.
    # Esencial para ejecutar comandos de Laravel como 'artisan'.
    php-cli \
    # 'php-zip' es una extensión de PHP necesaria para Composer.
    php-zip \
    # 'unzip' es una herramienta para descomprimir archivos.
    unzip

# Descarga el script de configuración para la versión LTS (soporte a largo plazo) de Node.js,
# lo ejecuta y luego instala Node.js y npm.
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y nodejs

# Descarga el instalador de Composer (gestor de dependencias de PHP)
# y lo instala en la ruta de ejecutables del sistema.
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Limpia la caché del gestor de paquetes para reducir el tamaño final de la imagen.
# Es una buena práctica para mantener las imágenes ligeras.
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Vuelve a cambiar al usuario por defecto 'coder' por seguridad.
# Todo el trabajo de desarrollo se hará con este usuario.
USER coder
