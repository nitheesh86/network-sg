terraform {
  required_version = "~> 0.12"
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "nitheeshp"
    workspaces { prefix = "sg-" }
  }
}

provider "aws" {
  region = "ap-south-1"
}

module "security_group" {
  source = "github.com/nitheesh86/terraform-modules/modules/sg"

  name        = "security-group"
  environment = "dev"
  label_order = ["name", "environment"]

  enable_security_group = true
  vpc_id                = "vpc-0bcfc7dacc703ade8"
  protocol              = "tcp"
  description           = "Instance default security group (only egress access is allowed)."
  allowed_ip            = ["172.16.0.0/16", "10.0.0.0/16"]
  allowed_ipv6          = ["2405:201:5e00:3684:cd17:9397:5734:a167/128"]
  allowed_ports         = [22, 27017]
}
