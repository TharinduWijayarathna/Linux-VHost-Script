#!/bin/bash

# Example
# sudo ./create_vhost.sh test.cp /var/www/test/test_app/public 127.0.1.105
# created by klsameera, upgraded by Tharindu

# Request root privileges
[ "$(whoami)" != "root" ] && exec sudo -- "$0" "$@"

# Variables
virtual_domain_name="$1"
web_dir="$2"
id_address="$3"
email_address="tharindu@example.com"  # Replace with your email address
sites_available="/etc/apache2/sites-available/"
sites_enabled="/etc/apache2/sites-enabled/"

# Validate the v-host name
if [ -d "$web_dir$virtual_domain_name" ]; then
    echo "Directory '$web_dir$virtual_domain_name' already exists!"
    exit 1
fi

if [ -f "$sites_available$virtual_domain_name.conf" ]; then
    echo "File '$sites_available$virtual_domain_name' already exists!"
    exit 1
fi

# Create v-host config file
vhost_conf="$sites_available$virtual_domain_name.conf"
echo "<VirtualHost $id_address:80>" > "$vhost_conf"
echo "    DocumentRoot $web_dir" >> "$vhost_conf"
echo "    DirectoryIndex index.php" >> "$vhost_conf"
echo "    ServerName $virtual_domain_name" >> "$vhost_conf"
echo "    ServerAlias www.$virtual_domain_name" >> "$vhost_conf"
echo "    <Directory $web_dir>" >> "$vhost_conf"
echo "        AllowOverride All" >> "$vhost_conf"
echo "        Options Indexes FollowSymLinks" >> "$vhost_conf"
echo "        Require all granted" >> "$vhost_conf"
echo "    </Directory>" >> "$vhost_conf"
echo "    ErrorLog \${APACHE_LOG_DIR}/$virtual_domain_name-error.log" >> "$vhost_conf"
echo "    CustomLog \${APACHE_LOG_DIR}/$virtual_domain_name-access.log combined" >> "$vhost_conf"
echo "</VirtualHost>" >> "$vhost_conf"

# Enable the new virtual host
ln -s "$vhost_conf" "$sites_enabled"
a2ensite "$virtual_domain_name"

# Add a record in the hosts file
echo "$id_address    $virtual_domain_name" >> /etc/hosts

# Reload Apache to apply changes
systemctl reload apache2

# Obtain SSL certificate using Certbot
certbot --apache --non-interactive --agree-tos --email "$email_address" -d "$virtual_domain_name" -d "www.$virtual_domain_name"

# Redirect HTTP to HTTPS in the virtual host config
echo "<VirtualHost *:80>" > "$vhost_conf"
echo "    ServerName $virtual_domain_name" >> "$vhost_conf"
echo "    ServerAlias www.$virtual_domain_name" >> "$vhost_conf"
echo "    Redirect permanent / https://$virtual_domain_name/" >> "$vhost_conf"
echo "</VirtualHost>" >> "$vhost_conf"

# Reload Apache to apply the SSL changes
systemctl reload apache2

echo "The script was executed successfully, and SSL was configured for $virtual_domain_name."
exit 0
