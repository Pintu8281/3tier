variable "username" {}
variable "paswd" {}
variable "publicip" {}
variable "dbname" {}

data "google_client_config" "provider" {}

data "google_container_cluster" "my_cluster" {
  depends_on = [
    google_container_cluster.wp_gke
  ]
  name     = "wpgkecluster"
  location = "us-central1-c"
}
provider "kubernetes" {
  load_config_file = true

  host  = "https://${data.google_container_cluster.my_cluster.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base256decode(
    data.google_container_cluster.my_cluster.master_auth.0.cluster_ca_certificate,
  )
}

resource "google_compute_address" "static_ip" {
  name = "static-ip-address"
  region = "us-central1"
  project = "project1234"
}

output "static_ip_wp" {
  value = google_compute_address.static_ip.address
}

resource "kubernetes_deployment" "wp_deploy" {
  metadata {
    name = "wordpress"
    labels = {
      app = "wordpress"
    }
  }
  spec {
      replicas = 1
    selector {
      match_labels = {
        app = "wordpress"
      }
    }
    template {
      metadata {
        labels = {
          app = "wordpress"
        }
      }
      spec {
        container {
          image = "wordpress"
          name  = "wordpress-pod"
          env {
            name = "wpdbhost"
            value = var.publicip
            }
          env {
            name = "wpdb"
            value = var.dbname
            }
          env {
            name = "wpuser"
            value = var.username
            }
          env {
            name = "wppassword"
            value = var.paswd
          }
          port {
        container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "wp_service" {
  metadata {
    name = "wp-service"
   
  }
  spec {
    load_balancer_ip = google_compute_address.static_ip.address
    selector = {
      app = "wordpress"
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "LoadBalancer"
  
  }
}
