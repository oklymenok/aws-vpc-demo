resource "kubernetes_namespace" "php_app" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_deployment" "php_apache" {
  metadata {
    name      = "php-apache"
    namespace = kubernetes_namespace.php_app.metadata.0.name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "php-apache"
      }
    }
    template {
      metadata {
        labels = {
          app = "php-apache"
        }
      }
      spec {
        container {
          image = "registry.k8s.io/hpa-example"
          name  = "php-apache"
          port {
            container_port = 80
          }
          resources {
            limits = {
              cpu = "500m"
            }
            requests = {
              cpu = "250m"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "php_apache" {
  count = var.create_lb ? 1 : 0
  metadata {
    name      = "php-apache"
    namespace = kubernetes_namespace.php_app.metadata.0.name
  }
  spec {
    selector = {
      app = kubernetes_deployment.php_apache.spec.0.template.0.metadata.0.labels.app
    }
    type = "LoadBalancer"
    port {
      protocol    = "TCP"
      port        = 80
      target_port = 80
    }
  }
}