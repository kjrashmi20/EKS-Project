module "networking" {
  source = "../../modules/networking"

  vpc_name        = local.vpc_name
  vpc_cidr        = local.vpc_cidr
  azs             = local.azs
  public_subnets  = local.public_subnets
  private_subnets = local.private_subnets
  tags            = local.tags
}

module "eks" {
  source = "../../modules/eks"

  vpc_id             = module.networking.vpc_id
  private_subnet_ids = module.networking.private_subnet_ids
}
module "ecr" {
  source = "../../modules/ecr"

  repository_name = "order-api"
  tags            = local.tags
}
