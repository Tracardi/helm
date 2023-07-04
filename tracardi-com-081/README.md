## Add private docker hub

```
kubectl create ns tracardi-com-081
```

```
kubectl create secret docker-registry tracardi-dockerhub \
    --docker-server=index.docker.io/v1/  \
    --docker-username=tracardi \
    --docker-password=<password> \
    -n tracardi-com-081
```

```
kubectl apply -f 081-t440-secrets.yaml -n tracardi-com-081
```

```
helm template tracardi-com-081 --values 081-t440-tracardi-com.yaml
```

```
helm upgrade --wait --timeout=1200s --install --values 081-t440-tracardi-com.yaml tracardi-com-081 tracardi-com-081 -n tracardi-com-081
```

# Delete

```
helm delete tracardi-com-081 -n tracardi-com-081
```
