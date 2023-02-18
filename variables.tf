variable "region" {
  default     = "eu-west-2"
  description = "AWS region"
}

variable "db_password" {
  description = "RDS root user password"
  type = string
  default = "Godisable21"
  sensitive   = true
}
