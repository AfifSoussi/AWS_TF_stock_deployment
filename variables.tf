variable "image_tag" {
  description = "The tag of the Docker image for the ECS task"
  type        = string
  default     = "latest"
}

variable "bDeployBlue" {
  type        = bool
  description = "Flag to determine if the deployment should be done on the blue environment"
  default     = true  # Default to blue, adjust based on your deployment needs
}