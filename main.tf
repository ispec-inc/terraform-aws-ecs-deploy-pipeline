locals {
  is_need_vpc = var.vpc_id == "" ? 1 : 0
}

module "vpc" {
  source  = "ispec-inc/vpc-public/aws"
  version = "1.0.0"

  cluster_name = var.cluster_name
  vpc_count    = var.is_need_vpc
}

locals {
  vpc_id           = var.vpc_id == "" ? module.vpc.vpc_id : var.vpc_id
  public_subnet_1a = var.public_subnet_1a == "" ? module.vpc.public_subnet_1a : var.public_subnet_1a
  public_subnet_1b = var.public_subnet_1b == "" ? module.vpc.public_subnet_1b : var.public_subnet_1b
  subnet_ids       = [local.public_subnet_1a, local.public_subnet_1b]
}

module "pipeline" {
  # TF-UPGRADE-TODO: In Terraform v0.11 and earlier, it was possible to
  # reference a relative module source without a preceding ./, but it is no
  # longer supported in Terraform v0.12.
  #
  # If the below module source is indeed a relative local path, add ./ to the
  # start of the source string. If that is not the case, then leave it as-is
  # and remove this TODO comment.
  source = "modules/pipeline"

  cluster_name        = var.cluster_name
  container_name      = var.container_name
  app_repository_name = var.app_repository_name
  git_repository      = var.git_repository
  repository_url      = module.ecs.repository_url
  app_service_name    = module.ecs.service_name
  vpc_id              = local.vpc_id
  build_args          = var.build_args

  subnet_ids = [
    local.subnet_ids,
  ]
}

module "ecs" {
  # TF-UPGRADE-TODO: In Terraform v0.11 and earlier, it was possible to
  # reference a relative module source without a preceding ./, but it is no
  # longer supported in Terraform v0.12.
  #
  # If the below module source is indeed a relative local path, add ./ to the
  # start of the source string. If that is not the case, then leave it as-is
  # and remove this TODO comment.
  source              = "modules/ecs"
  vpc_id              = local.vpc_id
  cluster_name        = var.cluster_name
  container_name      = var.container_name
  public_subnet_1a    = module.vpc.public_subnet_1a
  public_subnet_1b    = module.vpc.public_subnet_1b
  app_repository_name = var.app_repository_name
  alb_port            = var.alb_port
  container_port      = var.container_port
  min_tasks           = var.min_tasks
  max_tasks           = var.max_tasks
  cpu_to_scale_up     = var.cpu_to_scale_up
  cpu_to_scale_down   = var.cpu_to_scale_down
  desired_tasks       = var.desired_tasks
  desired_task_cpu    = var.desired_task_cpu
  desired_task_memory = var.desired_task_memory

  helth_check_path      = var.helth_check_path
  environment_variables = var.environment_variables
  ssl_certificate_arn   = var.ssl_certificate_arn
  domain_name           = var.domain_name

  availability_zones = [
    local.subnet_ids,
  ]
}

