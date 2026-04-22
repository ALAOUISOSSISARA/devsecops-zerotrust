# ============================================================
# main.tf
# Deploiement du container nginx hardened
# Zero Trust DevSecOps Infrastructure
# ============================================================

# Reference a notre image locale
resource "docker_image" "nginx_hardened" {
  name         = var.nginx_image
  keep_locally = true
}

# Container nginx securise
resource "docker_container" "nginx_secure" {
  name  = var.container_name
  image = docker_image.nginx_hardened.image_id

  # ── Restart policy ──────────────────────────────────────
  restart = "unless-stopped"

  # ── Port mapping ────────────────────────────────────────
  ports {
    internal = 8080
    external = var.nginx_port
  }

  # ── Zero Trust — Filesystem ─────────────────────────────
  read_only = true

  # ── Zero Trust — Privileges ─────────────────────────────
  security_opts = [
    "no-new-privileges:true"
  ]

  # ── Zero Trust — Capabilities ───────────────────────────
  capabilities {
    drop = ["ALL"]
  }

  # ── Resource Limits ─────────────────────────────────────
  memory      = var.memory_limit
  cpu_shares  = 512
#  pids_limit  = var.pids_limit

  # ── tmpfs — Writable zones in memory ────────────────────
  tmpfs = {
    "/var/run/nginx"     = "rw,noexec,nosuid,size=10m,uid=${var.nginx_user_uid},gid=${var.nginx_user_gid}"
    "/var/log/nginx"     = "rw,noexec,nosuid,size=10m,uid=${var.nginx_user_uid},gid=${var.nginx_user_gid}"
    "/var/lib/nginx/tmp" = "rw,noexec,nosuid,size=10m,uid=${var.nginx_user_uid},gid=${var.nginx_user_gid}"
    "/var/lib/nginx/logs"= "rw,noexec,nosuid,size=10m,uid=${var.nginx_user_uid},gid=${var.nginx_user_gid}"
  }

  # ── Labels ──────────────────────────────────────────────
  labels {
    label = "maintainer"
    value = "ALAOUISOSSISARA"
  }

  labels {
    label = "security.hardened"
    value = "true"
  }

  labels {
    label = "security.cves"
    value = "0"
  }
}
