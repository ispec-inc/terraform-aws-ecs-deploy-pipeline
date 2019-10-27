locals {
  application_name       = "simple-go-ping"
  application_name_lower = "${replace(lower(local.application_name), "/[^a-z0-9]/", "")}"
}

module "vpc" {
  source = "git@github.com:ispec-inc/terraform-aws-vpc-public.git"

  cluster_name = "${local.application_name}"
}

module "ecs-pipeline" {
  source = "../.."

  is_need_vpc      = false
  vpc_id           = "${module.vpc.vpc_id}"
  public_subnet_1a = "${module.vpc.public_subnet_1a}"
  public_subnet_1b = "${module.vpc.public_subnet_1b}"

  cluster_name        = "${local.application_name}"
  app_repository_name = "${local.application_name}"
  container_name      = "${local.application_name}"

  alb_port         = "8005"
  container_port   = "8005"
  helth_check_path = "/ping"

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
