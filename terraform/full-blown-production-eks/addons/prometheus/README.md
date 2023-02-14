# Access Prometheus:

* Prom server
```
 export POD_NAME=$(kubectl get pods --namespace monitoring -l "app=prometheus,component=server" -o jsonpath="{.items[0].metadata.name}")
  kubectl --namespace monitoring port-forward $POD_NAME 9090
```

* Get the Alertmanager URL by running these commands in the same shell:
```
  export POD_NAME=$(kubectl get pods --namespace monitoring -l "app=prometheus,component=" -o jsonpath="{.items[0].metadata.name}")
  kubectl --namespace monitoring port-forward $POD_NAME 9093
```

* Get the PushGateway URL by running these commands in the same shell:
```
  export POD_NAME=$(kubectl get pods --namespace monitoring -l "app=prometheus-pushgateway,component=pushgateway" -o jsonpath="{.items[0].metadata.name}")
  kubectl --namespace monitoring port-forward $POD_NAME 9091
```

* Explore available metrics
```
curl http://localhost:9090/api/v1/metadata | jq 
```

* Test simple query
```
sum(rate(container_cpu_usage_seconds_total{container_name!="POD",namespace!=""}[5m])) by (namespace)
```