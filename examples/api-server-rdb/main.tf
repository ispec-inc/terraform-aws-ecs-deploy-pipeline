provider "aws" {
  region = "ap-northeast-1"
}

module "ecs-pipeline" {
  source  = "murawakimitsuhiro/ecs-pipeline/aws"
  version = "0.1.1"

  cluster_name        = "example"
  alb_port            = "9000"
  container_port      = "9010"
  app_repository_name = "example-ecr"
  container_name      = "example-container"

  git_repository = {
    owner  = "ispec-inc"
    name   = "heehee-api"
    branch = "master"
  }

  helth_check_path = "/ping"

  desired_tasks       = 2
  min_tasks           = 2
  max_tasks           = 4
  cpu_to_scale_up     = 80
  cpu_to_scale_down   = 30
  desired_task_cpu    = "256"
  desired_task_memory = "512"

  environment_variables = {
    key = "value"
  }
}
