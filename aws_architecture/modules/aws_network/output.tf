
# Output for public subnet Id
output "public_subnet_ids" {
  value = aws_subnet.public_subnet.id
}

#output for VPC Id 
output "vpc_id" {
  value = aws_vpc.main.id
}
