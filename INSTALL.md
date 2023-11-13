# Tracardi kubernetes installation

Follow the steps

## Install Helm

Go to: https://helm.sh/docs/intro/install/

or linux install

```
sudo snap install helm --classic
```


## Install redis

```
helm install redis --namespace redis --create-namespace bitnami/redis 
```

Redis can be accessed on the following DNS names from within your cluster:

    redis-master.redis.svc.cluster.local for read/write operations (port 6379)
    redis-replicas.redis.svc.cluster.local for read-only operations (port 6379)

To get your password run:

    export REDIS_PASSWORD=$(kubectl get secret --namespace redis redis -o jsonpath="{.data.redis-password}" | base64 --decode)

## Install elasticsearch

```bash
helm repo add elastic https://helm.elastic.co
helm repo update
```

Install elasticsearch operator

```
kubectl create -f https://download.elastic.co/downloads/eck/2.1.0/crds.yaml
kubectl apply -f https://download.elastic.co/downloads/eck/2.1.0/operator.yaml
```

From k8s folder

```
kubectl apply -f es-namespace.yaml
kubectl apply -f es-cluster.yaml -n elastic
```