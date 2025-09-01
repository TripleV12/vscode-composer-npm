# Usa la última imagen oficial de code-server como base.
FROM codercom/code-server:latest

# Cambia al usuario 'root' temporalmente para instalar software.
USER root

# RUN 1: Instala dependencias del sistema y de PHP, incluyendo Composer.
RUN apt-get update && apt-get install -y \
    curl \
    git-lfs \
    php8.2-sqlite3 \
    default-mysql-client \
    postgresql-client \
    php-cli \
    php-zip \
    unzip \
    php8.2-xml \
    php8.2-dom \
    php8.2-mbstring \
    php-curl \
    php-gd \
    php-xdebug && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# RUN 2: Añade el repositorio de NodeSource e instala Node.js.
# Este RUN es solo para instalar Node.js.
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get install -y nodejs

# RUN 3: Instala Yarn y Gemini CLI globalmente usando npm.
# Este RUN garantiza que npm ya está disponible de la capa anterior.
RUN npm install -g yarn && \
    npm install -g @google/gemini-cli@latest

# RUN 4: Instala las extensiones de VS Code.
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

# RUN 5: Asegura los permisos y configura los settings.
RUN chown -R coder:coder /home/coder/ && \
    echo '{' >> /home/coder/.config/code-server/settings.json && \
    echo '  "workbench.colorTheme": "Visual Studio Dark",' >> /home/coder/.config/code-server/settings.json && \
    echo '  "geminicodeassist.updateChannel": "Insiders",' >> /home/coder/.config/code-server/settings.json && \
    echo '  "keyboard.layout": "es"' >> /home/coder/.config/code-server/settings.json && \
    echo '}' >> /home/coder/.config/code-server/settings.json

USER coder
