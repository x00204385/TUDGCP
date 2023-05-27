#!/bin/bash
#
gcloud compute networks create wordpress-vpc --subnet-mode=custom --bgp-routing-mode=regional
terraform workspace select eu
terraform apply -var-file eu-west1.tfvars --auto-approve
terraform workspace select us
terraform apply -var-file us-central1.tfvars --auto-approve
gcloud compute networks subnets list --network=wordpress-vpc
