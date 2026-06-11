terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # The new Remote Backend Configuration
  backend "s3" {
    bucket       = "terraform-portfolio-state-25379"
    key          = "global/s3/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}

provider "aws" {
  region = "us-east-1"
}

# Stamp out the Production Network
module "vpc_production" {
  source           = "./modules/vpc" # Tells Terraform where the cookie cutter is
  environment_name = "production"
  vpc_cidr_block   = "10.0.0.0/16"
}

# Stamp out the Staging Network
module "vpc_staging" {
  source           = "./modules/vpc"
  environment_name = "staging"
  vpc_cidr_block   = "10.1.0.0/16"
}