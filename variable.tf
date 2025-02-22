variable "region" {
  description = "The region in which the resources will be created."
  default     = "ap-south-1"
  type =  string
}

variable "sg_name" {
  description = "The name of the security group."
  default     = "Mine_SG"
  type = string
}

variable "key_name" {
  description = "The name of the key pair."
  default     = "Santhu"
  type = string
}

variable "ecs_service_role_name" {
  description = "The name of the ECS service."
  default     = "ecsServiceRole"
  type = string
}

variable "ecs_task_execution_role_name" {
  description = "The name of the ECS task execution role."
  default     = "ecsTaskExecutionRole"
  type = string
}

variable "ecs_cluster_name" {
  description = "The name of the ECS cluster."
  default     = "my_cluster"
  type = string
}

variable "ecs_service_name" {
  description = "The name of the ECS service."
  default     = "my_service"
  type = string
}