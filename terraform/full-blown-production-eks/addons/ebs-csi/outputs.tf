output "ebc_csi_role_arn" {
    description = "EBS CSI Driver role ARN"
    value = aws_iam_role.ebs_cis_driver_role.arn
}