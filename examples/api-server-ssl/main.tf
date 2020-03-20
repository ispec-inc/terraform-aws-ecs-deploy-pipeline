provider "aws" {
  region = "ap-northeast-1"
}

locals {
  domain                 = "drone.ispec.tech"
  application_name       = "simple-go-ping-api"
  application_name_lower = replace(lower(local.application_name), "/[^a-z0-9]/", "")
}

data "aws_acm_certificate" "example" {
  domain      = local.domain
  statuses    = ["ISSUED"]
  most_recent = true
}

module "ecs-deploy-pipeline" {
  source  = "ispec-inc/ecs-deploy-pipeline/aws"
  version = "0.4.2"

  vpc_id         = "vpc-1e337679"
  public_subnets = ["subnet-26631d7d", "subnet-41776669"]

  cluster_name        = local.application_name
  app_repository_name = local.application_name
  container_name      = local.application_name

  helth_check_path = "/ping"
  alb_port         = "8005"
  container_port   = "8005"

  git_repository = {
    owner  = "murawakimitsuhiro"
    name   = "go-simple-RESTful-api"
    branch = "feature/only-ping"
  }

  domain_name         = local.domain
  ssl_certificate_arn = data.aws_acm_certificate.example.arn
}
