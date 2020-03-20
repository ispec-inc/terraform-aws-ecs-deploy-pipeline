# Terraform AWS ECS DeployLine

## Introduction
If you have a github repository with Dockerfile, you can use this module to build an ECS that can be accessed from a custom domain.
 

Mainly works as follows:
- This module arranges CodePipeline using github as a hook and resources provisioned to it.<br>
- The deployment destination of CodePipeline is Fargate in ECS.<br>
- And ECS is linked to Load Balancer, enable access via its own domain.

##  Architecture
<img src="https://github.com/ispec-inc/terraform-aws-ecs-deploy-pipeline/blob/master/.github/images/architecture.png?raw=true" width="500px">

## Usage
### simple usage
You can publish the github source by customizing the four values. 
 - Application Name.
 - Vpc and subnets to use.
 - Port to Use(Internal and public).
 - Github repository to use.
```main.tf
provider "aws" {
  region = "ap-northeast-1"
}

locals {
  # Your app name.
  application_name       = "simple-go-ping-api"
  application_name_lower = replace(lower(local.application_name), "/[^a-z0-9]/", "")
}

module "ecs-deployline" {
  source  = "ispec-inc/ecs-deployline/aws"
  version = "0.4.0"

  # Your vpc and subnets id.
  vpc_id         = "vpc-0000000"
  public_subnets = ["subnet-1112", "subnet-2222"]

  cluster_name        = local.application_name
  app_repository_name = local.application_name
  container_name      = local.application_name

  # Port to use
  alb_port         = "8005"
  container_port   = "8005"
  helth_check_path = "/ping"

  # Your github repository.
  git_repository = {
    owner  = "murawakimitsuhiro"
    name   = "go-simple-RESTful-api"
    branch = "feature/only-ping"
  }
}
```
**warning**
 - Dockerfile should be placed at the root of the git repository to be used, and be ready to build.
 - In this simple sample, we do not link the domain or use SSL.
 
For a complete example, including a custom domain. see -> [examples/api-server-ssl](https://github.com/ispec-inc/terraform-aws-ecs-deploy-pipeline/tree/master/examples/api-server-ssl)

## Resources

## Inputs

## Outputs
