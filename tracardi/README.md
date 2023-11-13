## Add private docker hub

```
kubectl create ns tracardi-com-082
```

```
kubectl create secret docker-registry tracardi-dockerhub \
    --docker-server=index.docker.io/v1/  \
    --docker-username=tracardi \
    --docker-password=<password> \
    -n tracardi-com-082
```

```
kubectl apply -f 082-t440-secrets.yaml -n tracardi-com-082
```

```
helm template tracardi-com-082 --values 082-t440-tracardi-com.yaml
helm template tracardi-com-082 -s templates/frontend/gui.yaml --values 082-t440-tracardi-com.yaml
```

```
helm upgrade --wait --timeout=1200s --install --values 082-t440-tracardi-com.yaml tracardi-com-082 tracardi-com-082 -n tracardi-com-082
```

# Delete

```
helm delete tracardi-com-082 -n tracardi-com-082
```
