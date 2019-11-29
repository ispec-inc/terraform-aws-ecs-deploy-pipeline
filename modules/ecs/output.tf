output "repository_url" {
  value = aws_ecr_repository.web-app.repository_url
}

output "service_name" {
  value = aws_ecs_service.web-api.name
}

output "app_sg_id" {
  value = aws_security_group.app_sg.id
}

output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "ecs_sg_id" {
  value = aws_security_group.ecs_sg.id
}

