module "vpc" {

  source = "terraform-aws-modules/vpc/aws"

  version = "~> 6.6"



  name = "eks-observability-vpc"

  cidr = "10.0.0.0/16"



  azs = [

    "${var.aws_region}a",

    "${var.aws_region}b"

  ]



  public_subnets = [

    "10.0.101.0/24",

    "10.0.102.0/24"

  ]



  private_subnets = [

    "10.0.1.0/24",

    "10.0.2.0/24"

  ]


  map_public_ip_on_launch = true
  enable_nat_gateway      = false



  enable_dns_hostnames = true

  enable_dns_support = true



  tags = {

    Project = "eks-observability-platform"

    Environment = "dev"

    Terraform = "true"

  }

}

module "ecr" {

  source = "terraform-aws-modules/ecr/aws"

  version = "~> 3.0"



  repository_name = "order-api"



  repository_type = "private"



  repository_image_tag_mutability = "IMMUTABLE"



  repository_image_scan_on_push = true



  create_lifecycle_policy = true



  repository_lifecycle_policy = jsonencode({

    rules = [

      {

        rulePriority = 1

        description = "Keep the latest 10 images"

        selection = {

          tagStatus = "any"

          countType = "imageCountMoreThan"

          countNumber = 10

        }

        action = {

          type = "expire"

        }

      }

    ]

  })



  tags = {

    Project = "eks-observability-platform"

    Environment = "dev"

    Terraform = "true"

  }

}
