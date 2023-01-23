# SSL Termination

If you would like to terminate SSL generate keys:

```
openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 -keyout api-tls.key -out api-tls.crt -subj "/CN=nginxsvc/O=nginxsvc"
```

Notice `"/CN=nginxsvc/O=nginxsvc"` this is the domain name. The domain nam must match host defined in ingress:

More : https://cloud.google.com/kubernetes-engine/docs/how-to/ingress-multi-ssl

Copy them to certs folder

and add all secrets to tracardi namespace

```
➜  kubectl create secret tls api-tls-secret --key ./tracardi-net/certs/api-tls.key --cert ./tracardi/certs/api-tls.crt -n tracardi
secret/api-tls-secret created
➜   kubectl create secret tls track-tls-secret --key ./tracardi-net/certs/track-tls.key --cert ./tracardi/certs/track-tls.crt -n tracardi
secret/track-tls-secret created
➜  kubectl create secret tls gui-tls-secret --key ./tracardi-net/certs/gui-tls.key --cert ./tracardi/certs/gui-tls.crt -n tracardi
```

If you would like to delete tls secret:

```
kubectl delete secret tls-secret -n tracardi
```

Then add `tls-secret` as a SslTerminationSecret in tracardi values. 

# Install

```
helm upgrade --wait --timeout=1200s --install --values mtsilesia-tracardi-net.yaml tracardi-net --namespace tracardi tracardi-net --create-namespace
```

# Delete