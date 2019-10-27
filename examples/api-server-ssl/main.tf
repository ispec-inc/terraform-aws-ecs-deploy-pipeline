provider "aws" {
  region = "ap-northeast-1"
}

module "ecs-pipeline" {
  source  = "../.."
  version = "0.1.1"

  cluster_name        = "example"
  alb_port            = "8005"
  container_port      = "8005"
  app_repository_name = "example-ecr"
  container_name      = "example-container"

  git_repository = {
    owner  = "murawakimitsuhiro"
    name   = "go-simple-RESTful-api"
    branch = "feature/only-ping"
  }

  helth_check_path = "/ping"

  domain_name         = "${var.domain}"
  ssl_certificate_arn = "${data.aws_acm_certificate.example.arn}"
}

data "aws_acm_certificate" "example" {
  domain   = "${var.domain}"
  statuses = ["ISSUED", "PENDING_VALIDATION"]
}
