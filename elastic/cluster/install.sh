kubectl apply -f https://download.elastic.co/downloads/eck/2.1.0/crds.yaml
kubectl apply -f https://download.elastic.co/downloads/eck/2.1.0/operator.yaml
kubectl apply -f es-namespace.yaml
kubectl apply -f es/elastic/es-cluster.yaml -n elastic