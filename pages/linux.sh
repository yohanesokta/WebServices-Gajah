#!/usr/bin/env bash
set -e

### ===============================
### PATH & URL
### ===============================
RUNTIME_ROOT="/opt"
RUNTIME_DIR="/opt/runtime"
TEMP_DIR="$HOME/gajah_temp"

APACHE_URL="https://github.com/yohanesokta/PHP-Apache_Binaries_Static/releases/download/build-20251229-7/apache-php-linux_x86-64.tar.gz"
MYSQL_URL="https://github.com/yohanesokta/WebServices-Gajah/releases/download/runtime/mariadb-10.11.16-linux-systemd-x86_64.tar.gz"
PHPMYADMIN_URL="https://files.phpmyadmin.net/phpMyAdmin/5.2.3/phpMyAdmin-5.2.3-all-languages.zip"
PHPMYADMIN_CONFIG_URL="https://github.com/yohanesokta/WebServices-Gajah/releases/download/runtime/config.inc.php"
DBEAVER_URL="https://dbeaver.io/files/dbeaver-ce-latest-linux.gtk.x86_64.tar.gz"
GAJAHWEB_APP_URL="https://github.com/yohanesokta/WebServices-Gajah/releases/download/v2.1/gajahweb-linux_x86-64.tar.gz"

APACHE_ARCHIVE="$TEMP_DIR/apache-php-linux_x86-64.tar.gz"
MYSQL_ARCHIVE="$TEMP_DIR/mariadb-10.11.16-linux-systemd-x86_64.tar.gz"
PHPMYADMIN_ARCHIVE="$TEMP_DIR/phpmyadmin-5.2.3.zip"

### ===============================
### UI HELPERS
### ===============================

bold()   { echo -e "\033[1m$1\033[0m"; }
green()  { echo -e "\033[32m$1\033[0m"; }
yellow() { echo -e "\033[33m$1\033[0m"; }
red()    { echo -e "\033[31m$1\033[0m"; }

step() { echo; bold "▶ $1"; }
ok()   { green "✔ $1"; }
die()  { red "✖ $1"; exit 1; }

### ===============================
### UTIL
### ===============================

download() {
  local url="$1" out="$2"
  if command -v wget >/dev/null 2>&1; then
    wget -q --show-progress -O "$out" "$url"
  elif command -v curl >/dev/null 2>&1; then
    curl -L --progress-bar "$url" -o "$out"
  else
    die "wget atau curl tidak ditemukan"
  fi
}

extract() {
  local archive="$1" dest="$2"
  if command -v pv >/dev/null 2>&1; then
    pv "$archive" | sudo tar -xf - -C "$dest"
  else
    sudo tar -xf "$archive" -C "$dest"
  fi
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
  sudo apt install -y nginx
}

install_nginx_rhel() {
  if command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y nginx
  else
    sudo yum install -y epel-release
    sudo yum install -y nginx
  fi
}

install_nginx_arch() {
  step "Installing Nginx (Arch / EndeavourOS)"

  sudo pacman -Sy --noconfirm nginx

  ok "Nginx installed"
}

install_nginx_alpine() {
  sudo apk update
  sudo apk add nginx
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
echo "────────────────────────────────────────"
echo "Apache + PHP + MariaDB + phpMyAdmin + Nginx"

### ===============================
### PREPARE
### ===============================
step "Preparing directories"
mkdir -p "$TEMP_DIR"
sudo mkdir -p "$RUNTIME_DIR"
ok "Directories ready"

step "Cloning Scripts Repository"
cd "$RUNTIME_DIR"
sudo mkdir -p "$RUNTIME_DIR/utils"
sudo chmod 777 -R "$RUNTIME_DIR/utils"
git clone https://github.com/yohanesokta/utils_gajahweb.git --depth 1 "$RUNTIME_DIR/utils"
ok "Scripts Repository cloned"

### ===============================
### APACHE + PHP
### ===============================
step "Downloading Apache + PHP runtime"
download "$APACHE_URL" "$APACHE_ARCHIVE"
ok "Apache + PHP downloaded"

step "Extracting Apache + PHP runtime"
extract "$APACHE_ARCHIVE" "$RUNTIME_ROOT"
ok "Apache + PHP installed"
sudo mkdir -p "$RUNTIME_DIR/php/session"
sudo chmod 733 "$RUNTIME_DIR/php/session"
ok "PHP session directory ready"

### ===============================
### PHPMYADMIN
### ===============================
step "Downloading phpMyAdmin"
download "$PHPMYADMIN_URL" "$PHPMYADMIN_ARCHIVE"
ok "phpMyAdmin downloaded"

step "Extracting phpMyAdmin"
sudo unzip -q "$PHPMYADMIN_ARCHIVE" -d "$RUNTIME_ROOT/runtime/www"
sudo mv "$RUNTIME_ROOT/runtime/www/phpMyAdmin-5.2.3-all-languages" \
        "$RUNTIME_ROOT/runtime/www/phpmyadmin"
ok "phpMyAdmin installed"

step "Downloading phpMyAdmin configuration"
sudo mv "$RUNTIME_DIR/utils/baseconfig/unix/default/config.inc.php" \
        "$RUNTIME_DIR/www/phpmyadmin/config.inc.php"
        
ok "phpMyAdmin configuration ready"

### ===============================
### MARIADB
### ===============================
step "Downloading MariaDB runtime"
download "$MYSQL_URL" "$MYSQL_ARCHIVE"
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
  ubuntu|debian)
    install_nginx_debian
    ;;
  centos|rhel|rocky|almalinux|fedora)
    install_nginx_rhel
    ;;
  alpine)
    install_nginx_alpine
    ;;
  arch|endeavouros|manjaro)
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
ok "Nginx installed & running"

step "Configuring Gajah runtime scripts"
sudo mv $RUNTIME_DIR/utils/baseconfig/unix/default/php-cgi.sh $RUNTIME_DIR/php-cgi.sh
sudo chmod +x $RUNTIME_DIR/php-cgi.sh

sudo mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
sudo /opt/runtime/utils/unix/configure_nginx.sh /opt/runtime/www 80
sudo systemctl restart nginx

ok "Gajah runtime scripts ready"

step "Installing DBeaver (Database Client)"
download "$DBEAVER_URL" "$TEMP_DIR/dbeaver.tar.gz"
sudo tar -xzf "$TEMP_DIR/dbeaver.tar.gz" -C "/opt/runtime"
ok "DBeaver installed in /opt/runtime/dbeaver"

step "Installing GajahWeb Application"
download "$GAJAHWEB_APP_URL" "$TEMP_DIR/gajahweb-linux_x86-64.tar.gz"
sudo mkdir -p "$RUNTIME_DIR/bin"
sudo tar -xzf "$TEMP_DIR/gajahweb-linux_x86-64.tar.gz" -C "$RUNTIME_DIR/bin"
sudo cp "$RUNTIME_DIR/bin/data/flutter_assets/resource/gajahweb.desktop" "/usr/share/applications/gajahweb.desktop"
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
green "🎉 Web Services installation completed!"
echo
echo "Next:"
echo "  Start Apache : /opt/apache/bin/httpd"
echo "  Start MariaDB: $RUNTIME_DIR/mysql/bin/mysqld_safe &"
echo "  Nginx test   : curl http://localhost"
echo
echo "🐘 Gajah runtime siap dipakai."