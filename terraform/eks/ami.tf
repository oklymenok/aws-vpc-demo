data "aws_ami" "aws_eks_node_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amazon-eks-node-${local.kubernetes_version}*"]
  }
}

resource "aws_ami_copy" "eks_worker_ami" {
  name              = "eks-node-${local.kubernetes_version}"
  description       = "A copy of ${data.aws_ami.aws_eks_node_ami.id}"
  source_ami_id     = data.aws_ami.aws_eks_node_ami.id
  source_ami_region = local.region

  tags = {
    Name = "eks-node-${local.kubernetes_version}"
  }
}