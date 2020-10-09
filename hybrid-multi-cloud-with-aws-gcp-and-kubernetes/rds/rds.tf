
variable "identifier" {}
variable "allocated_storage" {
  type = number
}
variable "storage_type" {}
variable "engine" {}
variable "engine_version" {}
variable "instance_class" {}
variable "name" {}
variable "username" {}
variable "password" {}
variable "port" {
  type = number
}
variable "publicly_accessible" {
  type = bool
}

resource "aws_default_vpc" "default_vpc" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_security_group" "sg" {
  name        = "allow_wordpress"
  description = "Allow all wordpress tcp inbound traffic"
  vpc_id      = aws_default_vpc.default_vpc.id

  ingress {
    description = "Allow wordpress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_wordpress"
  }
}

resource "aws_db_instance" "mysql_rds" {
  depends_on = [aws_security_group.sg]
  identifier = var.identifier
  allocated_storage    = var.allocated_storage
  storage_type         = var.storage_type
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  name                 = var.name
  username             = var.username
  password             = var.password
  skip_final_snapshot  = true
  publicly_accessible = var.publicly_accessible
  port                = var.port
  vpc_security_group_ids = [aws_security_group.sg.id]
}

output "rds_host" {
  value = aws_db_instance.mysql_rds.endpoint
}
