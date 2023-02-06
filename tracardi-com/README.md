## Add private docker hub

```
kubectl create secret docker-registry tracardi-dockerhub \
    --docker-server=index.docker.io/v1/  \
    --docker-username=tracardi \
    --docker-password=<password> \
    -n tracardi-com
```

```
helm template tracardi-com --values  mtsilesia-tracardi-com.yaml
```

```
helm upgrade --wait --timeout=1200s --install --values test-tracardi-com.yaml tracardi-com tracardi-com -n test
```

# Delete

```
helm delete tracardi-com --namespace tracardi
```
