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
sudo sed -i "s/localhost/${db_ip_address}/g" wp-config.php
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/
#
# Add PHP files to /var/www/html to allow us to see the load balancing and failover behaviour
#
sudo a2enmod rewrite
sudo apt install -y php libapache2-mod-php
sudo mv /var/www/html/index.html /var/www/html/index.html.bak
#
# Create an index.php file which shows the instance that the load balancer is pointing to
#
sudo cat <<'EOF' >/var/www/html/index.php
<!DOCTYPE html>
<html>
<head>
    <title>Welcome to IAC4Fun on GCP!</title>
</head>
<body>
    <h1>Welcome to IAC4Fun on GCP!</h1>
    <?php
    $instance_id = file_get_contents('http://metadata.google.internal/computeMetadata/v1/instance/id', false, stream_context_create(['http' => ['header' => 'Metadata-Flavor: Google']]));
    $instance_ip = file_get_contents('http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/ip', false, stream_context_create(['http' => ['header' => 'Metadata-Flavor: Google']]));
    $public_ip = file_get_contents('http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip', false, stream_context_create(['http' => ['header' => 'Metadata-Flavor: Google']]));
    $availability_zone = file_get_contents('http://metadata.google.internal/computeMetadata/v1/instance/zone', false, stream_context_create(['http' => ['header' => 'Metadata-Flavor: Google']]));
    $region = substr($availability_zone, strrpos($availability_zone, '/') + 1);
    echo "<p>Instance ID: $instance_id</p>";
    echo "<p>Instance IP: $instance_ip</p>";
    echo "<p>Public IP: $public_ip</p>";
    echo "<p>Region: $region</p>";
    echo "<p>Availability Zone: $availability_zone</p>";
    ?>
</body>
</html>
EOF
sudo systemctl restart apache2
sudo touch /tmp/startup_done
