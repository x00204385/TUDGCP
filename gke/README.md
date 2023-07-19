# Introduction

Prototype to create GKE cluster and deploy workloads
```sh
cd terraform
terraform apply --auto-approve
gcloud container clusters get-credentials $(terraform output -raw kubernetes_cluster_name) --zone us-central1-a
kubectl get nodes
```

# Deploy the kubernetes dashboard
```sh
kubectl apply -k k8s/dashboard
```

# 
