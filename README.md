This is the helm chart for Tracardi Customer Data Platform

Is consist of three charts: Tracardi, Tracardi-com, Tracardi-net

# Tracardi

This is the main part of tracardi. It can be configured to use open-source or commercial version depending on the configuration.

If you use open-source version then you do not need to change the image. 

## Configuration 


The values for configuration are as follows:

```yaml
tracardi:
  dockerHubSecret: ""   # DockerHub secret - needed for commercial version 
  license: ""           # License - needed for commercial version        
  logging: "info"       # Logging level
  apiDocs: "no"         # Allow api docs to be visible after install, disable on production
  trackDebug: "yes"     # Leave as yes
  saveLogsInTracardi: "yes" # Leave as yes
  installationToken: "tracardi-install"   # Installation token is used ven system is installed. Set any string you want  
  image:                # What images ad versions to use
    webApi: tracardi/tracardi-api:0.8.0-dev 
    guiApi: tracardi/tracardi-api:0.8.0-dev
    gui: tracardi/tracardi-gui:0.8.0-dev
    worker: tracardi/worker:0.8.0-dev
  replicas:             # How many replicas per service
    webApi: 1           # Web API for collecting data, this scales data collection
    guiApi: 1           # API for GUI - probably do no need many of these
    gui: 1              # GUI
    worker: 1           # Import workers
  port:                 # Ports for services
    webApi: 8585
    guiApi: 8686
    gui: 8787
  workers:             
    webApi: 5
    guiApi: 3
  destination:
    syncPostpone: 5
  pro:
    host: "pro.tracardi.com"
    port: "40000"
  scheduler:
    host: "scheduler.tracardi.com"
  elastic:             # Connection to Elastic search
    host: elastic-cluster-es-http.elastic.svc.cluster.local
    schema: https
    username: elastic
    password: unset
    verifyCerts: "no"
    doCertId: "none"
  redis:              # Connection to Redis
    host: redis://redis-master.redis.svc.cluster.local/0
    password: unset
    port: "6379"
```

PLease pick the values you would like to change and create your own values file. For example:

tracardi-conf.yaml
```
tracardi:
  dockerHubSecret: "tracardi-dockerhub"
  license: "2vY7gAAAA==4H443s2IaA2D5F1Pfz0m8M4C0/c0aW7M8z0U94bDbMaQ8yaE6X064X6KbG0V7fe24186162"
  saveLogsInTracardi: "yes"
  apiDocs: "yes"
  installationToken: "tr298dsk75"
  image:
    webApi: tracardi/com-tracardi-api:0.8.0-dev
    guiApi: tracardi/com-tracardi-api:0.8.0-dev
    gui: tracardi/tracardi-gui:0.8.0-dev
    worker: tracardi/worker:0.8.0-dev
  replicas:
    webApi: 15
    guiApi: 2
    gui: 1
    worker: 2
  elastic:
    host: elastic-cluster-es-http.elastic.svc.cluster.local
    username: elastic
    password: dsjk86839hesa8fsfaf
  redis:
    password: sadkljsad87sdks9s8s
```

This is an example of commercial installation. With commercial image `tracardi/com-tracardi-api:0.8.0` and `license` an `dockerHubSecret`.

## Prerequisites

Before you install tracardi you need to set-up elasticsearch and redis and get its credentials.

### Dockerhub secret

Add `tracardi-dockerhub` secret in `tracardi` namespace. If you do not have namespace create it with `kubectl create ns tracardi`.

Then run:

```
kubectl create secret docker-registry tracardi-dockerhub \
    --docker-server=index.docker.io/v1/  \
    --docker-username=tracardi \
    --docker-password=<password> \
    -n tracardi
```

Replace `<password>` with the password provided by the vendor.

## Helm installation

Run the command below. I assume your configuration is in tracardi-conf.yaml.

```
helm upgrade --wait --timeout=1200s --install --values tracardi-conf.yaml tracardi --namespace tracardi tracardi --create-namespace
```

This will install tracardi with the services but it will not expose the services to the net.

# Tracardi networking

Tracardi is exposed via the ingress. Your k8s must have installed ingress before you continue.

## Configuration

This is the default configuration. You will need to change the domains of each service and ports if needed. 

```yaml
tracardi:
  ingressClassName: ""          # Ingress class, leave empty or remove in config if you would like default class to be used.
  webApi:                       # Collector (Web API)
    domain: track.localhost     # Collector domain
    sslTerminationSecret: ""    # Termination secret. Please see below
    port: 8585                  # Collector port
  guiApi:                       # GUI API
    domain: api.localhost       # GUI API domain
    sslTerminationSecret: ""
    port: 8686                  # GUI port
  gui:
    domain: gui.localhost       # GUI domain
    sslTerminationSecret: ""
    port: 8787                  # GUI port
```


### SSL Termination

If you would like to terminate SSL generate keys for each service:

```
openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 -keyout api-tls.key -out api-tls.crt -subj "/CN=nginxsvc/O=nginxsvc"
```

Notice `"/CN=nginxsvc/O=nginxsvc"` this is the domain name. The domain nam must match host defined in ingress:

More : https://cloud.google.com/kubernetes-engine/docs/how-to/ingress-multi-ssl

Copy them to certs folder and add all secrets to tracardi namespace. Example below:

```
➜  kubectl create secret tls api-tls-secret --key ./tracardi-net/certs/api-tls.key --cert ./tracardi/certs/api-tls.crt -n tracardi
➜  kubectl create secret tls track-tls-secret --key ./tracardi-net/certs/track-tls.key --cert ./tracardi/certs/track-tls.crt -n tracardi
➜  kubectl create secret tls gui-tls-secret --key ./tracardi-net/certs/gui-tls.key --cert ./tracardi/certs/gui-tls.crt -n tracardi
```

If you would like to delete tls secret use this command:

```
kubectl delete secret api-tls-secret -n tracardi
```

Then add `api-tls-secret`, `track-tls-secret`, and `gui-tls-secret` as a SslTerminationSecret in tracardi values, see above.


# Tracardi com

Tracardi com is a set of extensions to tracardi. For example:

* Bridges:
  * Kafka
  * MQTT
  * RabbitMq
* New collectors
  * Async Webhook
  * Async Tracker
  * IMAP
* Workers and jobs
  * Live segmentation
  * Deduplication


## Configuration

```yaml
tracardi:
  dockerHubSecret: ""             # DockerHub secret - needed for commercial version 
  bridge:
    rest:
      image: tracardi/com-bridge-rest:0.8.0-dev
      replicas: 1
      license: ""                 # Leave empty if you do not want to be installed
      worker:
        image: tracardi/com-bridge-rest-worker:0.8.0-dev
        replicas: 2
    queue:
      image: tracardi/com-bridge-queue:0.8.0-dev
      replicas: 1
      license: ""                 # Leave empty if you do not want to be installed
  worker:
    image: tracardi/com-worker:0.8.0-dev
    loggingLevel: "INFO"
    replicas: 1
    destination:
      syncPostpone: 5
  segmentation:
    image: tracardi/com-job-segmentation:0.8.0-dev
    schedule: "*/15 * * * *"
    poolSize: 100
    saveAfterPools: 40
    loggingLevel: "INFO"
  deduplication:
    image: tracardi/com-job-deduplication:0.8.0-dev
    schedule: ""                  # Leave empty if you do not want to be installed
    poolSize: 100
    saveAfterPools: 40
    loggingLevel: "INFO"
  merging:
    image: tracardi/com-job-merging:0.8.0-dev
    schedule: ""
    poolSize: 100
    saveAfterPools: 40
    loggingLevel: "INFO"
  elastic:                      # Connection to elastic
    host: elastic-cluster-es-http.elastic.svc.cluster.local
    schema: https
    port: "9200"
    username: elastic
    password: unset
    verifyCerts: "no"
  redis:                        # Connection to redis
    host: redis://redis-master.redis.svc.cluster.local/1
    password: unset
    port: "6379"
```

If you do not want some services to be installed do not add `license` or make `schedule` empty