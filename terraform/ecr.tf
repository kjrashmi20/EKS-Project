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
