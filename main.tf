terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Stamp out the Production Network
module "vpc_production" {
  source           = "./modules/vpc"  # Tells Terraform where the cookie cutter is
  environment_name = "production"
  vpc_cidr_block   = "10.0.0.0/16"
}

# Stamp out the Staging Network
module "vpc_staging" {
  source           = "./modules/vpc"
  environment_name = "staging"
  vpc_cidr_block   = "10.1.0.0/16"
}