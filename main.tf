# Terraform provider's block 
provider "aws" {
  region = var.region
}

# Data source used to provision the availability zones
data "aws_availability_zones" "available" {}

# VPC module's block
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.77.0"

  name                 = var.vpc_name
  cidr                 = var.cidr
  azs                  = data.aws_availability_zones.available.names
  private_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
}

# Resource block for the DB subnet group
resource "aws_db_subnet_group" "ecommerce" {
  
  subnet_ids = module.vpc.private_subnets

  tags = var.vpc_tag_name

}

# Resource block for the DB security group
resource "aws_security_group" "rds" {
  name   = var.aws_security_group_name
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = var.ingress_from_port
    to_port     = var.ingress_from_port
    protocol    = var.ingress_protocol
    description = "MySQL access from within VPC"
    cidr_blocks = var.ingress_cidr_blocks
  }

  tags = var.aws_security_group_tag_name
}

# Resource block for the parameter group
resource "aws_db_parameter_group" "ecommerce" {
  name   = var.name
  family = var.family

  parameter {
    name  = var.parameter_group_name
    value = var.parameter_group_value
  }
}

# resource block for Db instance (E-commerce)
resource "aws_db_instance" "ecommerce" {
  identifier             = var.identifier
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  backup_retention_period = var.backup_retention_period
  max_allocated_storage  = var.max_allocated_storage
  storage_type           = var.storage_type
  iops                   = var.iops
  storage_encrypted      = var.storage_encrypted
  engine                 = var.engine
  engine_version         = var.engine_version
  multi_az               = var.multi_az
  username               = var.username
  password               = var.db_password
  maintenance_window     = var.maintenance_window
  backup_window          = var.backup_window
  monitoring_role_arn    = aws_iam_role.rds_enhanced_monitoring.arn
  monitoring_interval    = var.monitoring_interval
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  db_subnet_group_name   = aws_db_subnet_group.ecommerce.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = aws_db_parameter_group.ecommerce.name
  publicly_accessible    = var.publicly_accessible
  skip_final_snapshot    = var.skip_final_snapshot
  final_snapshot_identifier = var.final_snapshot_identifier
}

# Resource block for the IAM role attached to the enhanced monitoring role.
resource "aws_iam_role" "rds_enhanced_monitoring" {
  name_prefix        = "rds-enhanced-monitoring-"
  assume_role_policy = data.aws_iam_policy_document.rds_enhanced_monitoring.json
}

resource "aws_iam_role_policy_attachment" "rds_enhanced_monitoring" {
  role       = aws_iam_role.rds_enhanced_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

data "aws_iam_policy_document" "rds_enhanced_monitoring" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}
