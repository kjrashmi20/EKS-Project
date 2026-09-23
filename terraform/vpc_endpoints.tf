module "vpc_endpoints" {

  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"

  version = "~> 6.6"



  vpc_id = module.vpc.vpc_id



  create_security_group = true



  security_group_name_prefix = "eks-observability-vpce-"



  security_group_description = "Security group for VPC interface endpoints"



  security_group_rules = {

    ingress_https = {

      description = "HTTPS from VPC"

      cidr_blocks = [module.vpc.vpc_cidr_block]



      from_port = 443

      to_port = 443

      protocol = "tcp"

    }

  }



  endpoints = {

    s3 = {

      service_name = "com.amazonaws.ap-south-1.s3"
      service_type = "Gateway"

      route_table_ids = concat(

        module.vpc.private_route_table_ids,

        module.vpc.public_route_table_ids

      )

    }



    ecr_api = {

      service_name = "com.amazonaws.ap-south-1.ecr.api"

      service_type = "Interface"

      subnet_ids = module.vpc.private_subnets

      private_dns_enabled = true

    }



    ecr_dkr = {

      service_name = "com.amazonaws.ap-south-1.ecr.dkr"

      service_type = "Interface"

      subnet_ids = module.vpc.private_subnets

      private_dns_enabled = true

    }



    ec2 = {

      service_name = "com.amazonaws.ap-south-1.ec2"

      service_type = "Interface"

      subnet_ids = module.vpc.private_subnets

      private_dns_enabled = true

    }



    sts = {

      service_name = "com.amazonaws.ap-south-1.sts"

      service_type = "Interface"

      subnet_ids = module.vpc.private_subnets

      private_dns_enabled = true

    }

    eks = {

      service_name = "com.amazonaws.ap-south-1.eks"

      service_type = "Interface"

      subnet_ids = module.vpc.private_subnets

      private_dns_enabled = true

    }

    ssm = {
      service_name       = "com.amazonaws.ap-south-1.ssm"
      service_type       = "Interface"
      subnet_ids         = module.vpc.private_subnets
      private_dns_enabled = true
    }

    ssmmessages = {
      service_name       = "com.amazonaws.ap-south-1.ssmmessages"
      service_type       = "Interface"
      subnet_ids         = module.vpc.private_subnets
      private_dns_enabled = true
    }

    ec2messages = {
      service_name       = "com.amazonaws.ap-south-1.ec2messages"
      service_type       = "Interface"
      subnet_ids         = module.vpc.private_subnets
      private_dns_enabled = true
    }

    eks_auth = {
      service_name       = "com.amazonaws.ap-south-1.eks-auth"
      service_type       = "Interface"
      subnet_ids         = module.vpc.private_subnets
      private_dns_enabled = true
    }



    elasticloadbalancing = {

      service_name = "com.amazonaws.ap-south-1.elasticloadbalancing"

      service_type = "Interface"

      subnet_ids = module.vpc.private_subnets

      private_dns_enabled = true

    }

  }

}
