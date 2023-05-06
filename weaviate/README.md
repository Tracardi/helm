kubectl create namespace weaviate
helm upgrade weaviate weaviate/weaviate --install --namespace weaviate --values ./weaviate-values.yaml