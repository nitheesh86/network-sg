terraform {
  required_version = "~> 0.12"
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "nitheeshp"
    workspaces { prefix = "vpc-" }
  }
}

provider "aws" {
  region = "ap-south-1"
}

module "web-sg" {
  source = "github.com/nitheesh86/terraform-modules/modules/sg"

  name        = "computed-http-sg"
  description = "Security group with HTTP port open for everyone, and HTTPS open just for the default security group"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]

  ingress_with_source_security_group_id = [
    {
      rule                     = "https-443-tcp"
      source_security_group_id = data.aws_security_group.default.id
    },
  ]
}
