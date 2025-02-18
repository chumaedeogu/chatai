output "docker_image_name" {
  value = "${var.image_name}:v-0.${var.image_tag}"
}