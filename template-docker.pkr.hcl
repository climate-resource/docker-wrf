packer {
  required_plugins {
    docker = {
      version = ">= 1.0.9"
      source  = "github.com/hashicorp/docker"
    }
  }
}

variable "platform" {
  type    = string
  default = "linux/amd64"
}

variable "git_sha" {
  type    = string
  default = "none"
}

variable "name_prefix" {
  type    = string
  default = "wrf-standalone"
}

source "docker" "wrf-base" {
  commit  = true
  discard = false
  platform = "${var.platform}"
  image   = "wrf-image-base:latest"
  pull    = false
}

build {
  sources = ["source.docker.wrf-base"]

  provisioner "shell" {
    scripts = [
      "scripts/install_deps.sh",
      "scripts/build_wrf.sh"
    ]
    environment_vars = [
        "PLATFORM=${var.platform}"
    ]
  }

  post-processors {
    post-processor "docker-tag" {

      repository = "${var.name_prefix}"
      tag        = ["${var.git_sha}", "latest"]
    }
  }
}
