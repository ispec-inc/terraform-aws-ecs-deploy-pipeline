locals {
  security_group_ids = [
    aws_security_group.app_sg.id,
    aws_security_group.alb_sg.id,
    aws_security_group.ecs_sg.id,
  ]
}

resource "aws_ecs_service" "web-api" {
  name            = var.cluster_name
  task_definition = aws_ecs_task_definition.web-api.arn
  cluster         = aws_ecs_cluster.cluster.id
  launch_type     = "FARGATE"
  desired_count   = var.desired_tasks

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  depends_on = [aws_iam_role_policy.ecs_service_role_policy]

  network_configuration {
    # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
    # force an interpolation expression to be interpreted as a list by wrapping it
    # in an extra set of list brackets. That form was supported for compatibility in
    # v0.11, but is no longer supported in Terraform v0.12.
    #
    # If the expression in the following list itself returns a list, remove the
    # brackets to avoid interpretation as a list of lists. If the expression
    # returns a single list item then leave it as-is and remove this TODO comment.
    security_groups  = [local.security_group_ids]
    subnets          = var.availability_zones
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.api_target_group.arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  depends_on = [aws_alb_target_group.api_target_group]
}

