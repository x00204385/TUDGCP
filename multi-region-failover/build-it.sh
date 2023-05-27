#!/bin/bash
#
# 	https://codelabs.developers.google.com/clouddns-failover-policy-codelab#0
#
#
gcloud config set project sciot-375819
#
export REGION_1=us-west1
export REGION_1_ZONE=us-west1-a
export REGION_2=us-east4
export REGION_2_ZONE=us-east4-a
#
gcloud compute networks create my-vpc --subnet-mode custom
#
gcloud compute networks subnets create ${REGION_1}-subnet \
    --network my-vpc \
    --range 10.1.0.0/24 \
    --region $REGION_1

gcloud compute networks subnets create ${REGION_2}-subnet \
    --network my-vpc \
    --range 10.2.0.0/24 \
    --region $REGION_2

#
gcloud compute firewall-rules create allow-http-lb-hc \
    --allow tcp:80 --network my-vpc \
    --source-ranges 10.1.0.0/24,10.2.0.0/24,35.191.0.0/16,130.211.0.0/22 \
    --target-tags=allow-http
#
gcloud compute firewall-rules create allow-ssh \
    --allow tcp:22 --network my-vpc \
    --source-ranges 0.0.0.0/0 \
    --target-tags=allow-ssh
#
# Create NAT to  allow software download. First create cloud routers
#
gcloud compute routers create "${REGION_1}-cloudrouter" \
    --region $REGION_1 --network=my-vpc --asn=65501
#
gcloud compute routers create "${REGION_2}-cloudrouter" \
    --region $REGION_2 --network=my-vpc --asn=65501
#
gcloud compute routers nats create "${REGION_1}-nat-gw" \
    --router="${REGION_1}-cloudrouter" \
    --router-region=$REGION_1 \
    --nat-all-subnet-ip-ranges --auto-allocate-nat-external-ips
#
gcloud compute routers nats create "${REGION_2}-nat-gw" \
    --router="${REGION_2}-cloudrouter" \
    --router-region=$REGION_2 \
    --nat-all-subnet-ip-ranges --auto-allocate-nat-external-ips
#
gcloud compute instances create "${REGION_1}-instance" \
    --image-family=debian-11 --image-project=debian-cloud \
    --machine-type=e2-medium \
    --zone=$REGION_1_ZONE \
    --network-interface=network=my-vpc,subnet=${REGION_1}-subnet,no-address \
    --tags=allow-http \
    --metadata=startup-script='#! /bin/bash
    apt-get update
    apt-get install apache2 -y
    a2ensite default-ssl
    a2enmod ssl
    vm_hostname="$(curl -H "Metadata-Flavor:Google" \
    http://169.254.169.254/computeMetadata/v1/instance/name)"
    echo "Page served from: $vm_hostname" | \
    tee /var/www/html/index.html
    systemctl restart apache2'
#
gcloud compute instances create "${REGION_2}-instance" \
    --image-family=debian-11 --image-project=debian-cloud \
    --machine-type=e2-medium \
    --zone=$REGION_2_ZONE \
    --network-interface=network=my-vpc,subnet=${REGION_2}-subnet,no-address \
    --tags=allow-http \
    --metadata=startup-script='#! /bin/bash
    apt-get update
    apt-get install apache2 -y
    a2ensite default-ssl
    a2enmod ssl
    vm_hostname="$(curl -H "Metadata-Flavor:Google" \
    http://169.254.169.254/computeMetadata/v1/instance/name)"
    echo "Page served from: $vm_hostname" | \
    tee /var/www/html/index.html
    systemctl restart apache2'
#
#
# Create instance groups and add VMs to them
#
gcloud compute instance-groups unmanaged create \
    "${REGION_1}-instance-group" --zone=$REGION_1_ZONE
#
gcloud compute instance-groups unmanaged create \
    "${REGION_2}-instance-group" --zone=$REGION_2_ZONE
#
gcloud compute instance-groups unmanaged add-instances \
    "${REGION_1}-instance-group" --instances $REGION_1-instance \
    --zone=$REGION_1_ZONE
#
gcloud compute instance-groups unmanaged add-instances \
    "${REGION_2}-instance-group" --instances $REGION_2-instance \
    --zone=$REGION_2_ZONE
#
#
# Create a client VM
#
#
gcloud compute instances create client-instance --image-family=debian-11 \
    --image-project=debian-cloud \
    --zone=$REGION_1_ZONE \
    --network-interface=network=my-vpc,subnet=${REGION_1}-subnet,no-address \
    --tags=allow-ssh \
    --metadata=startup-script='#! /bin/bash
    apt-get update
    apt-get install dnsutils -y'

#
# Create a health check
#
gcloud compute health-checks create http http-hc --port 80
#
#
# Configure backend services
#
#
gcloud compute backend-services create $REGION_1-backend-service \
    --load-balancing-scheme=INTERNAL --protocol=TCP \
    --health-checks=http-hc --region=$REGION_1
#
#
gcloud compute backend-services create $REGION_2-backend-service \
    --load-balancing-scheme=INTERNAL --protocol=TCP \
    --health-checks=http-hc --region=$REGION_2
#
#
gcloud compute backend-services add-backend $REGION_1-backend-service \
    --instance-group=$REGION_1-instance-group \
    --region=$REGION_1 \
    --instance-group-zone=$REGION_1_ZONE
#
gcloud compute backend-services add-backend $REGION_2-backend-service \
    --instance-group=$REGION_2-instance-group \
    --region=$REGION_2 \
    --instance-group-zone=$REGION_2_ZONE
#
#
# Create forwarding rules
#
gcloud compute forwarding-rules create $REGION_1-ilb \
    --region=$REGION_1 \
    --load-balancing-scheme=internal \
    --network=my-vpc \
    --subnet=$REGION_1-subnet \
    --ip-protocol=TCP \
    --ports=80 \
    --backend-service=$REGION_1-backend-service \
    --backend-service-region=$REGION_1 \
    --allow-global-access
#
#
gcloud compute forwarding-rules create $REGION_2-ilb \
    --region=$REGION_2 \
    --load-balancing-scheme=internal \
    --network=my-vpc \
    --subnet=$REGION_2-subnet \
    --ip-protocol=TCP \
    --ports=80 \
    --backend-service=$REGION_2-backend-service \
    --backend-service-region=$REGION_2 \
    --allow-global-access
#
# Create a private DNS zone and DNS records with failover policy
#
gcloud dns managed-zones create example-com \
    --dns-name example.com. --description="My private zone" \
    --visibility=private --networks my-vpc
#
#
gcloud dns record-sets create failover.example.com --ttl 5 --type A \
    --routing-policy-type=FAILOVER \
    --routing-policy-primary-data=$REGION_1-ilb \
    --routing-policy-backup-data="${REGION_1}=${REGION_2}-ilb;${REGION_2}=${REGION_2}-ilb" \
    --routing-policy-backup-data-type=GEO \
    --zone=example-com \
    --enable-health-checking
