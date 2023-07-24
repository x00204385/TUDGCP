# IAC on GCP
Terraform code to deploy infrastructure that can run various workloads. The code has two modules - one creates a managed instance group
behind a load balancer which runs a provided script to deploy Wordpress. The second deployes a GKE cluster and is used to deploy the same 
application (Wordpress). The Wordpress deployment is integrated with Google Cloud Services - Cloud SQL for MySQL support, Google File store for 
shareable storage. The shareable storage is implemented using a PVC in the K8S deployment. There are additional examples of applications to deploy
on the Kubernetes cluster - Kubernetes dashboard, a hello world service and a microservices retail application sample.

The code is used to deploy infrastructure in two regions - a primary and a secondary. The parameters for each region are defined in .tfvars files.

Terraform workspaces are used to keep the Terraform state files separate for each region.

To create the infrastructure

```sh
terraform workspace select [europe-west1.tfvars | us-central1.tfvars]
terraform apply -var-file [europe-west1.tfvars | us-central1.tfvars]
terraform output
kubectl get nodes
```
Browse to the load balancer IP to install the Wordpress application. See the ../k8s directory for the deployment of the Kubernetes workloads.

The deployment code updates the kubeconfig file to add a context for each created GKE cluster. 
