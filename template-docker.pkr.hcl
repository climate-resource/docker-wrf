packer {
  required_plugins {
    docker = {
      version = ">= 1.0.9"
      source  = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "wrf-base" {
  commit  = true
  discard = false
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
  }

  post-processors {
    post-processor "docker-tag" {
      repository = "wrf/${var.name_prefix}"
      tag        = "${var.git_sha}"
    }
    post-processor "docker-tag" {
      repository = "wrf/${var.name_prefix}"
      tag        = "latest"
    }
  }
}