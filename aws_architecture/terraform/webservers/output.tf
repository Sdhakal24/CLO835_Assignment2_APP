# Output to display public Ip addres
output "public_ip" {
  value = aws_instance.web_server.public_ip
}

# Output to show the ECR repository URL for sql
output "ecr_repository_url_sql" {
  value = aws_ecr_repository.sql.repository_url
  description = "The URL of the ECR repository"
}

# Output to show the ECR repository URL for flaskapp
output "ecr_repository_url_flaskapp" {
  value = aws_ecr_repository.flaskapp.repository_url
  description = "The URL of the ECR repository"
}
