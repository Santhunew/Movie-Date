provider "aws" {
  region = "us-east-1" # Replace with your AWS region
}

resource "aws_instance" "example" {
  ami           = "ami-09b0a86a2c84101e1" # Replace with a valid AMI ID
  instance_type = "t2.micro"

  tags = {
    Name = "GitHubActions-Terraform"
  }
}
