# Default tags
variable "default_tags" {
  default = {}
  type        = map(any)
  description = "Default tags to be appliad to all AWS resources"
}

# Name prefix
variable "prefix" {
  type        = string
  description = "Name prefix"
}


# VPC CIDR range
variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR range"
}


#  public subnets CIDR
variable "public_cidr_blocks" {
  type        = string
}
