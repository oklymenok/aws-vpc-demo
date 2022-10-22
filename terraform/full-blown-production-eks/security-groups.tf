# Base EKS control plane SGs
# resource "aws_security_group" "eks_cluster" {
#   name        = "${local.eks_cluster_name}-${local.env}/ControlPlaneSecurityGroup"
#   description = "Communication between the control plane and worker nodegroups"
#   vpc_id      = module.vpc.vpc_id

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name        = "${local.eks_cluster_name}-${local.env}/ControlPlaneSecurityGroup"
#     Environment = local.env
#   }
# }

# resource "aws_security_group_rule" "cluster_inbound" {
#   description              = "Allow unmanaged nodes to communicate with control plane (all ports)"
#   from_port                = 0
#   protocol                 = "-1"
#   security_group_id        = aws_eks_cluster.eks.vpc_config[0].cluster_security_group_id
#   source_security_group_id = aws_security_group.eks_nodes.id
#   to_port                  = 0
#   type                     = "ingress"
# }

# Base EKS nodes SGs

# Automatically created by EKS module
# node rules inboud:
# TCP 10250 <source-main-eks-cluster-sg>  "Cluster API to node kubelets"
# TCP 53    <source-itself-sg>            "Node to node CoreDNS"
# UDP 53    <source-itself-sg>            "Node to node CoreDNS"
# TCP 443   <source-main-eks-cluster-sg>  "Cluster API to node groups"
#
# node rules outboud:
# TCP 443   <dest-main-eks-cluster-sg>  "Node groups to cluster API"
# UDP 123   0.0.0.0/0                   "Egress NTP/UDP to internet"
# TCP 123   0.0.0.0/0                   "Egress NTP/UDP to internet"
# TCP 443   0.0.0.0/0                   "Egress all HTTPS to internet"
# TCP 53    <dest-itself-sg>            "Node to node CoreDNS"
# UDP 53    <dest-itself-sg>            "Node to node CoreDNS"

resource "aws_security_group" "eks_nodes" {
  name        = "${local.eks_cluster_name}-${local.env}/ClusterSharedNodeSecurityGroup"
  description = "Communication between all nodes in the cluster"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }
}

# Custom Workers SGs
resource "aws_security_group" "eks_worker_allow_ssh" {
  name_prefix = "eks_worker_allow_ssh"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
    ]
  }
}
