locals {
    labels = {
        k8s-addon = "cluster-autoscaler.addons.k8s.io"
        k8s-app = "cluster-autoscaler"
    }
}
data "aws_caller_identity" "current" {}

locals {
#   arn_split = split(":", var.oidc_provider_arn)
#   reversed_arn_split = reverse(local.arn_split)
#   oidc_aud = concat(local.reversed_arn_split[0], ":aud")
}

data "aws_iam_policy_document" "cluster_autoscaler" {
  statement {  
    effect = "Allow"
        actions = [
            "autoscaling:DescribeAutoScalingGroups",
            "autoscaling:DescribeAutoScalingInstances",
            "autoscaling:DescribeLaunchConfigurations",
            "autoscaling:DescribeTags",
            "ec2:DescribeInstanceTypes",
            "ec2:DescribeLaunchTemplateVersions"
            ]
        resources = ["*"]
  }
  
    statement {
        effect = "Allow"
        actions = [
            "autoscaling:SetDesiredCapacity",
            "autoscaling:TerminateInstanceInAutoScalingGroup",
            "ec2:DescribeImages",
            "ec2:GetInstanceTypesFromInstanceRequirements",
            "eks:DescribeNodegroup"
        ]
        resources = ["*"]
    }
}

resource "aws_iam_policy" "cluster_autoscaler" {
    name   = "AmazonEKSClusterAutoscalerPolicy"
    policy = data.aws_iam_policy_document.cluster_autoscaler.json
}

data "aws_iam_policy_document" "ca_assume_policy_document" {
    statement {
        effect = "Allow"
        actions = [
            "sts:AssumeRoleWithWebIdentity"
        ]
        principals {
            type = "Federated"
            identifiers = [var.oidc_provider_arn]
        }
        condition {
            test = "StringEquals"
            variable = "${var.oidc_provider}:aud"
            # variable = local.oidc_aud
            values = ["sts.amazonaws.com"]
        }

        condition {
            test = "StringEquals"
            variable = "${var.oidc_provider}:sub"
            values = ["system:serviceaccount:${var.autoscaler_namespace}:${var.autoscaler_service_account}"]
        }
    }
}

resource "aws_iam_role" "cluster_autoscaler_role" {
    name               = "AmazonEKSClusterAutoscalerRole"
    assume_role_policy = data.aws_iam_policy_document.ca_assume_policy_document.json
    managed_policy_arns = [
        aws_iam_policy.cluster_autoscaler.arn
    ]
}

# Kubernetes resources

resource "kubernetes_secret_v1" "cluster_autoscaler_sa" {
  metadata {
    name = "terraform-example"
    namespace = "${var.autoscaler_namespace}"
    labels = local.labels
  }
}