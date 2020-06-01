locals {
  needsBuildArgs = length(var.build_args) > 0
  buildArgsCommandStr = "--build-arg ${join(
    " --build-arg ",
    formatlist("%s=%s", keys(var.build_args), values(var.build_args)),
  )}"
  build_options = format("%s %s", var.build_options, local.needsBuildArgs ? local.buildArgsCommandStr : "")
}

data "template_file" "buildspec" {
  template = file("${path.module}/templates/buildspec.yml")

  vars = {
    repository_url     = var.repository_url
    region             = var.region
    cluster_name       = var.cluster_name
    container_name     = var.container_name
    security_group_ids = join(",", var.subnet_ids)
    build_options      = local.build_options
  }
}

resource "aws_codebuild_project" "app_build" {
  name          = "${var.cluster_name}-codebuild"
  build_timeout = "60"

  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"

    // https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-available.html
    image           = "aws/codebuild/docker:17.09.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = data.template_file.buildspec.rendered
  }
}

