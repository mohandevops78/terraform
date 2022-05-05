terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.aws_region
}

resource "aws_vpc" "myvpc" {
  cidr_block = var.vpc_cidr_block
  tags       = var.tag_map
}

resource "aws_vpc" "yourvpc" {
  cidr_block = "10.0.0.0/16"
  tags       = var.tag_map
}

resource "aws_subnet" "mysubnet" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"

  tags = var.tag_map
}


resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "IGW"
  }
}

resource "aws_security_group" "security_group_ssh" {
  vpc_id = aws_vpc.myvpc.id
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "all traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "test-SG"
  }
}

resource "aws_security_group" "security_group_http" {
  vpc_id = aws_vpc.myvpc.id
  ingress {
    description = "HTTPS"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "all traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "test-SG"
  }
}

resource "aws_instance" "instance" {
  ami                         = "ami-08ca3fed11864d6bb"
  count                       = 2
  instance_type               = var.instance_type
  associate_public_ip_address = var.associate_public_ip_address
  key_name                    = "elk"
  vpc_security_group_ids      = [aws_security_group.security_group_ssh.id, aws_security_group.security_group_http.id]
  subnet_id                   = aws_subnet.mysubnet.id
  tags = {
    Name = format("VM-%s", count.index + 1)
  }
}

resource "aws_route_table" "main1" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myigw.id
  }

  tags = {
    Name = "public-rtb"
  }
}

resource "aws_route_table_association" "main1" {
  subnet_id      = aws_subnet.mysubnet.id
  route_table_id = aws_route_table.main1.id
}
