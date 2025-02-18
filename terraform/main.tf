resource "docker_image" "this" {
  name = var.image_name
  build {
    context = "../"
    tag    = ["${var.image_name}:v-0.${var.image_tag}"]
    label = {
      author : var.author
    }
  }
}