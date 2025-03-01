# Module to deploy the networking  section in environment 
module "vpc" {
  source             = "../../modules/aws_network"
  vpc_cidr           = var.vpc_cidr
  public_cidr_blocks = var.public_subnet_cidrs
  prefix             = var.prefix
  default_tags       = var.default_tags
}

