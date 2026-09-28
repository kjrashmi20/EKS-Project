
module "vpc" {

  source = "terraform-aws-modules/vpc/aws"

  version = "~> 6.6"



  name = var.vpc_name

  cidr = var.vpc_cidr



  azs = var.azs



  public_subnets = var.public_subnets

  private_subnets = var.private_subnets



  map_public_ip_on_launch = true

  enable_nat_gateway = false



  enable_dns_hostnames = true

  enable_dns_support = true



  tags = var.tags

}

