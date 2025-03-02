#s3 bucket naming and configuration file 
terraform {
  backend "s3" {
    bucket = "clo835-assignment03"                         //  giving S3 bucket name  to save terraform state
    key    = "terraform/network/terraform.tfstate"        // Object name and pathway
    region = "us-east-1"                                 // Region of availability zone 
  }
}
