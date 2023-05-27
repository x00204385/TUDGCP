#!/bin/bash
terraform workspace select us
terraform destroy -var-file us-central1.tfvars --auto-approve
terraform workspace select eu
terraform destroy -var-file eu-west1.tfvars --auto-approve
gcloud compute networks delete wordpress-vpc
gcloud compute networks list
gcloud compute networks subnets list --network=wordpress-vpc

