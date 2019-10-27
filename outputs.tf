output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

#output "vpc_subnet_group_name" {
#  value = "${module.vpc.subnet_group_name}"
#}

output "vpc_public_subnet_ids" {
  value = [
    "${module.vpc.public_subnet_1a}",
    "${module.vpc.public_subnet_1b}",
  ]
}
