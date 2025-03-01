
# Default tags
variable "default_tags" {
  default     = {}
  type        = map(any)
  description = "Default tags to be appliad to all AWS resources"
}

# Name prefix
variable "prefix" {
  type        = string
  default     = "assignment1"
  description = "Name prefix"
}

# VPC CIDR range
variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  type        = string
  description = "VPC to host the static web site"
}

# Provision public subnets in custom VPC
variable "public_subnet_cidrs" {
  default     = "10.0.1.0/24"
  type        = string
  description = " CIDRs for the Public Subnet "
}
