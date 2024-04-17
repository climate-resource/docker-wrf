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

variable "wrf_version" {
  type    = string
  default = "4.1.2"
}

variable "wps_version" {
  type    = string
  default = "4.1"
}

variable "git_sha" {
  type    = string
  default = "none"
}

variable "name_prefix" {
  type    = string
  default = "ghcr.io/climate-resource"
}

source "docker" "wrf-base" {
  commit  = true
  discard = false
  platform = "${var.platform}"
  image   = "${name_prefix}/wrf-base:latest"
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
        "PLATFORM=${var.platform}",
        "WRF_VERSION=${var.wrf_version}",
        "WPS_VERSION=${var.wps_version}",
    ]
  }

  post-processors {
    post-processor "docker-tag" {
      repository = "${name_prefix}/wrf"
      tag        = ["${var.git_sha}", "latest", "${var.wrf_version}"]
    }
  }
}
