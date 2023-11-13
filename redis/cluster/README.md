## Install redis

```
helm install redis --namespace redis --create-namespace bitnami/redis
```

Redis can be accessed on the following DNS names from within your cluster:

    redis-master.redis.svc.cluster.local for read/write operations (port 6379)
    redis-replicas.redis.svc.cluster.local for read-only operations (port 6379)

```
helm delete redis --namespace redis
```