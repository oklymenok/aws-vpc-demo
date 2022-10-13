
output "web_server_public_ip" {
  value = aws_eip.web-server-eip[0].public_ip
}

output "server_private_ip" {
  value = aws_instance.web-server-instance[0].private_ip
}

output "server_id" {
  value = aws_instance.web-server-instance[0].id
}

output "hello_message" {
  value = "Verify web-server works: curl -v http://${aws_eip.web-server-eip[0].public_ip}/"
}
