# DOWNLOADING AND BUILDING APACHE WITH PHP MODULE
RUNTIME_DIR="/opt/"

wget "https://downloads.php-apache-x86_64.tar.gz" -O /linux/php-apache-x86_64.tar.gz
tar -xzvf /linux/php-apache-x86_64.tar.gz -C "$RUNTIME_DIR"
echo "✅ PHP Apache module installed"