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
| Phase 3 | CI/CD Pipeline Security (GitHub Actions) | Complete |
| Phase 4 | Jenkins Local Pipeline (Blue Ocean) | Upcoming |
| Phase 5 | Secrets Management (HashiCorp Vault) | Upcoming |
| Phase 6 | AWS Free Tier Deployment (EC2, S3, IAM) | Upcoming |
| Phase 7 | Monitoring and Alerting (Prometheus, Grafana) | Upcoming |
| Phase 8 | Compliance and Audit (OpenSCAP, CIS Benchmark) | Upcoming |

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

## Phase 3 — CI/CD Pipeline Security Summary

### Pipeline Overview
- Trigger — every push and pull request on main branch
- Total duration — 1m 24s
- Status — all 6 jobs passing

### Jobs

| Job | Tool | Role | Result |
|-----|------|------|--------|
| 1 | Docker Build | Build hardened image | OK |
| 2 | Trivy | Container vulnerability scan | 0 CVE |
| 3 | Terraform Validate | IaC syntax and format check | OK |
| 4 | Semgrep | SAST — static code analysis | 0 findings |
| 5 | Gitleaks | Secrets detection in code and history | No leaks detected |
| 6 | OPA Conftest | Policy as Code — Terraform compliance | Policies passed |

### Zero Trust Applied
- Every commit is verified automatically — never trust incoming code
- Pipeline blocks on any CRITICAL or HIGH vulnerability
- Secrets never reach the repository — Gitleaks blocks at push
- Infrastructure must comply with security policies before deploy

### Files
- .github/workflows/devsecops-pipeline.yml — pipeline definition
- policy/docker.rego — OPA Zero Trust policies for Terraform

### Key Concepts Learned
- CI/CD as a security gate — not just automation
- SAST — static analysis without executing the code
- Secrets detection — Gitleaks scans full Git history
- Policy as Code — security rules version controlled like code
- Supply chain security — every action pinned and verified
