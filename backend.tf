terraform {
  backend "s3" {
    bucket     = "terraformtest12321"
    key        = "env/terraform.tfstate"
    region     = "us-east-1"

  }
}