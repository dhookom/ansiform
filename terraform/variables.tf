variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "us-east-1" # Change to your preferred region
}

variable "project_name" {
  description = "Name of the project for tagging resources."
  type        = string
  default     = "JenkinsSandbox"
}

variable "environment" {
  description = "Environment (e.g., dev, test, prod)."
  type        = string
  default     = "dev"
}

variable "instance_type" {
  description = "The EC2 instance type for VMs."
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "The AMI ID for the EC2 instances (e.g., Ubuntu 22.04 LTS HVM for ARM64)."
  type        = string
  # IMPORTANT: Find the correct AMI ID for your chosen region and architecture (ARM64).
  # You can find it in the AWS EC2 console or using `aws ec2 describe-images`.
  # Example for us-east-1, Ubuntu 22.04 LTS (HVM) for arm64:
  default     = "ami-001e01731b56ced85"
}

variable "key_name" {
  description = "The name of the SSH key pair to use for the EC2 instance."
  type        = string
  default     = "my-ansible-key" # This must match the key pair name you imported in Step 1
}
