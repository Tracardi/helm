## Add private docker hub

```
kubectl create secret docker-registry tracardi-dockerhub \
    --docker-server=index.docker.io/v1/  \
    --docker-username=tracardi \
    --docker-password=<password> \
    -n tracardi
```

Add `tracardi-dockerhub` as tracardi.dockerHubSecret in values. 

```
helm upgrade --wait --timeout=1200s --install --values mtsilesia-tracardi.yaml tracardi --namespace tracardi tracardi --create-namespace
```