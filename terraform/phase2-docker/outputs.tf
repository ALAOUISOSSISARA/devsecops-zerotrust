# ============================================================
# outputs.tf
# Informations affichees apres terraform apply
# ============================================================

output "container_id" {
  description = "ID of the running container"
  value       = docker_container.nginx_secure.id
}

output "container_name" {
  description = "Name of the running container"
  value       = docker_container.nginx_secure.name
}

output "container_ip" {
  description = "IP address of the container"
  value       = docker_container.nginx_secure.network_data[0].ip_address
}

output "nginx_url" {
  description = "URL to access nginx"
  value       = "http://localhost:${var.nginx_port}"
}

output "security_summary" {
  description = "Security configuration summary"
  value = {
    image          = var.nginx_image
    read_only      = true
    cap_drop       = "ALL"
    memory_limit   = "${var.memory_limit}MB"
    pids_limit     = var.pids_limit
    no_new_privs   = true
  }
}
