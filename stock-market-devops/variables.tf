# variables.tf


variable "aws_region" {
    description = "The AWS region things are created in"
}

variable "ec2_task_execution_role_name" {
    description = "ECS task execution role name"
    default = "myEcsTaskExecutionRole"
}

variable "ecs_auto_scale_role_name" {
    description = "ECS auto scale role name"
    default = "myEcsAutoScaleRole"
}

variable "vpc_cidr" {
    description = "VPC network mask"
    default = "192.168.0.0/16"
}

variable "az_count" {
    description = "Number of AZs to cover in a given region"
    default = "2"
}

variable "app_image" {
    description = "Docker image to run in the ECS cluster"
    default = "ubuntu"
}

variable "app_port" {
    description = "Port exposed by the docker image to redirect traffic to"
    default = 80

}

variable "app_count" {
    description = "Number of docker containers to run"
    default = 3
}

variable "health_check_path" {
  default = "/"
}

variable "fargate_cpu" {
    description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
    default = "256"
}

variable "fargate_memory" {
    description = "Fargate instance memory to provision (in MiB)"
    default = "512"
}

variable "bDeployBlue" {
  type        = bool
  description = "Flag to determine if the deployment should be done on the blue environment"
  default     = true  # Default to blue, adjust based on your deployment needs
}

variable "image_tag" {
  description = "The tag of the Docker image for the ECS task"
  type        = string
  default = "latest"
}