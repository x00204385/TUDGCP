```sh
kubectl apply -k .
echo Will also need to apply the patches in ../patch-dashboard
kubectl port-forward -n kubernetes-dashboard service/kubernetes-dashboard 8080:443
kubectl create token eks-admin -n kube-system | pbcopy
```

