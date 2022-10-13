data "aws_availability_zones" "available" {
  state = "available"

  filter {
    name   = "zone-type"
    values = ["availability-zone"]
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.2"

  name = "eks-vpc"

  cidr = "10.10.10.0/24"

  private_subnets = ["10.10.10.0/26", "10.10.10.64/26", "10.10.10.128/26"]
  public_subnets  = ["10.10.10.192/26"]
  azs             = slice(data.aws_availability_zones.available.names, 0, 3)

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  # https://aws.amazon.com/premiumsupport/knowledge-center/eks-vpc-subnet-discovery/
  # 
  public_subnet_tags = {
    "kubernetes.io/cluster/${local.eks_cluster_name}" = "shared"
    "kubernetes.io/role/elb"                          = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.eks_cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"                 = 1
  }
}