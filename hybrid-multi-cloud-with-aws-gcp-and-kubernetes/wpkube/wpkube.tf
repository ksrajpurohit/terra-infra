variable "db_host" {}
variable "db_name" {}
variable "db_user" {}
variable "db_password" {}

variable "replicas" {
  type = number
}

variable "container_image" {}
variable "container_name" {}
variable "container_port" {
  type = number
}
variable "container_volume_path" {}

variable "pod_strategy" {}
variable "label_app" {}
variable "label_env" {}

resource "kubernetes_persistent_volume_claim" "wp_pvc" {
  metadata {
    name = "wp-pvc"
    labels = {
        app = var.label_app
    }
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "5Gi"
      }
    }
  }
}


resource "kubernetes_deployment" "wp_deployment" {
  depends_on = [kubernetes_persistent_volume_claim.wp_pvc]
  metadata {
    name = "wp-deployment"
    labels = {
      app = var.label_app
      env = var.label_env
    }
  }

  spec {
    replicas = var.replicas

    strategy {
        type = var.pod_strategy
    }

    selector {
      match_labels = {
        app = var.label_app
        env = var.label_env
      }
    }

    template {
      metadata {
        labels = {
          app = var.label_app
          env = var.label_env
        }
      }

      spec {
        container {
          image = var.container_image
          name  = var.container_name

          port {
              container_port = var.container_port
          }

          volume_mount {
              name = "wp-volume"
              mount_path = var.container_volume_path
          }

          env {
              name = "WORDPRESS_DB_HOST"
              value = var.db_host
          }
          env {
              name = "WORDPRESS_DB_USER"
              value = var.db_user
          }
          env {
              name = "WORDPRESS_DB_PASSWORD"
              value =  var.db_password
          } 
          env {
              name = "WORDPRESS_DB_NAME"
              value= var.db_name
          }             
        }
        volume {
              name = "wp-volume"
              persistent_volume_claim {
                  claim_name = kubernetes_persistent_volume_claim.wp_pvc.metadata.0.name
              }

          }
      }
    }
  }
}

resource "kubernetes_service" "wp_service" {
  depends_on = [kubernetes_deployment.wp_deployment]
  metadata {
    name = "wp-service"
    labels = {
        app = var.label_app
    }
  }
  spec {
    selector = {
      app = var.label_app
      env = var.label_env
    }

    type = "LoadBalancer"

    port {
      port        = 80
      target_port = 80
    }  
  }
}
