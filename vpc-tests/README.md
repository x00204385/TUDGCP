# VPC Tests
Implemented the two region solution this way:
-	Create workspaces for eu and us. 
-	Have a .tfvars file for each region
-	Create the VPC by hand using the console
-	Apply terraform in first one region and then the next. We get 4 subnets in 2 different regions. We can then destroy them using terraform destroy -var-file region.tfvars. 

Script provided to execute this in create-all.sh and destroy it in destroy-all.sh

