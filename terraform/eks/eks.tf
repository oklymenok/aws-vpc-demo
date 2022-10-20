module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.30.1"

  cluster_name    = local.eks_cluster_name
  cluster_version = "1.23"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

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
    default_ami = {
      name = "node-group-t3-small"

      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 3
      desired_size = 2

      pre_bootstrap_user_data = <<-EOT
      echo 'foo bar'
      EOT

      vpc_security_group_ids = [
        aws_security_group.eks_worker_allow_ssh.id
      ]
    },
    encrypted_ami = {
      name = "t3-small-encrypted"
      ami_id = "ami-0d3fca3d4aa81a80a"

      # This will ensure the boostrap user data is used to join the node
      # By default, EKS managed node groups will not append bootstrap script;
      # this adds it back in using the default template provided by the module
      # Note: this assumes the AMI provided is an EKS optimized AMI derivative
      enable_bootstrap_user_data = true

      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 3
      desired_size = 1

      pre_bootstrap_user_data = <<-EOT
      echo 'lol worked'
      EOT

      vpc_security_group_ids = [
        aws_security_group.eks_worker_allow_ssh.id
      ]
    }
  }
}