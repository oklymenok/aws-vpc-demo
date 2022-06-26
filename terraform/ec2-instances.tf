# Create a network interface with an ip in the publica-a subnet
resource "aws_network_interface" "web-server-nic" {
  subnet_id       = aws_subnet.public-a.id
  private_ips     = ["10.0.0.21"]
  security_groups = [aws_security_group.allow_web.id]
  tags = {
    Name = "web-server-nic"
  }
}

# Assign an elastic IP to the network interface created in step 7
resource "aws_eip" "eip-1" {
  vpc                       = true
  network_interface         = aws_network_interface.web-server-nic.id
  associate_with_private_ip = "10.0.0.21"
  depends_on                = [aws_internet_gateway.gw]
}

output "server_public_ip" {
  value = aws_eip.eip-1.public_ip
}