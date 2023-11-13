# Tracardi Helm Chart

This Helm chart includes the installation of all commercial Docker containers for Tracardi. Before starting, ensure that Elasticsearch, Redis, and Apache Pulsar are installed. If you prefer to begin with non-production-ready versions of Elasticsearch, Redis, and Apache Pulsar, standalone versions of these services are available within this Helm chart.

## Installing dependencies

Tracardi relies on Elasticsearch, Redis, and Apache Pulsar. The following installation guide covers setting up standalone versions of these dependencies. While this setup isn't suitable for production environments, it is adequate for testing purposes with Tracardi.

### Redis installation

```
kubectl create ns redis-standalone
kubectl apply -f redis/standalone/redis-standalone.yaml -n redis-standalone
```

This will install single, with credentials,  without persistance instance of redis.

### Apache Pulsar installation

```
kubectl create ns pulsar-standalone
kubectl apply -f pulsar/standalone/pulsar-standalone.yaml -n pulsar-standalone
```

This will install single, with credentials,  without persistance instance of apache pulsar.


### Elasticsearch installation

```
kubectl create ns elastic-standalone
kubectl apply -f elastic/standalone/es-standalone.yaml -n elastic-standalone
```

This will install single, with credentials,  without persistance instance of elastic search.


## Tracardi namespace

Create tracardi namespace

```
kubectl create ns tracardi
```

## Docker hub credentials

Add dockerhub credentials to the tracardi namespace.

```
kubectl create secret docker-registry tracardi-dockerhub \
    --docker-server=index.docker.io/v1/  \
    --docker-username=tracardi \
    --docker-password=<password> \
    -n tracardi
```

Replace `<password>` with the password provided by the vendor.


## Tracardi installation

Run the command below. This will install Tracardi with default configuration.

```
helm upgrade --wait --timeout=1200s --install --namespace tracardi tracardi --create-namespace
```


## Configuration

To tweak tracardi configuration create `values.yaml` file. See the template in `tracardi/values.yaml`. It contains configuration for all the dokcer services.

### Values description

#### Elasticsearch Configuration

* name: Identifier for the Elasticsearch instance (e.g., es1).
* host: Host address of the Elasticsearch service.
* schema: Protocol used (http).
* authenticate: Indicates whether authentication is enabled (false).
* port: Port on which Elasticsearch is running (9200).
* verifyCerts: Determines if SSL certificates are to be verified ("no").

#### Redis Configuration

* name: Identifier for the Redis instance (e.g., rd1).
* host: Host address of the Redis service.
* schema: Protocol used (redis://).
* authenticate: Indicates whether authentication is enabled (false).
* port: Port on which Redis is running (6379).
* db: Database number to be used ("0").

#### Pulsar Configuration

* name: Identifier for the Pulsar instance (e.g., ps1).
* host: Host address of the Pulsar service.
* schema: Protocol used (pulsar://).
* authenticate: Indicates whether authentication is enabled (false).
* port: Port on which Pulsar is running (6650).

#### Digital Ocean Configuration

* loadBalancer: Enable or disable the use of a load balancer (false).
* certId: Digital Ocean Certificate ID for SSL, if any.

#### Secrets Configuration

* installationToken: Secret token for installation ("<SET-INSTALLATION-SECRET>").
* dockerHub: Docker Hub secret key (default "tracardi-dockerhub").
* license: Contains licenseKey.
* tms: Contains tokenKey and apiKey. (none for standalone not multi-tenant setup)
* redis: Contains password. (none for standalone redis)
* elastic: Contains password. (none for standalone elasticsearch)
* pulsar: Contains token. (none for standalone pulsar)
* maxmind: Contains licenseKey and accountId. (optional)

#### General Tracardi Configuration

* config.multiTenant.multi: Enable or disable multi-tenancy ("yes"/"no").

#### API Configuration

* api.image: Contains the repository, pullPolicy, and tag for the API image.
* test: Test configuration with several parameters like enabled, replicas, config (logging level, API docs, etc.), and service port.
* production: Production configuration similar to test but with additional options like elasticSavePool.

#### GUI Configuration

* gui.image: Contains the repository, pullPolicy, and tag for the GUI image.
* console: Configuration for the console with parameters like enabled, replicas, and service port.

#### TMS Configuration

* tms.image: Contains the repository, pullPolicy, and tag for the TMS image.
* docker: Docker configuration for TMS with parameters like enabled, replicas, and config.

#### Job Configuration

* metrics: Configuration for metrics job with parameters like image details, docker config, and schedules.
* segmentation: Configuration for segmentation job with options for conditional and workflow segmentation.

#### Worker Configuration

Multiple worker configurations for different purposes like flusher, storage, workflow, outbound, internal (metrics, scheduler, visitEndScheduler, visitEndedDispatcher, upgrade), and segmentationWorker.


#### Bridge Configuration

* bridge.queue: Configuration for queue bridge with parameters like image details, docker config.

#### Additional Workers

* copingWorker: Configuration for coping worker with parameters like image details, config.
