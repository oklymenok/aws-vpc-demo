
# Configure kubectl
```
aws eks --region us-east-1 update-kubeconfig --name $(terraform output -raw cluster_name)
```
# New EKS cluster quick start guied
* Check cluster info
```
kubectl cluster-info
```
* Get a list of workers
```
kubectl get nodes
```
* Create a simple php-apache deployment
```
kubectl apply -f https://k8s.io/examples/application/php-apache.yaml
```

* Delete in-cluster service
```
kubectl delete service/php-apache
```

* Create ingress/load balancer for your service and expose it to the internet
```
kubectl expose deployment php-apache --type=LoadBalancer --port=80
```

* Verify that external load balancer was exposed:
```
kubectl describe service php-apache
```

* Check the output of your deployment
```
hostname=$(kubectl get svc/php-apache  -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
curl -v http://$hostname
```

# AWS cli EKS examples
* list deployed clusters
```
aws eks list-clusters
```