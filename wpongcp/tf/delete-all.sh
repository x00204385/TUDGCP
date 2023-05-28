#!/bin/bash
#
terraform workspace select us-central
terraform destroy -var-file us-central1.tfvars --auto-approve
terraform workspace select europe-west
terraform destroy -var-file europe-west1.tfvars --auto-approve
