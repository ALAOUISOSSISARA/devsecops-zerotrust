# ============================================================
# variables.tf
# Variables configurables du projet
# ============================================================

variable "nginx_image" {
  description = "Hardened nginx image to deploy"
  type        = string
  default     = "nginx-hardened:1.2"
}

variable "container_name" {
  description = "Name of the nginx container"
  type        = string
  default     = "nginx-secure-tf"
}

variable "nginx_port" {
  description = "External port to expose nginx"
  type        = number
  default     = 8080
}

variable "memory_limit" {
  description = "Memory limit in MB"
  type        = number
  default     = 128
}

variable "cpu_limit" {
  description = "CPU limit (number of cores)"
  type        = number
  default     = 1
}

variable "pids_limit" {
  description = "Maximum number of processes"
  type        = number
  default     = 50
}

variable "nginx_user_uid" {
  description = "UID of nginxuser inside container"
  type        = number
  default     = 1001
}

variable "nginx_user_gid" {
  description = "GID of nginxgroup inside container"
  type        = number
  default     = 1001
}
