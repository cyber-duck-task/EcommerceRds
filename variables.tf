variable "region" {
  default     = "eu-west-2"
  description = "AWS region"
}

variable "vpc_name" {
  description = "vpc name"
  type = string
  default = "ecommerce"
}

variable "cidr" {
  description = "vpc cidr block"
  type = string
  default = "10.0.0.0/16"
}

/*variable "private_subnets" {
  description = "a list of vpc private subnet"
  type = list(string)
  default = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}*/

variable "enable_dns_hostnames" {
  description = "enable dns hostname "
  type = bool
  default = true
}

variable "enable_dns_support" {
  description = "enable dns support "
  type = bool
  default = true
}

variable "vpc_tag_name" {
  description = "vpc tag name"
  type = map(string)
  default = {Name = "Ecommerce"}
}

variable "aws_security_group_name" {
  description = "Aws security group name"
  type = string
  default = "ecommerce_rds"
}

variable "ingress_from_port" {
  description = "Ingress from port number"
  type = number
  default = 3306
}

variable "ingress_to_port" {
  description = "Ingress to port number"
  type = number
  default = 3306
}

variable "ingress_protocol" {
  description = "Ingress network protocol"
  type = string
  default = "tcp"
}

variable "egress_from_port" {
  description = "egress from port number"
  type = number
  default = 3306
}

variable "egress_to_port" {
  description = "egress to port number"
  type = number
  default = 3306
}

variable "egress_protocol" {
  description = "egress network protocol"
  type = string
  default = "tcp"
}

variable "aws_security_group_tag_name" {
  description = "AWS security group tag name"
  type = map(string)
  default = {Name = "ecommerce_rds"}
}

variable "name" {
  description = "The name of the database to create when the DB instance is created"
  type = string
  default = "ecommerce"
}

variable "parameter_group_name" {
  description = "Name of the DB parameter group to associate"
  type = string
  default = "character_set_server"
}

variable "parameter_group_value" {
  description = "Value of the DB parameter group to associate"
  type = string
  default = "utf8"
}


variable "family" {
  description = " The family of the DB parameter group"
  type = string
  default = "mysql8.0"
}

variable "username" {
  description = "RDS root username"
  type = string
  default = "admin"
  sensitive   = true
}

variable "db_password" {
  description = "RDS root user password"
  type = string
  default = "R29kaXNhYmxlMjEK"
  sensitive   = true
}

variable "identifier" {
  description = "The name of the RDS instance"
  type = string
  default = "ecommerce"
}

variable "instance_class" {
  description = "RDS instance class"
  type = string
  default = "db.t3.micro"
}

variable "allocated_storage" {
  description = "RDS allocated storage in gibibytes"
  type = number
  default = 20
}

variable "backup_retention_period" {
  description = "Retention period of the backup which is in days"
  type = number
  default = 30
}

variable "max_allocated_storage" {
  description = "maximum limit of the storage"
  type = number
  default = 1000
}

variable "storage_type" {
  description = "gp2 (general purpose SSD)"
  type = string
  default = "gp2"
}

variable "engine" {
  description = "RDS engine type name"
  type = string
  default = "mysql"
}

variable "engine_version" {
  description = "RDS engine version"
  type = string
  default = "8.0.28"
}

variable "multi_az" {
  description = "RDS multi AZ for highly availability and disaster recovery"
  type = bool
  default = true
}

variable "publicly_accessible" {
  description = "This RDS is not publicly accessible to secure the database"
  type = bool
  default = false
}

variable "skip_final_snapshot" {
  description = "This take a copy for the DB instance before it is deleted"
  type = bool
  default = true
}

variable "final_snapshot_identifier" {
  default     = "final-snapshot"
  type        = string
  description = "The name of your final DB snapshot when this DB instance is deleted."
}
