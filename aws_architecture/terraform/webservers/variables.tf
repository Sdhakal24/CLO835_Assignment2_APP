# Instance type
variable "instance_type" {
  type        = string
  description = "EC2 Instance type"
  default     = "t2.micro"
}

# Default tags
variable "default_tags" {
  type        = map(string)
  description = "Tags for all resources"
  default     = {}
}


# Name prefix
variable "prefix" {
  type        = string
  default     = "assignment1"
  description = "Name prefix"
}

# SSH Key Path
variable "ssh_public_key_path" {
  type        = string
  description = "Path to the SSH public key file"
  default     = "~/.ssh/id_rsa.pub"
}
