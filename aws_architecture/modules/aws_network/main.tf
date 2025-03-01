# Declearing the provider
provider "aws" {
  region = "us-east-1" 
}

# Local variables
locals {
  default_tags = merge(
    var.default_tags,
  )
  name_prefix = "${var.prefix}"
}

# Create the required VPC from this common code. 
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  tags = merge(
    local.default_tags, {
      Name = "${local.name_prefix}-vpc"
    }
  )
}

# Create public subnets for both nonprod and prod VPCs
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_cidr_blocks
  tags = merge(
    local.default_tags, {
      Name = "${local.name_prefix}-public-subnet"
    }
  )
}

# Create the Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = merge(local.default_tags,{
      "Name" = "${local.name_prefix}-igw"
    }
  )
}

# Route table configured to public route traffic to an Internet Gateway (IGW).
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${local.name_prefix}-route-public-route_table"
  }
}

# Route table association
resource "aws_route_table_association" "public_route_table" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_subnet.id
}
