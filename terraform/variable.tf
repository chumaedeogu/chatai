variable "image_name" {
  description = "The name of the Docker image to build"
  type        = string
}

variable "author" {
  description = "The author of the Docker image"
  type        = string
}

variable "image_tag" {
  description = "The tag of the Docker image to build"
  type        = string
}