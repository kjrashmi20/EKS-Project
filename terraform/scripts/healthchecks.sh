#!/usr/bin/env bash

set -euo pipefail

REGION="ap-south-1"
CLUSTER_NAME="eks-observability"
NODE_GROUP="observability"
ECR_REPO="order-api"
PROJECT_TAG="eks-observability-platform"

echo
echo "=========================================="
echo " EKS Observability Platform Health Check"
echo "=========================================="
echo

# -------------------------
# VPC
# -------------------------

VPC_ID=$(aws ec2 describe-vpcs \
  --filters "Name=tag:Project,Values=$PROJECT_TAG" \
  --query 'Vpcs[0].VpcId' \
  --output text 2>/dev/null)

if [[ "$VPC_ID" == "None" || -z "$VPC_ID" ]]; then
  echo "❌ VPC"
  exit 1
else
  echo "✅ VPC: $VPC_ID"
fi

# -------------------------
# Subnets
# -------------------------

SUBNET_COUNT=$(aws ec2 describe-subnets \
  --filters "Name=vpc-id,Values=$VPC_ID" \
  --query 'length(Subnets)' \
  --output text)

if [[ "$SUBNET_COUNT" -ge 4 ]]; then
  echo "✅ Subnets: $SUBNET_COUNT"
else
  echo "❌ Subnets: $SUBNET_COUNT"
fi

# -------------------------
# Route Tables
# -------------------------

RT_COUNT=$(aws ec2 describe-route-tables \
  --filters "Name=vpc-id,Values=$VPC_ID" \
  --query 'length(RouteTables)' \
  --output text)

echo "✅ Route Tables: $RT_COUNT"

# -------------------------
# VPC Endpoints
# -------------------------

VPCE_COUNT=$(aws ec2 describe-vpc-endpoints \
  --filters "Name=vpc-id,Values=$VPC_ID" \
  --query 'length(VpcEndpoints)' \
  --output text)

if [[ "$VPCE_COUNT" -gt 0 ]]; then
  echo "✅ VPC Endpoints: $VPCE_COUNT"
else
  echo "❌ No VPC Endpoints found"
fi

# -------------------------
# ECR
# -------------------------

if aws ecr describe-repositories \
  --repository-names "$ECR_REPO" >/dev/null 2>&1; then

  ECR_URI=$(aws ecr describe-repositories \
      --repository-names "$ECR_REPO" \
      --query 'repositories[0].repositoryUri' \
      --output text)

  echo "✅ ECR Repository: $ECR_URI"
else
  echo "❌ ECR Repository"
fi

# -------------------------
# EKS Cluster
# -------------------------

if aws eks describe-cluster \
  --name "$CLUSTER_NAME" \
  --region "$REGION" >/dev/null 2>&1; then

  CLUSTER_STATUS=$(aws eks describe-cluster \
      --name "$CLUSTER_NAME" \
      --region "$REGION" \
      --query 'cluster.status' \
      --output text)

  if [[ "$CLUSTER_STATUS" == "ACTIVE" ]]; then
      echo "✅ EKS Cluster: ACTIVE"
  else
      echo "⚠️  EKS Cluster: $CLUSTER_STATUS"
  fi
else
  echo "❌ EKS Cluster"
fi

# -------------------------
# Node Group
# -------------------------

if aws eks describe-nodegroup \
  --cluster-name "$CLUSTER_NAME" \
  --nodegroup-name "$NODE_GROUP" \
  --region "$REGION" >/dev/null 2>&1; then

  NODE_STATUS=$(aws eks describe-nodegroup \
      --cluster-name "$CLUSTER_NAME" \
      --nodegroup-name "$NODE_GROUP" \
      --region "$REGION" \
      --query 'nodegroup.status' \
      --output text)

  if [[ "$NODE_STATUS" == "ACTIVE" ]]; then
      echo "✅ Managed Node Group: ACTIVE"
  else
      echo "⚠️  Managed Node Group: $NODE_STATUS"
  fi
else
  echo "❌ Managed Node Group"
fi

# -------------------------
# Kubernetes Nodes
# -------------------------

if command -v kubectl >/dev/null 2>&1; then

    NODES=$(kubectl get nodes --no-headers 2>/dev/null | wc -l)

    if [[ "$NODES" -gt 0 ]]; then
        echo "✅ Kubernetes Nodes: $NODES"
    else
        echo "⚠️  kubectl connected but no nodes found"
    fi
else
    echo "⚠️  kubectl not installed"
fi

echo
echo "=========================================="
echo " Health Check Complete"
echo "=========================================="
