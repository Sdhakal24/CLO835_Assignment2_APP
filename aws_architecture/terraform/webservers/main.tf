# Define the provider
provider "aws" {
  region = "us-east-1"
}

# Data source for AMI id (Amazon Linux)
data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "clo835-assignment02"
    key    = "terraform/network/terraform.tfstate"
    region = "us-east-1"
  }
}


# Local variables
locals {
  default_tags = merge(
    var.default_tags,
  )
  name_prefix = var.prefix
}


# Launch the web server instances
resource "aws_instance" "web_server" {
  ami           = data.aws_ami.latest_amazon_linux.id
  instance_type = var.instance_type
  # key_name                    = aws_key_pair.web_key.key_name
  subnet_id                   = data.terraform_remote_state.network.outputs.public_subnet_ids
  security_groups             = [aws_security_group.web_server_sg.id]
  associate_public_ip_address = true

  tags = merge(var.default_tags, {
    "Name" = "${var.prefix}-WebServer"
  })
}


# # Define the key pair for SSH access
# resource "aws_key_pair" "web_key" {
#   key_name   = "${var.prefix}-key"
#   public_key = file(var.ssh_public_key_path)
# }



# Create the security group for the web server (K8s Node)
resource "aws_security_group" "web_server_sg" {
  name        = "${local.name_prefix}-web-server-sg"
  description = "Allow necessary inbound traffic for K8s and WebApp"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  # Allow SSH for remote access
  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Restrict this to your IP for better security
  }

  # Allow HTTP traffic (Optional: If you plan to serve a frontend)
  ingress {
    description = "HTTP from everywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow Kubernetes NodePort range (30000-32767)
  ingress {
    description = "Allow NodePort access for Kubernetes services"
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  # Allow MySQL (ClusterIP won't need this, but useful for external debugging)
  ingress {
    description = "Allow MySQL access (for debugging)"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Restrict this if necessary
  }

  # Allow all outbound traffic (default)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.default_tags, {
    "Name" = "${local.name_prefix}-web-server-sg"
  })
}

resource "aws_ecr_repository" "sql" {
  name                 = "sql"  # Choose your repository name
  image_tag_mutability = "MUTABLE"  

  # Optional lifecycle policy (if needed)
  lifecycle {
    prevent_destroy = true  
  }
}

resource "aws_ecr_repository" "flaskapp" {
  name                 = "flaskapp" 
  image_tag_mutability = "MUTABLE"  

  # Optional lifecycle policy (if needed)
  lifecycle {
    prevent_destroy = true 
  }
}
