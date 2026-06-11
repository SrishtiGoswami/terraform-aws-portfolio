output "vpc_id" {
  description = "The unique ID of our main VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = aws_subnet.public.id
}

output "web_security_group_id" {
  description = "The ID of the web security group"
  value       = aws_security_group.web_sg.id
}

output "server_public_ip" {
  description = "The public IP address of the web server"
  value       = aws_instance.web_server.public_ip
}