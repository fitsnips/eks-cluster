# after successful first run comment out this TF block:
terraform {
  required_version = "~> 1.3"

  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 4.0"
    }
  }
}

# after successful first run uncomment out this TF block
# and run another terraform init
# Do you want to copy existing state to the new backend?
#   Pre-existing state was found while migrating the previous "local" backend to the
#   newly configured "s3" backend. No existing state was found in the newly
#   configured "s3" backend. Do you want to copy this state to the new "s3"
#   backend? Enter "yes" to copy and "no" to start with an empty state.

#   Enter a value: yes
# if you changed the region or tfstate_name you will have 
# update this block:
# terraform {
#   required_version = "~> 1.4"

#   backend "s3" {
#     acl                  = "private"
#     bucket               = "infra-k8-poc"
#     dynamodb_table       = "infra-k8-poc"
#     encrypt              = true
#     key                  = "terraform-base/terraform.tfstate"
#     region               = "us-east-1"
#     workspace_key_prefix = "terraform-base"
#   }

#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 4.0"
#     }
#   }
# }
