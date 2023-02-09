```
helm upgrade --wait --timeout=1200s --install --values test-tracardi-local.yaml tracardi-local tracardi-local -n test
```

# Delete

```
helm delete tracardi-local -n test
```
