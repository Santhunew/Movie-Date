variable "ami_id" {
  description = "value of the AMI ID"
  type = string
  default = "ami-09b0a86a2c84101e1"
}

variable "instance_type" {
  description = "value of the instance type"
  type = string
  default = "t2.micro"
}

variable "key_name" {
  description = "value of the key name"
  type = string
  default = "Santhu"
  
}

