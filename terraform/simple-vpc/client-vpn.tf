#resource "aws_ec2_client_vpn_endpoint" "dev-vpn" {
#  description            = "dev-vpn"
#  server_certificate_arn = ""
#  client_cidr_block      = "172.16.0.0/22"

#  authentication_options {
#    type                       = "certificate-authentication"
#    root_certificate_chain_arn = ""
#  }

#  connection_log_options {
#    enabled = false
#  }
#}