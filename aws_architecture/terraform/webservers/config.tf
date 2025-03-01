terraform {
  backend "s3" {
    bucket = "clo835-assignment01"                             // giving the S3 bucket name  to save terraform state
    key    = "terraform/webserver/terraform.tfstate"          // Object name 
    region = "us-east-1"                                     // Region of availability zone 
  } 
}
