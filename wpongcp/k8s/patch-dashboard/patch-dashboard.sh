#/bin/bash
#
kubectl patch deployment -n kube-system metrics-server-v0.5.2  --patch-file patch-metrics-servers.yaml
kubectl patch deployment -n kubernetes-dashboard kubernetes-dashboard --patch-file patch-dashboard.yaml
echo kubectl port-forward -n kubernetes-dashboard service/kubernetes-dashboard 8081:443
echo kubectl create token eks-admin -n kube-system | pbcopy
