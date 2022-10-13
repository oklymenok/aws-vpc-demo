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
resource "aws_eip" "web-server-eip" {
  count                     = local.web_server_public_access ? 1 : 0
  vpc                       = true
  network_interface         = aws_network_interface.web-server-nic.id
  associate_with_private_ip = "10.0.0.21"
  depends_on                = [aws_internet_gateway.gw]
}

# Create Ubuntu server
resource "aws_instance" "web-server-instance" {
  count             = local.web_server_enable ? 1 : 0
  ami               = data.aws_ami.ubuntu_server_ami.id
  instance_type     = "t2.micro"
  availability_zone = "us-east-1a"
  key_name          = "default"

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.web-server-nic.id
  }

    user_data = <<-EOF
                  #!/bin/bash
                  sudo apt update -y
                  sudo apt install apache2 -y
                  sudo systemctl start apache2
                  sudo bash -c 'echo your very first web server > /var/www/html/index.html'
                  EOF
  tags = {
    Name = "web-server"
  }
}