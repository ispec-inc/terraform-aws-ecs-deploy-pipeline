output "vpc_id" {
  value = var.vpc_id
}

output "vpc_public_subnet_ids" {
  value = [var.public_subnet_1a, var.public_subnet_1b]
}

