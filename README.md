# Building a Zero Trust DevSecOps Infrastructure from Scratch

Hardening, Security Scanning, CI/CD Pipeline Security, Secrets Management
and Compliance on Local Infrastructure and AWS.

## Author
- Username: ALAOUISOSSISARA
- Environment: Ubuntu Server 24.04 LTS on VMware Workstation

## Project Goal
Build a production-grade Zero Trust DevSecOps infrastructure from scratch,
learning every detail of each component.

## Project Phases

| Phase | Topic | Status |
|-------|-------|--------|
| Phase 1 | Docker Hardening | Complete |
| Phase 2 | Infrastructure as Code (Terraform) | Complete |
| Phase 3 | CI/CD Pipeline Security (GitHub Actions) | Upcoming |
| Phase 4 | Security Scanning Automation | Upcoming |
| Phase 5 | Secrets Management (Vault) | Upcoming |
| Phase 6 | Monitoring and Compliance | Upcoming |
| Phase 7 | AWS Deployment | Upcoming |

## Zero Trust Principles Applied

- Never trust, always verify — every component is verified explicitly
- Least privilege — minimum permissions everywhere, nothing more
- Assume breach — designed as if attacker is already inside

## Project Structure

    devsecops/
    README.md
    docs/
        phase1-docker-hardening.md
    scripts/
        trivy-scan.sh
    audit/
        docker-bench-report.txt
    docker/
        nginx-hardened/
            Dockerfile
            nginx.conf

## Quick Start

### Prerequisites
- Ubuntu Server 24.04 LTS
- VMware Workstation
- Docker Rootless mode

### Run Hardened nginx

    docker run -d \
      --name nginx-secure \
      --read-only \
      --cap-drop ALL \
      --security-opt no-new-privileges:true \
      --memory 128m \
      --cpus 0.5 \
      --pids-limit 50 \
      --tmpfs /var/run/nginx:rw,noexec,nosuid,size=10m,uid=1001,gid=1001 \
      --tmpfs /var/log/nginx:rw,noexec,nosuid,size=10m,uid=1001,gid=1001 \
      --tmpfs /var/lib/nginx/tmp:rw,noexec,nosuid,size=10m,uid=1001,gid=1001 \
      --tmpfs /var/lib/nginx/logs:rw,noexec,nosuid,size=10m,uid=1001,gid=1001 \
      -p 8080:8080 \
      nginx-hardened:1.2

### Scan Image for Vulnerabilities

    bash scripts/trivy-scan.sh nginx-hardened:1.2

## Phase 1 — Docker Hardening Summary

### Docker Engine
- Rootless mode — daemon runs as unprivileged user
- daemon.json — icc disabled, no-new-privileges, log rotation, live-restore
- br_netfilter — loaded and persistent

### System
- Removed dangerous groups — lxd, cdrom, dip, plugdev
- auditd configured with Docker-specific rules
- Docker Content Trust enabled

### Image
- Base image — Alpine 3.21 instead of Debian
- Non-root user — nginxuser (uid=1001)
- 0 CVEs — verified with Trivy 0.70.0
- Security headers — X-Frame-Options, X-Content-Type-Options, X-XSS-Protection
- server_tokens off — no
## Phase 2 — Terraform Summary

### Provider
- kreuzwerker/docker v3.9.0
- Rootless socket — unix:///run/user/1000/docker.sock

### Infrastructure as Code
- nginx-hardened:1.2 deployed via Terraform
- Same Zero Trust config as Phase 1 — now versioned and reproducible
- terraform plan — review before every change
- terraform apply — idempotent deployment

### Files
- providers.tf — Docker provider configuration
- variables.tf — configurable parameters
- main.tf — container resource definition
- outputs.tf — security summary after deploy

### Key Concepts Learned
- Declarative vs imperative infrastructure
- Idempotence — same result every time
- Terraform state — memory of what exists
- tfstate excluded from Git — contains sensitive data
