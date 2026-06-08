variable "aws_region" {
  description = "The standard AWS region to deploy resources into"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr_block" {
  description = "The IPv4 network range for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "environment_name" {
  description = "The name of the environment (e.g., production, staging)"
  type        = string
  default     = "production"
}