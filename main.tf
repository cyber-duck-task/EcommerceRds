provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

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

resource "aws_db_subnet_group" "ecommerce" {
  
  subnet_ids = module.vpc.private_subnets

  tags = var.vpc_tag_name

}

resource "aws_security_group" "rds" {
  name   = var.aws_security_group_name
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = var.ingress_from_port
    to_port     = var.ingress_from_port
    protocol    = var.ingress_protocol
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = var.egress_from_port
    to_port     = var.egress_to_port
    protocol    = var.egress_protocol
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.aws_security_group_tag_name
}

resource "aws_db_parameter_group" "ecommerce" {
  name   = var.name
  family = var.family

  parameter {
    name  = var.parameter_group_name
    value = var.parameter_group_value
  }
}

resource "aws_db_instance" "ecommerce" {
  identifier             = var.identifier
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  backup_retention_period = var.backup_retention_period
  max_allocated_storage  = var.max_allocated_storage
  storage_type           = var.storage_type
  storage_encrypted      = var.storage_encrypted
  /* monitoring_role_arn    = var.monitoring_role_arn */
  monitoring_interval    = var.monitoring_interval
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  engine                 = var.engine
  engine_version         = var.engine_version
  multi_az               = var.multi_az
  username               = var.username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.ecommerce.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = aws_db_parameter_group.ecommerce.name
  publicly_accessible    = var.publicly_accessible
  skip_final_snapshot    = var.skip_final_snapshot
  final_snapshot_identifier = var.final_snapshot_identifier
}
