#!/bin/bash
echo "Running startup script"
sudo apt update -y
sudo apt update && sudo apt install -y nfs-common
sudo apt update && sudo apt install -y php libapache2-mod-php php-mysql
echo "Creating wordpress directory"
sudo mkdir -p /var/www/html/wordpress
echo "Executing mount command"
sudo mount -o rw,intr,hard,timeo=600,retrans=3,rsize=262144,wsize=1048576,resvport ${mount_point}:/wordpress /var/www/html/wordpress
echo "Mount command complete"
sudo apt install -y mysql-client
sudo apt install -y php libapache2-mod-php php-mysql
sudo apt install -y apache2
cd /tmp
sudo curl -O https://wordpress.org/latest.tar.gz
sudo tar xf latest.tar.gz -C /var/www/html
sudo cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
cd /var/www/html/wordpress
sudo sed -i 's/database_name_here/wp/g' wp-config.php
sudo sed -i 's/username_here/wp_user/g' wp-config.php
sudo sed -i 's/password_here/Computing1/g' wp-config.php
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/
sudo touch /tmp/startup_done
