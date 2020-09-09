provider "aws" {
  alias  = "aps1"
  region  = "ap-south-1"
  profile = "default"
}

provider "kubernetes" {
  alias  = "minikube"
  config_context = "minikube"
}

module "rds" {
  source    = "./rds"
  providers = {
    aws = aws.aps1
  }
  identifier = var.r_identifier
  allocated_storage = var.r_allocated_storage
  storage_type = var.r_storage_type
  engine = var.r_engine
  engine_version = var.r_engine_version
  instance_class = var.r_instance_class
  name = var.r_db_name
  username = var.r_db_user
  password = var.r_db_password
  port = var.r_port
  publicly_accessible = var.r_publicly_accessible
}

module "wpkube" {
  source    = "./wpkube"
  providers = {
    aws = kubernetes.minikube
  }
  db_host = module.rds.rds_host
  db_name = var.r_db_name
  db_user = var.r_db_user
  db_password = var.r_db_password
  replicas = var.r_replicas
  container_image = var.r_container_image
  container_name = var.r_container_name
  container_port = var.r_container_port
  container_volume_path = var.r_container_volume_path
  pod_strategy =  var.r_pod_strategy
  label_app = var.r_label_app
  label_env = var.r_label_env
}

output "db_endpoint" {
  value = module.rds.rds_host
}

output "nodeport" {
  value = module.wpkube.node_port
}