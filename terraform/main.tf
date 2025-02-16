resource "random_integer" "this" {
  min = 1
  max = 1000
}

resource "docker_image" "this" {
  name = var.image_name
  build {
    context = "../"
    tag    = ["${var.image_name}:v-0.${random_integer.this.result}"]
    label = {
      author : var.author
    }
  }
}