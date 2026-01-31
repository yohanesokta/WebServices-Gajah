RUNTIME_DIR="/opt/"
APACHE_URL="https://github.com/yohanesokta/PHP-Apache_Binaries_Static/releases/download/build-20251229-7/apache-php-linux_x86-64.tar.gz"
MYSQL_URL="https://github.com/yohanesokta/WebServices-Gajah/releases/download/runtime/mysql-9.6.0-linux-glibc2.28-x86_64-minimal.tar.xz"

# DOWNLOADING AND BUILDING APACHE WITH PHP MODULE
mkdir -p ~/gajah_temp
wget "$APACHE_URL" -O ~/gajah_temp/php-apache-x86_64.tar.gz
tar -xzvf ~/gajah_temp/php-apache-x86_64.tar.gz -C "$RUNTIME_DIR"
echo "PHP Apache module installed"

# DOWNLOADING AND EXTRACTING MYSQL RUNTIME
RUNTIME_DIR="/opt/runtime/"

wget "$MYSQL_URL"  -O ~/gajah_temp/mysql-9.6.0-linux-glibc2.28-x86_64-minimal.tar.xz
tar -xvf ~/gajah_temp/mysql-9.6.0-linux-glibc2.28-x86_64-minimal.tar.xz -C "$RUNTIME_DIR"
ls -s "$RUNTIME_DIR/mysql-9.6.0-linux-glibc2.28-x86_64-minimal" "$RUNTIME_DIR/mysql"

# SETTING UP MYSQL
cd "$RUNTIME_DIR/mysql"
mkdir -p data
groupadd mysql
useradd -r -g mysql -s /bin/false mysql
chown -R mysql:mysql .
chmod -R 750 .
bin/mysqld --initialize-insecure --user=mysql --basedir="$RUNTIME_DIR/mysql" --datadir="$RUNTIME_DIR/mysql/data"

echo "MySQL runtime installed and initialized"
