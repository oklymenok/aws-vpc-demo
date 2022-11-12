module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.30.1"

  cluster_name    = local.eks_cluster_name
  cluster_version = local.kubernetes_version

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_irsa = true

  #  Disable additiona nodes security group or we will run into this:
  # 
  #   Events:
  #   Type     Reason                  Age               From                Message
  #   ----     ------                  ----              ----                -------
  #   Warning  SyncLoadBalancerFailed  14s               service-controller  Error syncing load balancer: failed to ensure load balancer: Multiple tagged security groups found for instance i-035b6e84cf3f12234; ensure only the k8s security group is tagged; the tagged groups were sg-0761bffe57ddf3038(eks-cluster-sg-simple-eks-1432746510) sg-06554582ebb6d300a(simple-eks-node-20221013050038264300000004)
  #   Normal   EnsuringLoadBalancer    9s (x2 over 16s)  service-controller  Ensuring load balancer
  #   Warning  SyncLoadBalancerFailed  9s                service-controller  Error syncing load balancer: failed to ensure load balancer: Multiple tagged security groups found for instance i-048f268ee552695d0; ensure only the k8s security group is tagged; the tagged groups were sg-0761bffe57ddf3038(eks-cluster-sg-simple-eks-1432746510) sg-06554582ebb6d300a(simple-eks-node-20221013050038264300000004)
  create_node_security_group = false
  node_security_group_id     = aws_security_group.eks_nodes.id

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"

    # Attach a basic EKS cluster SG to ASG nodes to allow
    # communication within the cluster and worker nodes
    # 
    # https://docs.aws.amazon.com/eks/latest/userguide/sec-group-reqs.html
    attach_cluster_primary_security_group = true
  }

  eks_managed_node_groups = {
    spot = {
      name = "spot-instances"
      instance_types = [
        "t2.micro",
        "t2.small",
        "t3.micro",
        "t3.small",
      ]


      min_size     = 1
      max_size     = 3
      desired_size = 2

      pre_bootstrap_user_data = <<-EOT
      echo 'cheap nodes'
      EOT

      vpc_security_group_ids = [
        aws_security_group.eks_worker_allow_ssh.id
      ]
      capacity_type = "SPOT"
    },
    on_demand = {
      name           = "node-group-t3-medium"
      instance_types = ["t3.medium"]

      min_size     = 1
      max_size     = 3
      desired_size = 2

      pre_bootstrap_user_data = <<-EOT
      echo 'not cheap nodes'
      EOT

      vpc_security_group_ids = [
        aws_security_group.eks_worker_allow_ssh.id
      ]
    },
    # on_demand_t3_xlarge = {
    #   name           = "node-group-t3-xlarge"
    #   instance_types = ["t3.xlarge"]

    #   min_size     = 1
    #   max_size     = 5
    #   desired_size = 3

    #   pre_bootstrap_user_data = <<-EOT
    #   echo 'actually expensive nodes'
    #   EOT

    #   vpc_security_group_ids = [
    #     aws_security_group.eks_worker_allow_ssh.id
    #   ]
    # },
  }
}
