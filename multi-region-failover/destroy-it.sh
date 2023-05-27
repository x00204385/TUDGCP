#!/bin/bash
#
#
gcloud config set project sciot-375819
#
export REGION_1=us-west1
export REGION_1_ZONE=us-west1-a
export REGION_2=us-east4
export REGION_2_ZONE=us-east4-a
#
gcloud dns record-sets delete failover.example.com --type=A \
    --zone=example-com --quiet

gcloud dns managed-zones delete example-com --quiet

gcloud compute forwarding-rules delete $REGION_1-ilb \
    --region=$REGION_1 --quiet

gcloud compute forwarding-rules delete $REGION_2-ilb \
    --region=$REGION_2 --quiet

gcloud compute backend-services delete $REGION_1-backend-service \
    --region=$REGION_1 --quiet

gcloud compute backend-services delete $REGION_2-backend-service \
    --region=$REGION_2 --quiet

gcloud compute health-checks delete http-hc --quiet

gcloud compute instances delete client-instance --zone=$REGION_1_ZONE --quiet

gcloud compute instance-groups unmanaged delete $REGION_1-instance-group \
    --zone=$REGION_1_ZONE --quiet

gcloud compute instance-groups unmanaged delete $REGION_2-instance-group \
    --zone=$REGION_2_ZONE --quiet

gcloud compute instances delete $REGION_1-instance \
    --zone=$REGION_1_ZONE --quiet

gcloud compute instances delete $REGION_2-instance \
    --zone=$REGION_2_ZONE --quiet

gcloud compute routers nats delete $REGION_1-nat-gw \
    --router=$REGION_1-cloudrouter --region=$REGION_1 --quiet

gcloud compute routers nats delete $REGION_2-nat-gw \
    --router=$REGION_2-cloudrouter --region=$REGION_2 --quiet

gcloud compute routers delete $REGION_1-cloudrouter \
    --region=$REGION_1 --quiet

gcloud compute routers delete $REGION_2-cloudrouter \
    --region=$REGION_2 --quiet

gcloud compute firewall-rules delete allow-ssh allow-http-lb-hc --quiet

gcloud compute networks subnets delete $REGION_1-subnet \
    --region=$REGION_1 --quiet

gcloud compute networks subnets delete $REGION_2-subnet \
    --region=$REGION_2 --quiet

gcloud compute networks delete my-vpc --quiet
