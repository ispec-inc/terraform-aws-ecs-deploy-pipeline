locals {
  application_name       = "simple-go-ping-api"
  application_name_lower = replace(lower(local.application_name), "/[^a-z0-9]/", "")

  environment = "dev"

  azs = ["ap-northeast-1a", "ap-northeast-1c"]
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.application_name

  azs              = local.azs
  cidr             = "10.0.0.0/16"
  private_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets   = ["10.0.101.0/24", "10.0.102.0/24"]
  database_subnets = ["10.0.21.0/24", "10.0.22.0/24"]

  enable_ipv6            = true
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  tags = {
    Terraform   = "true"
    Application = local.application_name
    Environment = local.environment
  }
}

module "ecs-pipeline" {
  source = "../.."

  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  public_subnets  = module.vpc.public_subnets

  cluster_name        = local.application_name
  app_repository_name = local.application_name
  container_name      = local.application_name

  alb_port          = "80"
  container_port    = "8005"
  health_check_path = "/ping"

  build_options = "-f ./build/Dockerfile"
  #build_args = {
  #  is_build_mode_prod  = "true"
  #  build_configuration = "dev"
  #}

  git_repository = {
    owner  = "murawakimitsuhiro"
    name   = "go-simple-RESTful-api"
    branch = "feature/only-ping"
  }
}

