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
 
# Test deployment of hello pod

```sh
kubectl apply -f hello
```

Get the list of pod IP addresses
```sh
kubectl get pods -l app=hello-app -o go-template='{{range .items}}{{.status.podIP}}{{"\n"}}{{end}}'
```

Will get something like:

```
10.244.0.5
10.244.0.6
10.244.0.7
```

Create the service:

Run a busyboxy so we can debug within the cluster

```sh
kubectl get svc hostnames
kubectl run -it --rm --restart=Never busybox --image=gcr.io/google-containers/busybox sh
```

In the busybox pod

```
for ep in 10.244.0.5 10.244.0.6 10.244.0.7; do
    wget -qO- $ep:8080
done
```

