#!/usr/bin/env bash
set -e

### ===============================
### PATH & URL
### ===============================
RUNTIME_ROOT="/opt"
RUNTIME_DIR="/opt/runtime"
TEMP_DIR="$HOME/gajah_temp"
WEB_ROOT="$HOME/Documents/www"

# Hash variables (Placeholders - user will match them later)
APACHE_HASH="555bbfa74fa464ac3ccedd3c009f960b6e3666777d20ef9179e85861f0fe6604"
MYSQL_HASH="91241b6c1d6d18f61ad5cd7edd953e6dd1b1845f5980eda1e68f5d7f3bb88b83"
PHPMYADMIN_HASH="6b99534f72ffb1d7275f50d23ca4141e1495c97d7cadb73a41d6dc580ed5ce29"
DBEAVER_HASH="REPLACE_WITH_HASH"
GAJAHWEB_HASH="2144b83c07f7fc99c9365547a3a7b8303d1f3181258ac0843de459d5d2727b3b"

APACHE_URL="https://github.com/yohanesokta/PHP-Apache_Binaries_Static/releases/download/build-20251229-7/apache-php-linux_x86-64.tar.gz"
MYSQL_URL="https://github.com/yohanesokta/WebServices-Gajah/releases/download/runtime/mariadb-10.11.16-linux-systemd-x86_64.tar.gz"
PHPMYADMIN_URL="https://github.com/yohanesokta/WebServices-Gajah/releases/download/runtime/phpMyAdmin-5.2.2-all-languages.zip"
PHPMYADMIN_CONFIG_URL="https://github.com/yohanesokta/WebServices-Gajah/releases/download/runtime/config.inc.php"
DBEAVER_URL="https://dbeaver.io/files/dbeaver-ce-latest-linux.gtk.x86_64.tar.gz"
GAJAHWEB_APP_URL="https://github.com/yohanesokta/WebServices-Gajah/releases/download/v2.1/gajahweb-linux_x86-64.tar.gz"

APACHE_ARCHIVE="$TEMP_DIR/apache-php-linux_x86-64.tar.gz"
MYSQL_ARCHIVE="$TEMP_DIR/mariadb-10.11.16-linux-systemd-x86_64.tar.gz"
PHPMYADMIN_ARCHIVE="$TEMP_DIR/phpmyadmin-5.2.3.zip"

### ===============================
### UI HELPERS
### ===============================

bold() { echo -e "\033[1m$1\033[0m"; }
green() { echo -e "\033[32m$1\033[0m"; }
yellow() { echo -e "\033[33m$1\033[0m"; }
red() { echo -e "\033[31m$1\033[0m"; }

step() {
  echo
  bold "[STEP] $1"
}
ok() { green "[OK] $1"; }

CURRENT_FILE=""
die() {
  red "[ERROR] $1"
  if [ -f "$CURRENT_FILE" ]; then
    yellow "Removing corrupt file: $CURRENT_FILE"
    rm -f "$CURRENT_FILE"
  fi
  exit 1
}

### ===============================
### UTIL
### ===============================

verify_hash() {
  local file="$1" expected="$2"
  if [ "$expected" = "REPLACE_WITH_HASH" ] || [ -z "$expected" ]; then
    return 0
  fi
  if ! command -v sha256sum >/dev/null 2>&1; then
    yellow "sha256sum not found, skipping hash verification"
    return 0
  fi
  local actual
  actual=$(sha256sum "$file" | awk '{print $1}')
  if [ "$actual" != "$expected" ]; then
    return 1
  fi
  return 0
}

download() {
  local url="$1" out="$2" expected_hash="$3"
  CURRENT_FILE="$out"

  if [ -f "$out" ]; then
    if verify_hash "$out" "$expected_hash"; then
      ok "Using cached file: $(basename "$out")"
      CURRENT_FILE=""
      return 0
    else
      yellow "Hash mismatch for $(basename "$out"), re-downloading..."
      rm -f "$out"
    fi
  fi

  if command -v wget >/dev/null 2>&1; then
    wget -q --show-progress -O "$out" "$url"
  elif command -v curl >/dev/null 2>&1; then
    curl -L --progress-bar "$url" -o "$out"
  else
    die "wget atau curl tidak ditemukan"
  fi

  if ! verify_hash "$out" "$expected_hash"; then
    die "Hash verification failed for $out"
  fi
  CURRENT_FILE=""
}

extract() {
  local archive="$1" dest="$2"
  CURRENT_FILE="$archive"
  if command -v pv >/dev/null 2>&1; then
    pv "$archive" | sudo tar -xzf - -C "$dest"
  else
    sudo tar -xzf "$archive" -C "$dest"
  fi
  CURRENT_FILE=""
}

### ===============================
### DETECT OS (NGINX)
### ===============================
detect_os() {
  [ -f /etc/os-release ] || die "OS tidak dikenali"
  . /etc/os-release
  OS_ID="$ID"
  OS_LIKE="$ID_LIKE"
}

install_nginx_debian() {
  sudo apt update -y
  sudo apt install -y nginx net-tools libsqlite3-0 libsqlite3-dev
}

install_nginx_rhel() {
  if command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y nginx net-tools sqlite sqlite-devel
  else
    sudo yum install -y epel-release
    sudo yum install -y nginx net-tools sqlite sqlite-devel
  fi
}

install_nginx_arch() {
  step "Installing Nginx (Arch / EndeavourOS)"
  sudo pacman -Sy --noconfirm nginx net-tools sqlite
  ok "Nginx installed"
}

install_nginx_alpine() {
  sudo apk update
  sudo apk add nginx net-tools sqlite-libs sqlite-dev
}

start_nginx() {
  if command -v systemctl >/dev/null 2>&1; then
    sudo systemctl enable nginx
    sudo systemctl restart nginx
  else
    sudo nginx
  fi
}

### ===============================
### START
### ===============================
clear
bold "Gajah Web Services Installer"
echo "----------------------------------------"
echo "Apache + PHP + MariaDB + phpMyAdmin + Nginx"

### ===============================
### PREPARE
### ===============================
step "Preparing directories"
mkdir -p "$TEMP_DIR"
mkdir -p "$WEB_ROOT"
sudo mkdir -p "$RUNTIME_DIR"

# Fix "Forbidden" issue by ensuring parent directories are executable (traversable)
# and web root is readable.
chmod o+x "$HOME"
chmod o+x "$HOME/Documents"
chmod -R 755 "$WEB_ROOT"

ok "Directories ready"

if [ -d "$RUNTIME_DIR/utils" ]; then
  echo "$RUNTIME_DIR/utils exists."
else
  step "Cloning Scripts Repository"
  cd "$RUNTIME_DIR"
  sudo mkdir -p "$RUNTIME_DIR/utils"
  sudo chmod 777 -R "$RUNTIME_DIR/utils"
  git clone https://github.com/yohanesokta/utils_gajahweb.git --depth 1 "$RUNTIME_DIR/utils"
  ok "Scripts Repository cloned"
fi

### ===============================
### APACHE + PHP
### ===============================
step "Downloading Apache + PHP runtime"
download "$APACHE_URL" "$APACHE_ARCHIVE" "$APACHE_HASH"
ok "Apache + PHP downloaded"

step "Extracting Apache + PHP runtime"
extract "$APACHE_ARCHIVE" "$RUNTIME_ROOT"
ok "Apache + PHP installed"

sudo mkdir -p "$RUNTIME_DIR/php/session"
sudo chmod 777 "$RUNTIME_DIR/php/session"
ok "PHP session directory ready"

step "Configuring PHP (php.ini)"
# Copy pre-configured php.ini from the utils repository
sudo cp "$RUNTIME_DIR/utils/baseconfig/unix/php.ini" "$RUNTIME_DIR/php/lib/php.ini"
ok "PHP configured (Using pre-configured php.ini from utils)"

step "Configuring Apache Web Root"
sudo "$RUNTIME_DIR/utils/unix/configure_apache.sh" "$WEB_ROOT" 80
ok "Apache configured with web root: $WEB_ROOT"

### ===============================
### PHPMYADMIN
### ===============================
step "Downloading phpMyAdmin"
download "$PHPMYADMIN_URL" "$PHPMYADMIN_ARCHIVE" "$PHPMYADMIN_HASH"
ok "phpMyAdmin downloaded"

step "Extracting phpMyAdmin"
sudo mkdir -p "$WEB_ROOT"
# Clean up existing phpmyadmin dir if exists
if [ -d "$WEB_ROOT/phpmyadmin" ]; then
  sudo rm -rf "$WEB_ROOT/phpmyadmin"
fi

# Extract and find the directory name (it might vary)
sudo unzip -q "$PHPMYADMIN_ARCHIVE" -d "$WEB_ROOT"
EXTRACTED_DIR=$(find "$WEB_ROOT" -maxdepth 1 -type d -name "phpMyAdmin-*" | head -n 1)

if [ -n "$EXTRACTED_DIR" ]; then
  sudo mv "$EXTRACTED_DIR" "$WEB_ROOT/phpmyadmin"
  ok "phpMyAdmin installed in $WEB_ROOT/phpmyadmin"
else
  die "Could not find extracted phpMyAdmin directory in $WEB_ROOT"
fi

step "Configuring phpMyAdmin"
sudo cp "$RUNTIME_DIR/utils/baseconfig/unix/default/config.inc.conf" \
  "$WEB_ROOT/phpmyadmin/config.inc.php"
ok "phpMyAdmin configuration ready"

### ===============================
### MARIADB
### ===============================
step "Downloading MariaDB runtime"
download "$MYSQL_URL" "$MYSQL_ARCHIVE" "$MYSQL_HASH"
ok "MariaDB downloaded"

step "Extracting MariaDB runtime"
extract "$MYSQL_ARCHIVE" "$RUNTIME_DIR"

sudo ln -sf \
  "$RUNTIME_DIR/mariadb-10.11.16-linux-systemd-x86_64" \
  "$RUNTIME_DIR/mysql"

ok "MariaDB runtime installed"

### ===============================
### MARIADB USER
### ===============================
step "Configuring MariaDB system user"
getent group mysql >/dev/null || sudo groupadd mysql
id mysql >/dev/null 2>&1 || sudo useradd -r -g mysql -s /bin/false mysql
ok "MariaDB user ready"

### ===============================
### MARIADB INIT
### ===============================
step "Initializing MariaDB data directory"
sudo "$RUNTIME_DIR/mysql/scripts/mysql_install_db" \
  --user=mysql \
  --basedir="$RUNTIME_DIR/mysql" \
  --datadir="$RUNTIME_DIR/mysql/data"
ok "MariaDB initialized (root password kosong)"

sudo -u mysql "$RUNTIME_DIR/mysql/bin/mysqld_safe" --basedir="$RUNTIME_DIR/mysql" &
sleep 3
sudo -u root "$RUNTIME_DIR/mysql/bin/mysql" -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'root123'; FLUSH PRIVILEGES;"
ok "MariaDB root password diset ke 'root123'"
sleep 2
sudo "$RUNTIME_DIR/mysql/bin/mysqladmin" -u root -proot123 shutdown

### ===============================
### NGINX
### ===============================
step "Installing Nginx"
detect_os

case "$OS_ID" in
ubuntu | debian | linuxmint)
  install_nginx_debian
  ;;
centos | rhel | rocky | almalinux | fedora)
  install_nginx_rhel
  ;;
alpine)
  install_nginx_alpine
  ;;
arch | endeavouros | manjaro)
  install_nginx_arch
  ;;
*)
  if [[ "$OS_LIKE" == *debian* ]]; then
    install_nginx_debian
  elif [[ "$OS_LIKE" == *rhel* ]]; then
    install_nginx_rhel
  elif [[ "$OS_LIKE" == *arch* ]]; then
    install_nginx_arch
  else
    die "OS tidak didukung untuk Nginx: $OS_ID"
  fi
  ;;
esac

start_nginx
sudo systemctl disable --now nginx
ok "Nginx installed"

step "Configuring Gajah runtime scripts"
sudo mv "$RUNTIME_DIR/utils/baseconfig/unix/default/php-cgi.sh" "$RUNTIME_DIR/php-cgi.sh"
sudo chmod +x "$RUNTIME_DIR/php-cgi.sh"

if [ -f /etc/nginx/nginx.conf ]; then
  sudo mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
fi
sudo "$RUNTIME_DIR/utils/unix/configure_nginx.sh" "$WEB_ROOT" 80
sudo systemctl restart nginx

ok "Gajah runtime scripts ready"

step "Installing DBeaver (Database Client)"
download "$DBEAVER_URL" "$TEMP_DIR/dbeaver.tar.gz" ""
sudo tar -xzf "$TEMP_DIR/dbeaver.tar.gz" -C "/opt/runtime"
ok "DBeaver installed in /opt/runtime/dbeaver"

step "Installing GajahWeb Application"
download "$GAJAHWEB_APP_URL" "$TEMP_DIR/gajahweb-linux_x86-64.tar.gz" "$GAJAHWEB_HASH"
sudo mkdir -p "$RUNTIME_DIR/bin"
sudo tar -xzf "$TEMP_DIR/gajahweb-linux_x86-64.tar.gz" -C "$RUNTIME_DIR/bin"
if [ -f "$RUNTIME_DIR/bin/data/flutter_assets/resource/gajahweb.desktop" ]; then
  sudo cp "$RUNTIME_DIR/bin/data/flutter_assets/resource/gajahweb.desktop" "/usr/share/applications/gajahweb.desktop"
fi
ok "GajahWeb Application installed in /opt/runtime/gajahweb"

### ===============================
### CLEANUP
### ===============================
if [ -d "$TEMP_DIR" ]; then
  step "Cleaning up temporary files"
  rm -rf "$TEMP_DIR"
  ok "Temporary files removed"
fi

### ===============================
### DONE
### ===============================

echo
green "Web Services installation completed!"
echo "----------------------------------------"
echo "Apache + PHP + MariaDB + phpMyAdmin + Nginx sudah terpasang. Coba Lihat Di Menu Aplikasi Anda!."
echo
echo "CLI:"
echo "  Start Apache : /opt/apache/bin/httpd"
echo "  Start MariaDB: $RUNTIME_DIR/mysql/bin/mysqld_safe &"
echo "  Nginx test   : curl http://localhost"
echo
echo "Gajah runtime siap dipakai."
