// rds module variables

variable "r_identifier" {
    default = "wp-kube-rds"
}

variable "r_allocated_storage" {
    type = number
    default = 20
}

variable "r_storage_type" {
    default = "gp2"
}

variable "r_engine" {
    default = "mysql"
}

variable "r_engine_version" {
    default = "5.7"
}

variable "r_instance_class" {
    default = "db.t2.micro"
}

variable "r_port" {
  type = number
  default = 3306
}

variable "r_publicly_accessible" {
  type = bool
  default = true
}

// wpkube module variables

variable "r_replicas" {
  type = number
  default = 3
}

variable "r_container_image" {
    default = "wordpress"
}
variable "r_container_name" {
    default = "wordpress-container"
}
variable "r_container_port" {
    type = number
    default = 80
}
variable "r_container_volume_path" {
    default = "/var/www/html"
}

variable "r_pod_strategy" {
    default = "Recreate"
}

variable "r_label_app" {
    default = "wordpress"
}

variable "r_label_env" {
    default = "prod"
}
// comman variables for rds & wpkube

variable "r_db_name" {
    default = "wpdb"
}

variable "r_db_user" {
    default = "wpuser"
}

variable "r_db_password" {
    default = "wpuserpass"
}

// variables for gke

variable "r_project_id" {
    default = "deft-observer-291909"
}

variable "r_region" {
    default = "asia-east1"
}