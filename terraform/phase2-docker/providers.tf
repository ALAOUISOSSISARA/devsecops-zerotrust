# ============================================================
# providers.tf
# Configure le provider Docker pour Terraform
# ============================================================

terraform {
  required_version = ">= 1.14.0"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
  # Rootless socket — Zero Trust
  host = "unix:///run/user/1000/docker.sock"
}
