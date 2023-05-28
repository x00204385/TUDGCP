#!/bin/bash
#
terraform workspace select europe-west
terraform apply -var-file europe-west1.tfvars --auto-approve
terraform workspace select us-central
terraform apply -var-file us-central1.tfvars --auto-approve
