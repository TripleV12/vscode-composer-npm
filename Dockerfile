FROM codercom/code-server:latest

USER root

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
    curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN npm install -g yarn && \
    npm install -g @google/gemini-cli@latest

RUN mkdir -p /home/coder/.config/code-server/ && \
    chown -R coder:coder /home/coder/ && \
    cat <<EOF > /home/coder/.config/code-server/settings.json
{
  "workbench.colorTheme": "Visual Studio Dark",
  "geminicodeassist.updateChannel": "Insiders",
  "keyboard.layout": "es"
}
EOF

USER coder

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
