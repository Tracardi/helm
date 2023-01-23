docker run \
-e ELASTIC_HOST = http://192.168.1.190:9200 tracardi/live-deduplication-job:0.7.4-dev

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
helm upgrade --wait --timeout=1200s --install --values mtsilesia-tracardi-com.yaml tracardi-com --namespace tracardi tracardi-com --create-namespace
```

# Delete

```
helm delete tracardi-com --namespace tracardi
```
