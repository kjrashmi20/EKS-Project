#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TF_DIR="$ROOT_DIR/environments/dev"

echo "=========================================="
echo " EKS Observability Platform Preflight"
echo "=========================================="

cd "$TF_DIR"

echo
echo "[1/8] Terraform formatting check"
terraform fmt -recursive -check

echo "✅ Formatting OK"

echo
echo "[2/8] Terraform initialization check"
terraform init -input=false >/dev/null

echo "✅ Terraform initialized"

echo
echo "[3/8] Terraform validation"
terraform validate

echo "✅ Configuration valid"

echo
echo "[4/8] AWS authentication check"
aws sts get-caller-identity >/dev/null

echo "✅ AWS credentials valid"

echo
echo "[5/8] Backend accessibility check"
terraform state pull >/dev/null

echo "✅ Backend reachable"

echo
echo "[6/8] Terraform plan generation"

terraform plan \
  -lock=false \
  -input=false \
  -out=tfplan >/dev/null

echo "✅ Terraform plan successful"

echo
echo "[7/8] EKS sanity checks"

if grep -R "before_compute *= *true" "$ROOT_DIR/modules/eks" >/dev/null; then
    echo "⚠️ WARNING: before_compute=true detected in EKS module"
    echo "   Verify this is intentional."
else
    echo "✅ No before_compute issues detected"
fi

echo
echo "[8/8] Repository hygiene checks"

if find "$ROOT_DIR" -type f -name "*.tfstate" | grep -q .; then
    echo "⚠️ Terraform state files found in repository"
else
    echo "✅ No local tfstate files found"
fi

if find "$ROOT_DIR" -type d -name "__pycache__" | grep -q .; then
    echo "⚠️ __pycache__ directories detected"
else
    echo "✅ No __pycache__ directories found"
fi

echo
echo "=========================================="
echo " PRE-FLIGHT CHECK PASSED"
echo "=========================================="
