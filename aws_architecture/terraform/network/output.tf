

# Output for public subnet ID 
output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

# Output for VPC Id
output "vpc_id" {
  value = module.vpc.vpc_id
}

