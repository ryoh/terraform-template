remote_state {
  backend = "s3"
  generate = {
    path      = "backend_override.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = "terraform-state"

    key = "${path_relative_to_include()}/terraform.tfstate"
    region         = "ap-northeast-1"
    encrypt        = true
    dynamodb_table = "terraform-lock-table"
  }
}

generate "provider" {
  path = "provider_override.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::0123456789:role/terragrunt"
  }
}
EOF
}

generate "version" {
  path = "versions.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
terraform {
  required_providers {
    aws = {
      version = "5.3.0"
    }
  }

  required_version = "1.5.0"
}
EOF
}
