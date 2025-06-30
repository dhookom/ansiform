# Resource tagging setup
locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# VPC
resource "aws_vpc" "sandbox_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags                 = merge(local.common_tags, { Name = "${var.project_name}-VPC" })
}

# Internet Gateway
resource "aws_internet_gateway" "sandbox_igw" {
  vpc_id = aws_vpc.sandbox_vpc.id
  tags   = merge(local.common_tags, { Name = "${var.project_name}-IGW" })
}

# Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.sandbox_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true # Automatically assign public IPs to instances
  tags                    = merge(local.common_tags, { Name = "${var.project_name}-PublicSubnet" })
}

# Route Table for Public Subnet (to Internet Gateway)
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.sandbox_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sandbox_igw.id
  }
  tags = merge(local.common_tags, { Name = "${var.project_name}-PublicRT" })
}

# Route Table Association
resource "aws_route_table_association" "public_rta" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Security Group for EC2 instances (SSH and HTTP access)
resource "aws_security_group" "vm_sg" {
  vpc_id      = aws_vpc.sandbox_vpc.id
  name        = "${var.project_name}-VM-SG"
  description = "Allow SSH and HTTP inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # WARNING: Restrict this in production!
    description = "Allow SSH access"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # WARNING: Restrict this in production!
    description = "Allow HTTP access"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = merge(local.common_tags, { Name = "${var.project_name}-VM-SG" })
}

# EC2 Instance (VM)
resource "aws_instance" "sandbox_vm" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_subnet.id
  key_name                    = var.key_name # This is the SSH key pair name from AWS
  vpc_security_group_ids      = [aws_security_group.vm_sg.id]
  associate_public_ip_address = true # Ensure it gets a public IP

  tags = merge(local.common_tags, { Name = "${var.project_name}-WebVM" })
}
