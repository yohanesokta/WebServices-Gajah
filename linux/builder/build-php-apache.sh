#!/usr/bin/env bash
set -e

# =========================
# CONFIG
# =========================
APACHE_VERSION="2.4.66"
PHP_VERSION="8.4.16"

BUILD_DIR="$HOME/build"
RUNTIME_DIR="/opt/runtime"

# =========================
# PRE-CHECK
# =========================
if [ "$(lsb_release -cs)" != "bookworm" ]; then
  echo "❌ Script ini hanya untuk Debian 12 (bookworm)"
  exit 1
fi

echo "✅ Debian 12 terdeteksi"

# =========================
# INSTALL DEPENDENCIES
# =========================
echo "🔧 Install dependency build..."

sudo apt update
sudo apt install -y \
  build-essential \
  pkg-config \
  wget \
  curl \
  ca-certificates \
  perl \
  patchelf \
  libxml2-dev \
  libssl-dev \
  libcurl4-openssl-dev \
  libsqlite3-dev \
  libicu-dev \
  libjpeg-dev \
  libpng-dev \
  libonig-dev \
  zlib1g-dev \
  libzip-dev \
  libmariadb-dev \
  libapr1-dev \
  libaprutil1-dev \
  libpcre2-dev

# =========================
# PREPARE DIRECTORIES
# =========================
echo "📁 Prepare directories..."

mkdir -p "$BUILD_DIR"
sudo rm -rf "$RUNTIME_DIR"
sudo mkdir -p "$RUNTIME_DIR"
sudo chown -R "$USER:$USER" "$RUNTIME_DIR"

cd "$BUILD_DIR"

# =========================
# BUILD APACHE
# =========================
echo "🚀 Build Apache $APACHE_VERSION"

wget -q https://downloads.apache.org/httpd/httpd-${APACHE_VERSION}.tar.gz
tar xf httpd-${APACHE_VERSION}.tar.gz
cd httpd-${APACHE_VERSION}

./configure \
  --prefix="$RUNTIME_DIR/apache" \
  --enable-so \
  --enable-ssl \
  --enable-rewrite

make -j"$(nproc)"
make install

echo "Apache built"

# =========================
# VERIFY APXS
# =========================
if [ ! -x "$RUNTIME_DIR/apache/bin/apxs" ]; then
  echo "❌ apxs tidak ditemukan"
  exit 1
fi

echo "✅ apxs ditemukan"

# =========================
# BUILD PHP
# =========================
cd "$BUILD_DIR"
echo "🚀 Build PHP $PHP_VERSION"

wget -q https://www.php.net/distributions/php-${PHP_VERSION}.tar.gz
tar xf php-${PHP_VERSION}.tar.gz
cd php-${PHP_VERSION}

./configure \
  --prefix="$RUNTIME_DIR/php" \
  --with-apxs2="$RUNTIME_DIR/apache/bin/apxs" \
  --with-openssl \
  --with-curl \
  --with-zlib \
  --with-mysqli=mysqlnd \
  --with-pdo-mysql=mysqlnd \
  --with-pdo-sqlite \
  --with-sqlite3 \
  --enable-mbstring \
  --enable-intl \
  --enable-zip \
  --enable-gd \
  --with-jpeg \
  --with-png \
  --enable-cli

make -j"$(nproc)"
make install

echo "PHP built"
echo "🛠 Configure Apache + PHP"

mkdir -p "$RUNTIME_DIR/www"

cat >> "$RUNTIME_DIR/apache/conf/httpd.conf" <<'EOF'

ServerName localhost
Listen 8080

LoadModule php_module modules/libphp.so

DocumentRoot "/opt/runtime/www"
<Directory "/opt/runtime/www">
    AllowOverride All
    Require all granted
</Directory>

<FilesMatch \.php$>
    SetHandler application/x-httpd-php
</FilesMatch>

DirectoryIndex index.php index.html
EOF

# =========================
# CREATE TEST FILE
# =========================
cat > "$RUNTIME_DIR/www/index.php" <<'EOF'
<?php
echo "Apache + PHP OK\n";
echo "SAPI: " . PHP_SAPI . "\n";
phpinfo();
EOF

# =========================
# TEST RUN
# =========================
echo "🧪 Test run Apache + PHP"

"$RUNTIME_DIR/apache/bin/httpd" -t

echo "▶️ Starting Apache (CTRL+C untuk stop)..."
echo "🌐 http://localhost:8080"

"$RUNTIME_DIR/apache/bin/httpd" -DFOREGROUND
