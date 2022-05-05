variable "vpc_cidr_block" {
  type        = string
  description = "(Required) Enter CIDR block for VPC"
  default     = "10.0.0.0/16"
}

variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

variable "tag_map" {
  type = map(string)
  default = {
    Name = "terraform"
    end  = "dev"
  }
}

variable "associate_public_ip_address" {
  type    = bool
  default = true
}

variable "access_key" {
  type = string
}

variable "secret_key" {}

variable "instance_type" {
  default = "t2.micro"
}