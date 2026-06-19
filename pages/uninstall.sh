#!/usr/bin/env bash
set -e

RUNTIME_DIR="/opt/runtime"
APACHE_DIR="/opt/apache"
WEB_ROOT="$HOME/Documents/www"
DESKTOP_FILE="/usr/share/applications/gajahweb.desktop"

bold() { echo -e "\033[1m$1\033[0m"; }
green() { echo -e "\033[32m$1\033[0m"; }
yellow() { echo -e "\033[33m$1\033[0m"; }
red() { echo -e "\033[31m$1\033[0m"; }

step() {
  echo
  bold "[STEP] $1"
}
ok() { green "[OK] $1"; }

clear
bold "Gajah Web Services Uninstaller"
echo "----------------------------------------"

step "Stopping Gajah Web Services processes"
if pgrep -f "mysqld" >/dev/null; then
  yellow "Stopping MariaDB/MySQL processes..."
  sudo pkill -f "mysqld" || true
fi

if pgrep -f "httpd" >/dev/null; then
  yellow "Stopping Apache processes..."
  sudo pkill -f "httpd" || true
fi

if pgrep -f "php-cgi" >/dev/null; then
  yellow "Stopping PHP-CGI processes..."
  sudo pkill -f "php-cgi" || true
fi
ok "Processes stopped"

if [ -f /etc/nginx/nginx.conf.bak ]; then
  step "Restoring original Nginx configuration"
  sudo mv /etc/nginx/nginx.conf.bak /etc/nginx/nginx.conf
  if command -v systemctl >/dev/null 2>&1; then
    sudo systemctl restart nginx || true
  else
    sudo nginx -s reload || true
  fi
  ok "Nginx configuration restored"
fi

if [ -f "$DESKTOP_FILE" ]; then
  step "Removing Desktop application shortcut"
  sudo rm -f "$DESKTOP_FILE"
  ok "Shortcut removed: $DESKTOP_FILE"
fi

step "Removing runtime directories"
if [ -d "$RUNTIME_DIR" ]; then
  yellow "Deleting $RUNTIME_DIR..."
  sudo rm -rf "$RUNTIME_DIR"
fi

if [ -d "$APACHE_DIR" ]; then
  yellow "Deleting $APACHE_DIR..."
  sudo rm -rf "$APACHE_DIR"
fi

if [ -d "$WEB_ROOT/phpmyadmin" ]; then
  yellow "Deleting phpMyAdmin from web root..."
  sudo rm -rf "$WEB_ROOT/phpmyadmin"
fi
ok "Runtime directories removed"

echo
green "Web Services uninstallation completed!"
echo "----------------------------------------"
