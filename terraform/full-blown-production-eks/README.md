# Production ready cluster requirements
* Application pods auto-scaling based on external metrics
* Cluster nodes auto-scaling based on application demands
* IAM users and roles support by EKS cluster
* Kubernetes cluster monitoring and dashboards
* AMI encryption
* Separate POD subnet
* DNS zone and HTTPs

# Getting Access to the cluster
```
aws eks --region us-east-1 update-kubeconfig --name $(terraform output -raw cluster_name)
```

# AWS EKS control plane basics
## Kube-system running pods
* aws-node - https://docs.aws.amazon.com/eks/latest/userguide/pod-networking.html
* coredns - https://aws.amazon.com/premiumsupport/knowledge-center/eks-dns-failure/

# Cluster size consideration

You can find spot instance pricing on AWS’s [spot instance pricing page](https://aws.amazon.com/ec2/spot/pricing/) as well as on the [spot instance advisor page](https://aws.amazon.com/ec2/spot/instance-advisor/). This will help you determine the savings you can achieve in comparison to EC2 pricing on demand. 

# Additional Components
## Scaling
* [Cluster Autoscaler](https://docs.aws.amazon.com/eks/latest/userguide/autoscaling.html#cluster-autoscaler) - required to make sure that cluster has enough capacity all pods can be scheduled
* [Kubernetes Metrics Server](https://docs.aws.amazon.com/eks/latest/userguide/metrics-server.html) - required for HPA (Kubernetes Horizontal Autoscaler)
* [AWS Node Termination Handler](https://github.com/aws/aws-node-termination-handler)
* [KEDA]
## Networking and Load Balancing
* [AWS Load Balancer Controller](https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html)
## Monitoring
* [Prometheus]
* [Grafana]