# Terraform AWS ECS Deploy PipeLine

## Introduction
If you have a github repository with Dockerfile, you can use this module to build an ECS that can be accessed from a custom domain.
 

Mainly works as follows:
- This module arranges CodePipeline using github as a hook and resources provisioned to it.<br>
- The deployment destination of CodePipeline is Fargate in ECS.<br>
- And ECS is linked to Load Balancer, enable access via its own domain.

##  Architecture
<img src="https://github.com/ispec-inc/terraform-aws-ecs-deploy-pipeline/blob/master/.github/images/architecture.png?raw=true" width="650px">

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
 
For a complete example, including a custom domain. see → [examples/api-server-ssl](https://github.com/ispec-inc/terraform-aws-ecs-deploy-pipeline/tree/master/examples/api-server-ssl)

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| alb\_port | origin application load balancer port | `any` | n/a | yes |
| app\_repository\_name | ecr repository name | `string` | `""` | no |
| build\_args | n/a | `map(string)` | `{}` | no |
| cluster\_name | ecs hogehoge cluster name | `string` | `""` | no |
| container\_name | container app name | `string` | `""` | no |
| container\_port | destination application load balancer port | `any` | n/a | yes |
| cpu\_to\_scale\_down | cpu % to scale down the number of containers | `number` | `30` | no |
| cpu\_to\_scale\_up | cpu % to scale up the number of containers | `number` | `80` | no |
| desired\_task\_cpu | desired cpu to run your tasks | `string` | `"256"` | no |
| desired\_task\_memory | desired memory to run your tasks | `string` | `"512"` | no |
| desired\_tasks | number of containers desired to run app task | `number` | `2` | no |
| domain\_name | n/a | `string` | `""` | no |
| environment\_variables | ecs task environment variables | `map(string)` | <pre>{<br>  "KEY": "value"<br>}</pre> | no |
| git\_repository | git repository variables | `map(string)` | <pre>{<br>  "branch": "master",<br>  "name": "",<br>  "owner": ""<br>}</pre> | no |
| helth\_check\_path | target group helth check path | `string` | `"/"` | no |
| max\_tasks | maximum | `number` | `4` | no |
| min\_tasks | minimum | `number` | `2` | no |
| public\_subnets | public subnet array (length>=2) | `any` | n/a | yes |
| ssl\_certificate\_arn | ssl certification arn | `string` | `""` | no |
| vpc\_id | If you use an external vpc | `string` | `""` | no |

## Outputs
