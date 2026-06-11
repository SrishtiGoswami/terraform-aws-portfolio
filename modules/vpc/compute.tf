# modules/vpc/compute.tf

# Dynamically fetch the latest Free Tier Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }
}

# Provision the Free-Tier Compute Instance
resource "aws_instance" "web_server" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = "t3.micro" # Strictly Free Tier for newer AWS accounts (Post-July 15, 2025)

  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  # Startup script to verify the web server works
  user_data = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello from ${var.environment_name} environment!</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name        = "${var.environment_name}-web-server"
    Environment = var.environment_name
  }
}