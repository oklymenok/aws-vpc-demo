# Access grafana

* Setup proxy
```
export POD_NAME=$(kubectl --namespace monitoring get pods -l "app.kubernetes.io/instance=grafana" -o jsonpath="{.items[0].metadata.name}")
kubectl --namespace monitoring port-forward $POD_NAME  3000
```
* Get password
```
kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

* Import 1860 then 8685 dashboards from Grafana.com