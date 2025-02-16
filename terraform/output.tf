output "docker_image_name" {
  value = "${var.image_name}:v-0.${random_integer.this.result}"
}