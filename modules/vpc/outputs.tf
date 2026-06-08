output "vpc_id" {
  description = "The unique ID of our main VPC"
  value       = aws_vpc.main.id
}