#!/bin/bash
#
# Convenience script to create the infrastructure in primary and secondary locations
# terraform workspaces are used to separate the regional infrastructure
# Variable files are used to control the region, subnet CIDRs etc. for each region
#
export GOOGLE_CLOUD_PROJECT=tudproj-380715
export TF_VAR_project_id=$GOOGLE_CLOUD_PROJECT
terraform workspace select europe-west
terraform apply -var-file europe-west1.tfvars --auto-approve
terraform workspace select us-central
terraform apply -var-file us-central1.tfvars --auto-approve
