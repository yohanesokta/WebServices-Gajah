#!/usr/bin/env bash
set -e
RUNTIME_ROOT="/opt"
RUNTIME_DIR="/opt/runtime"
TEMP_DIR="$HOME/gajah_temp"

APACHE_URL="https://github.com/yohanesokta/PHP-Apache_Binaries_Static/releases/download/build-20251229-7/apache-php-linux_x86-64.tar.gz"
MYSQL_URL="https://github.com/yohanesokta/WebServices-Gajah/releases/download/runtime/mysql-9.6.0-linux-glibc2.28-x86_64-minimal.tar.xz"

APACHE_ARCHIVE="$TEMP_DIR/apache-php-linux_x86-64.tar.gz"
MYSQL_ARCHIVE="$TEMP_DIR/mysql-9.6.0-linux-glibc2.28-x86_64-minimal.tar.xz"

### ===============================
### UI HELPERS
### ===============================
bold()   { echo -e "\033[1m$1\033[0m"; }
green()  { echo -e "\033[32m$1\033[0m"; }
yellow() { echo -e "\033[33m$1\033[0m"; }
red()    { echo -e "\033[31m$1\033[0m"; }

step() {
  echo
  bold "▶ $1"
}

ok() {
  green "✔ $1"
}

die() {
  red "✖ $1"
  exit 1
}

### ===============================
### UTIL
### ===============================
download() {
  local url="$1"
  local out="$2"

  if command -v wget >/dev/null 2>&1; then
    wget -q --show-progress -O "$out" "$url"
  elif command -v curl >/dev/null 2>&1; then
    curl -L --progress-bar "$url" -o "$out"
  else
    die "wget atau curl tidak ditemukan"
  fi
}

extract() {
  local archive="$1"
  local dest="$2"

  if command -v pv >/dev/null 2>&1; then
    pv "$archive" | sudo tar -xf - -C "$dest"
  else
    sudo tar -xf "$archive" -C "$dest"
  fi
}

### ===============================
### START
### ===============================
clear
bold "🐘 Gajah Runtime Installer"
echo "────────────────────────────────────────"
echo "Apache + PHP + MySQL Runtime"
echo

### ===============================
### PREPARE
### ===============================
step "Preparing directories"
mkdir -p "$TEMP_DIR"
sudo mkdir -p "$RUNTIME_DIR"
ok "Directories ready"

### ===============================
### DOWNLOAD APACHE
### ===============================
step "Downloading Apache + PHP runtime"
# download "$APACHE_URL" "$APACHE_ARCHIVE"
ok "Apache + PHP downloaded"

step "Extracting Apache + PHP runtime"
extract "$APACHE_ARCHIVE" "$RUNTIME_ROOT"
ok "Apache + PHP installed"

### ===============================
### DOWNLOAD MYSQL
### ===============================
step "Downloading MySQL runtime"
# download "$MYSQL_URL" "$MYSQL_ARCHIVE"
ok "MySQL downloaded"

step "Extracting MySQL runtime"
extract "$MYSQL_ARCHIVE" "$RUNTIME_DIR"

sudo ln -s \
  "$RUNTIME_DIR/mysql-9.6.0-linux-glibc2.28-x86_64-minimal" \
  "$RUNTIME_DIR/mysql"

ok "MySQL runtime installed"

### ===============================q
### MYSQL USER
### ===============================
step "Configuring MySQL system user"

if ! getent group mysql >/dev/null; then
  sudo groupadd mysql
fi

if ! id mysql >/dev/null 2>&1; then
  sudo useradd -r -g mysql -s /bin/false mysql
fi

ok "MySQL user ready"

### ===============================
### MYSQL INIT
### ===============================
step "Initializing MySQL data directory"

# sudo chown -R mysql:mysql "$RUNTIME_DIR/mysql-9.6.0-linux-glibc2.28-x86_64-minimal"

sudo "$RUNTIME_DIR/mysql/bin/mysqld" \
  --initialize-insecure \
  --user=mysql \
  # --basedir="$RUNTIME_DIR/mysql" \

ok "MySQL initialized (root password kosong)"

### ===============================
### DONE
### ===============================
echo
green "🎉 Installation completed successfully!"
echo
echo "Next:"
echo "  Start MySQL : $RUNTIME_DIR/mysql/bin/mysqld_safe &"
echo "  Login       : $RUNTIME_DIR/mysql/bin/mysql -u root"
echo
echo "🐘 Runtime siap dipakai."