#!/bin/bash
# =============================================================
# trivy-scan.sh — Automated Docker Image Security Scanner
# Project: Zero Trust DevSecOps Infrastructure
# Author: ALAOUISOSSISARA
# =============================================================

set -euo pipefail

# Colors
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'

# Config
REPORT_DIR="$HOME/devsecops/audit"
DATE=$(date +%Y%m%d_%H%M%S)
EXIT_ON_CRITICAL=true

# Usage
usage() {
    echo "Usage: $0 <image:tag> [image:tag ...]"
    echo "Example: $0 nginx-hardened:1.2 nginx:latest"
    exit 1
}

# Check args
if [ $# -eq 0 ]; then
    usage
fi

# Check trivy
if ! command -v trivy &> /dev/null; then
    echo "ERROR: trivy is not installed"
    exit 1
fi

mkdir -p "$REPORT_DIR"

FAILED=0

for IMAGE in "$@"; do
    echo ""
    echo "============================================================"
    echo "Scanning: $IMAGE"
    echo "Date: $(date)"
    echo "============================================================"

    REPORT_FILE="$REPORT_DIR/trivy_${IMAGE//[:\/]/_}_${DATE}.txt"

    # Run scan
    trivy image \
        --scanners vuln \
        --timeout 10m \
        --severity CRITICAL,HIGH,MEDIUM \
        "$IMAGE" 2>&1 | tee "$REPORT_FILE"

    # Check for CRITICAL
    CRITICAL_COUNT=$(grep -c "CRITICAL" "$REPORT_FILE" || true)
    HIGH_COUNT=$(grep -c "HIGH" "$REPORT_FILE" || true)

    echo ""
    echo "------------------------------------------------------------"
    echo "Results for $IMAGE"
    echo "CRITICAL: $CRITICAL_COUNT"
    echo "HIGH:     $HIGH_COUNT"
    echo "Report:   $REPORT_FILE"
    echo "------------------------------------------------------------"

    if [ "$CRITICAL_COUNT" -gt 0 ] && [ "$EXIT_ON_CRITICAL" = true ]; then
        echo -e "${RED}FAILED: CRITICAL vulnerabilities found in $IMAGE${NC}"
        FAILED=1
    elif [ "$HIGH_COUNT" -gt 0 ]; then
        echo -e "${YELLOW}WARNING: HIGH vulnerabilities found in $IMAGE${NC}"
    else
        echo -e "${GREEN}PASSED: No CRITICAL or HIGH vulnerabilities in $IMAGE${NC}"
    fi
done

echo ""
echo "============================================================"
echo "Scan Complete"
echo "Reports saved in: $REPORT_DIR"
echo "============================================================"

exit $FAILED
