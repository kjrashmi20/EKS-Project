# EKS Observability Platform

A production-style cloud infrastructure project that provisions a container platform on AWS using Terraform and Amazon EKS.

The project demonstrates Infrastructure as Code (IaC), Terraform module design, containerization, Kubernetes orchestration, Amazon ECR integration, and private AWS networking patterns.

---

## Project Overview

This project deploys:

- Amazon EKS Cluster
- Managed Node Group
- Amazon ECR Repository
- Custom VPC with Public and Private Subnets
- VPC Endpoints for AWS service connectivity
- Containerized Python Flask Application
- Remote Terraform State Backend (S3)

The infrastructure is designed using reusable Terraform modules and follows a production-style repository structure.

---

## Architecture

```text
                        Developer
                            │
                            ▼
                       GitHub Repo
                            │
                            ▼
                        Terraform
                            │
      ┌─────────────────────┼─────────────────────┐
      │                     │                     │
      ▼                     ▼                     ▼

 Networking Module      ECR Module         EKS Module

      │                     │                     │
      │                     │                     ▼
      │                     │             Amazon EKS
      │                     │
      ▼                     ▼
     VPC             ECR Repository
      │
      ├── Public Subnets
      ├── Private Subnets
      ├── Route Tables
      ├── Internet Gateway
      └── VPC Endpoints

                            │
                            ▼

                     Python Flask App
                           (Pod)

                            │
                            ▼

                   Future Enhancements

                 Prometheus • Grafana
                 Loki • Alertmanager
```

---

## AWS Services Used

| Service | Purpose |
|----------|----------|
| VPC | Network isolation |
| EKS | Kubernetes orchestration |
| ECR | Container image registry |
| S3 | Terraform remote state |
| IAM | Access management |
| CloudWatch | EKS logging |
| VPC Endpoints | Private AWS service access |
| EC2 | EKS worker nodes |

---

## Terraform Architecture

```text
terraform/
│
├── bootstrap/
│   ├── main.tf
│   ├── outputs.tf
│   └── versions.tf
│
├── environments/
│   └── dev/
│       ├── backend.tf
│       ├── locals.tf
│       ├── main.tf
│       ├── outputs.tf
│       ├── providers.tf
│       ├── variables.tf
│       └── versions.tf
│
├── modules/
│   ├── networking/
│   │   ├── main.tf
│   │   ├── vpc_endpoints.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   │
│   ├── eks/
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   │
│   └── ecr/
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
│
└── scripts/
    ├── preflight.sh
    └── healthcheck.sh
```

---

## Design Decisions

### Modular Terraform Architecture

The infrastructure is split into reusable modules:

- Networking
- EKS
- ECR

This enables:

- Environment reusability
- Easier maintenance
- Improved readability
- Separation of concerns

### Remote State Management

Terraform state is stored remotely in S3.

Benefits:

- Team collaboration
- State durability
- Reduced risk of local state corruption

### Private AWS Connectivity

The platform uses VPC Endpoints for:

- ECR API
- ECR DKR
- S3
- STS
- EKS
- EKS Auth
- SSM
- EC2
- ELB

This minimizes Internet dependency and follows cloud security best practices.

---

## Features

### Networking

✅ Dedicated VPC

✅ Public and Private Subnets

✅ Route Table Configuration

✅ Internet Gateway

✅ VPC Endpoints

---

### Kubernetes

✅ Amazon EKS

✅ Managed Node Group

✅ EKS Addons

- VPC CNI
- CoreDNS
- Kube Proxy

---

### Container Registry

✅ Private ECR Repository

✅ Image Scanning Enabled

✅ Immutable Tags

✅ Lifecycle Policy

---

### Application

✅ Dockerized Python Flask Application

✅ Automated Build Ready

✅ EKS Deployment Ready

---

## Deployment

### Bootstrap Infrastructure

```bash
cd terraform/bootstrap

terraform init
terraform apply
```

### Deploy Infrastructure

```bash
cd terraform/environments/dev

terraform init
terraform plan
terraform apply
```

---

## Pre-Deployment Validation

Run infrastructure checks before deployment:

```bash
./scripts/preflight.sh
```

Checks include:

- Terraform formatting
- Terraform validation
- Backend connectivity
- AWS credentials
- Terraform plan generation
- Common configuration problems

---

## Post-Deployment Validation

Run infrastructure health checks:

```bash
./scripts/healthcheck.sh
```

Example output:

```text
✅ VPC
✅ Subnets
✅ Route Tables
✅ VPC Endpoints
✅ ECR Repository
✅ EKS Cluster
✅ Managed Node Group
✅ Kubernetes Nodes
```

---

## Application Testing

Run unit tests:

```bash
pytest
```

---

## Skills Demonstrated

### Cloud

- AWS
- VPC
- EKS
- ECR
- S3
- IAM

### Infrastructure as Code

- Terraform
- Module Design
- Remote State Management

### Containers

- Docker
- Container Registry Management

### Kubernetes

- Amazon EKS
- Managed Node Groups
- Cluster Networking

### DevOps

- Infrastructure Automation
- Platform Engineering
- Deployment Validation
- Health Monitoring

---

## Future Roadmap

### Observability

- Prometheus
- Grafana
- Loki
- Alertmanager

### Platform Improvements

- GitHub Actions CI/CD
- Terraform Security Scanning
- Kubernetes Ingress Controller
- Horizontal Pod Autoscaling
- Network Policies

### Reliability

- Multi-Environment Support
- Production Environment
- Automated Drift Detection

---

## Key Learning Outcomes

This project demonstrates the ability to:

- Design cloud infrastructure using Infrastructure as Code
- Build reusable Terraform modules
- Deploy and manage Kubernetes clusters on AWS
- Implement secure networking patterns
- Manage containerized workloads
- Design scalable platform architectures
- Follow production-oriented DevOps practices
