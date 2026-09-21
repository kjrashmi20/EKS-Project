output "vpc_id" {

  description = "ID of the EKS VPC"

  value = module.vpc.vpc_id

}



output "public_subnet_ids" {

  description = "Public subnet IDs"

  value = module.vpc.public_subnets

}



output "private_subnet_ids" {

  description = "Private subnet IDs"

  value = module.vpc.private_subnets

}

output "ecr_repository_url" {

  description = "ECR repository URL for order-api"

  value = module.ecr.repository_url

}
