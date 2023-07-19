# Test service behaviour
#
Get the list of pod IP addresses
```sh
kubectl get pods -l app=hostnames \
    -o go-template='{{range .items}}{{.status.podIP}}{{"\n"}}{{end}}'
```

Will get something like:

```
10.244.0.5
10.244.0.6
10.244.0.7
```

Create the service:

```sh
kubectl expose deployment hostnames --port=80 --target-port=9376
```

```sh
kubectl get svc hostnames
kubectl run -it --rm --restart=Never busybox --image=gcr.io/google-containers/busybox sh
```

In the busybox pod

```
for ep in 10.244.0.5:9376 10.244.0.6:9376 10.244.0.7:9376; do
    wget -qO- $ep
done
```

