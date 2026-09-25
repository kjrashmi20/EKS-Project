module "eks" {

  source = "terraform-aws-modules/eks/aws"

  version = "~> 21.0"



  name = "eks-observability"

  kubernetes_version = "1.36"



  endpoint_public_access  = true
  endpoint_private_access = true

  enable_cluster_creator_admin_permissions = true



  vpc_id = module.vpc.vpc_id

  subnet_ids = module.vpc.private_subnets



  eks_managed_node_groups = {

    observability = {

      name = "observability"



      instance_types = ["t3.medium"]



      min_size = 1

      desired_size = 1

      max_size = 1



      subnet_ids = module.vpc.private_subnets

    }

  }



  tags = {

    Project = "eks-observability-platform"

    Environment = "dev"

    Terraform = "true"

  }

  addons = {
    vpc-cni = {
      addon_version = "v1.22.4-eksbuild.3"
      before_compute = true
    }
    kube-proxy = {
      addon_version = "v1.36.0-eksbuild.25"
    }
    coredns = {
      addon_version = "v1.14.3-eksbuild.23"
    }
  }

}
