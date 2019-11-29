# VPC
variable "cluster_name" {
  description = "ecs hogehoge cluster name"
  default     = ""
}

variable "is_need_vpc" {
  default = true
}

variable "vpc_id" {
  description = "If you use an external vpc"
  default     = ""
}

variable "public_subnet_1a" {
  default = ""
}

variable "public_subnet_1b" {
  default = ""
}

variable "alb_port" {
  description = "origin application load balancer port"
}

# pipeline
variable "container_port" {
  description = "destination application load balancer port"
}

variable "app_repository_name" {
  description = "ecr repository name"
  default     = ""
}

variable "container_name" {
  description = "container app name"
  default     = ""
}

variable "git_repository" {
  type        = map(string)
  description = "git repository variables"

  default = {
    owner  = ""
    name   = ""
    branch = "master"
  }
}

variable "helth_check_path" {
  description = "target group helth check path"
  default     = "/"
}

# ecs
variable "desired_tasks" {
  description = "number of containers desired to run app task"
  default     = 2
}

variable "min_tasks" {
  description = "minimum"
  default     = 2
}

variable "max_tasks" {
  description = "maximum"
  default     = 4
}

variable "cpu_to_scale_up" {
  description = "cpu % to scale up the number of containers"
  default     = 80
}

variable "cpu_to_scale_down" {
  description = "cpu % to scale down the number of containers"
  default     = 30
}

variable "desired_task_cpu" {
  description = "desired cpu to run your tasks"
  default     = "256"
}

variable "desired_task_memory" {
  description = "desired memory to run your tasks"
  default     = "512"
}

variable "environment_variables" {
  type        = map(string)
  description = "ecs task environment variables"

  default = {
    KEY = "value"
  }
}

variable "build_args" {
  type    = map(string)
  default = {}
}

variable "ssl_certificate_arn" {
  type        = string
  description = "ssl certification arn"
  default     = ""
}

variable "domain_name" {
  type    = string
  default = ""
}

