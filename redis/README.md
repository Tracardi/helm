## Install redis

```
helm install redis --namespace redis --create-namespace bitnami/redis
```

In commercial version where we have session-end event we need notifications:

```
helm upgrade --wait --timeout=1200s --install redis --namespace redis --create-namespace bitnami/redis --set redisConfig.notify-keyspace-events=Ex
```

Redis can be accessed on the following DNS names from within your cluster:

    redis-master.redis.svc.cluster.local for read/write operations (port 6379)
    redis-replicas.redis.svc.cluster.local for read-only operations (port 6379)