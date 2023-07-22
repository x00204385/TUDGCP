#/bin/bash
#
kubectl patch deployment -n kube-system metrics-server-v0.5.2  --patch-file patch-metrics-servers.yaml
kubectl patch deployment -n kubernetes-dashboard kubernetes-dashboard --patch-file patch-dashboard.yaml
