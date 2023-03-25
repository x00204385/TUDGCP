# Wordpress on GCP
Terraform code to implement wordpress on GCP running behind a load balancer configuration

```
terraform apply
# See the list of instances created
gcloud compute instances list
# Connect to the MySQL instance
gcloud compute ssh --zone "europe-west1-b" "mysql-instance"  --project "tudproj-380715"
# Check connection to MySQL database
mysql -u root 
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
| wp                 | <==== wp database created.
+--------------------+
5 rows in set (0.16 sec)
# Check the same from a wordpress instance
sudo mysql -h 10.10.x.x -u wp_user -p
# Connect to webserver-1 and update the wp-config.php file with db, user etc.
# Do the same for webserver-2
# Then check the load balancer URL to confirm apache running
# Verify lburl/wordpress works. Will need to go through initial login.
```
