terraform {
  backend "s3" {
    bucket       = "eks-observability-platform-terraform-state"
    key          = "eks-observability-platform/dev/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}
