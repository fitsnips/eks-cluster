variable "tfstate_name" {
  description = "The name of the s3 bucket this module creates to hold TF state files, not setting a default for this module"
  default     = "company-terraform-state"
}

variable "region" {
  description = "AWS Region we are working in for provider"
  default     = "us-east-1"
}
variable "tags_default" {
  description = "map of tags added to all components managed by this code"
  default = {
    "builtBy"   = "terraform"
    "component" = "terraform-base"
  }
}
