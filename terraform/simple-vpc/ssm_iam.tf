data "aws_iam_policy_document" "aws_ssm_assume_policy_document" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = [
      "sts:AssumeRole"
    ]
  }
}

resource "aws_iam_role" "aws_ssm_role" {
  name               = "SSMInstanceProfile"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.aws_ssm_assume_policy_document.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
}

resource "aws_iam_instance_profile" "aws_ssm_profile" {
  name = "SSMInstanceProfile"
  role = aws_iam_role.aws_ssm_role.name
}
