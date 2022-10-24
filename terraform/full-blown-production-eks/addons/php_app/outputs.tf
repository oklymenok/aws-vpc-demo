output "php_apache_lb" {
  value = kubernetes_service.php_apache[0].status
}