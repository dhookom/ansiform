terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Use a compatible version, ~> 5.0 is a good starting point
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region # Using a variable for the region
}
