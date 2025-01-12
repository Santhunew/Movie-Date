provider "aws" {
  region = "us-east-1" # Replace with your AWS region
}

resource "aws_instance" "example" {
  ami           = "ami-12345678" # Replace with a valid AMI ID
  instance_type = "t2.micro"

  tags = {
    Name = "GitHubActions-Terraform"
  }
}
