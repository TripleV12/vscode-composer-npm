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
    # 'php8.2-sqlite3' instalación del driver para tener la BBDD por defecto para prototipos laravel. 
    php8.2-sqlite3 \
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
    unzip \
    # Instala las extensiones de PHP que faltan para Laravel (pint y phpunit).
    # 'php8.2-xml', 'php8.2-dom' son esenciales para que Composer instale las dependencias.
    php8.2-xml \
    php8.2-dom \
    # 'php8.2-mbstring' es necesario para manejar cadenas de caracteres de múltiples bytes.
    php8.2-mbstring \
    php-curl \
    php-gd \
    php-xdebug \
    # Descarga e instala Node.js y npm.
    curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get install -y nodejs && \
    # Instala Yarn globalmente.
    npm install -g yarn && \
    # Instala Gemini CLI globalmente.
    npm install -g @google/gemini-cli@latest && \
    # Descarga el instalador de Composer
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    # Limpia la caché del gestor de paquetes para reducir el tamaño final de la imagen.
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Instala las extensiones de VS Code.
RUN code-server --install-extension Google.geminicodeassist \
    --install-extension google.gemini-cli-vscode-ide-companion \
    --install-extension MS-CEINTL.vscode-language-pack-es \
    --install-extension laravel.vscode-laravel \
    --install-extension bmewburn.vscode-intelephense-client \
    --install-extension ryannaddy.laravel-artisan \
    --install-extension onecentlin.laravel-blade \
    --install-extension mikestead.dotenv \
    --install-extension php-debug \
    --install-extension amiralizadeh9480.laravel-extra-intellisense \
    --install-extension livewire.livewire-snippets \
    --install-extension Vue.volar

# Asegura los permisos para el usuario 'coder'
RUN chown -R coder:coder /home/coder/ && \
    # Crea y añade el archivo de configuración settings.json con formato
    echo '{' >> /home/coder/.config/code-server/settings.json && \
    echo '  "workbench.colorTheme": "Visual Studio Dark",' >> /home/coder/.config/code-server/settings.json && \
    echo '  "geminicodeassist.updateChannel": "Insiders",' >> /home/coder/.config/code-server/settings.json && \
    echo '  "keyboard.layout": "es"' >> /home/coder/.config/code-server/settings.json && \
    echo '}' >> /home/coder/.config/code-server/settings.json

# Vuelve a cambiar al usuario por defecto 'coder' por seguridad.
USER coder
