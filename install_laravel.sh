#!/bin/bash
set -e

sudo apt update -y
sudo apt upgrade -y

sudo apt install -y nginx git curl zip unzip software-properties-common ca-certificates lsb-release apt-transport-https

sudo add-apt-repository ppa:ondrej/php -y
sudo apt update -y
sudo apt install -y php8.3 php8.3-cli php8.3-fpm php8.3-mysql php8.3-xml php8.3-mbstring php8.3-curl php8.3-zip php8.3-bcmath

cd /tmp
curl -sS https://getcomposer.org/installer -o composer-setup.php
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer

sudo apt install -y mysql-server
sudo systemctl enable mysql
sudo systemctl start mysql

DB_NAME="laravel_app"
DB_USER="laravel_putra"
DB_PASS="LaravelTest123!"

sudo mysql -e "CREATE DATABASE ${DB_NAME} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
sudo mysql -e "CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';"
sudo mysql -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt install -y nodejs
sudo npm install -g yarn

sudo mkdir -p /var/www
cd /var/www
sudo composer create-project --prefer-dist laravel/laravel laravel

sudo chown -R www-data:www-data /var/www/laravel
sudo chmod -R 775 /var/www/laravel/storage

cd /var/www/laravel
sudo cp .env.example .env
sudo php artisan key:generate

sudo sed -i "s/DB_DATABASE=.*/DB_DATABASE=${DB_NAME}/" .env
sudo sed -i "s/DB_USERNAME=.*/DB_USERNAME=${DB_USER}/" .env
sudo sed -i "s/DB_PASSWORD=.*/DB_PASSWORD=${DB_PASS}/" .env

NGINX_CONF="/etc/nginx/sites-available/laravel"
sudo bash -c "cat > ${NGINX_CONF}" <<'EOF'
server {
    listen 80;
    server_name _;

    root /var/www/laravel/public;
    index index.php index.html index.htm;

    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-Content-Type-Options "nosniff";

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.3-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOF

sudo ln -sf /etc/nginx/sites-available/laravel /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
sudo systemctl enable nginx
sudo systemctl restart php8.3-fpm

# ------------------------------------------------------------
# Done message
# ------------------------------------------------------------
echo "============================================================"
echo "✅ Laravel installation completed successfully!"
echo "Accessible via: http://$(curl -s ifconfig.me)"
echo "Database: ${DB_NAME}"
echo "User: ${DB_USER}"
echo "Password: ${DB_PASS}"
echo "============================================================"
