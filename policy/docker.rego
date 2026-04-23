# ============================================================
# docker.rego
# Zero Trust Policy — Terraform Docker Container
# Author: ALAOUISOSSISARA
# ============================================================

package main

# ── Règle 1 : limite mémoire obligatoire ────────────────────
deny[msg] {
  resource := input.resource.docker_container[_]
  not resource.memory
  msg = "DENY: memory limit must be defined (var.memory_limit)"
}

# ── Règle 2 : filesystem read-only obligatoire ──────────────
deny[msg] {
  resource := input.resource.docker_container[_]
  not resource.read_only
  msg = "DENY: read_only must be true (Zero Trust filesystem)"
}

# ── Règle 3 : no-new-privileges obligatoire ─────────────────
deny[msg] {
  resource := input.resource.docker_container[_]
  not resource.security_opts
  msg = "DENY: security_opts no-new-privileges must be set"
}

# ── Règle 4 : drop ALL capabilities obligatoire ─────────────
deny[msg] {
  resource := input.resource.docker_container[_]
  not resource.capabilities
  msg = "DENY: capabilities drop ALL must be defined"
}
