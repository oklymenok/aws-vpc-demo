terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

# Create vpc
resource "aws_vpc" "dev-vpc" {
  cidr_block = "10.0.0.0/26"
  tags = {
    Name = "dev"
  }
}