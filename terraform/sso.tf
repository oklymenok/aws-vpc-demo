# locals {
#   sso_group_name = "Example_Group_0"
# }

# # Get SSO instance and Identity group via lookup
# data "aws_ssoadmin_instances" "this" {}

# output "sso_instance_ids" {
#   value = data.aws_ssoadmin_instances.this.identity_store_ids
# }

# output "sso_isntance_arns" {
#   value = data.aws_ssoadmin_instances.this.arns
# }

# # Get SSO identity store groups
# data "aws_identitystore_group" "this" {
#   identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
#   filter {
#     attribute_path  = "DisplayName"
#     attribute_value = local.sso_group_name
#   }
# }

# output "aws_identitystore_group" {
#   value = data.aws_identitystore_group.this.group_id
# }

# # AWS organization accounts
