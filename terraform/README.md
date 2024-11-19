<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~>3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.66.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.1 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.3 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acm"></a> [acm](#module\_acm) | git@github.com:adexltd/terraform-aws-acm-module.git | n/a |
| <a name="module_alb"></a> [alb](#module\_alb) | terraform-aws-modules/alb/aws | 9.11.0 |
| <a name="module_ecr"></a> [ecr](#module\_ecr) | terraform-aws-modules/ecr/aws | 2.3.0 |
| <a name="module_ecs"></a> [ecs](#module\_ecs) | terraform-aws-modules/ecs/aws | 5.11.4 |
| <a name="module_ecs_service_taiga_async"></a> [ecs\_service\_taiga\_async](#module\_ecs\_service\_taiga\_async) | terraform-aws-modules/ecs/aws//modules/service | 5.11.2 |
| <a name="module_ecs_service_taiga_async_rabbitmq"></a> [ecs\_service\_taiga\_async\_rabbitmq](#module\_ecs\_service\_taiga\_async\_rabbitmq) | terraform-aws-modules/ecs/aws//modules/service | 5.11.2 |
| <a name="module_ecs_service_taiga_back"></a> [ecs\_service\_taiga\_back](#module\_ecs\_service\_taiga\_back) | terraform-aws-modules/ecs/aws//modules/service | 5.11.2 |
| <a name="module_ecs_service_taiga_events"></a> [ecs\_service\_taiga\_events](#module\_ecs\_service\_taiga\_events) | terraform-aws-modules/ecs/aws//modules/service | 5.11.2 |
| <a name="module_ecs_service_taiga_events_rabbitmq"></a> [ecs\_service\_taiga\_events\_rabbitmq](#module\_ecs\_service\_taiga\_events\_rabbitmq) | terraform-aws-modules/ecs/aws//modules/service | 5.11.2 |
| <a name="module_ecs_service_taiga_front"></a> [ecs\_service\_taiga\_front](#module\_ecs\_service\_taiga\_front) | terraform-aws-modules/ecs/aws//modules/service | 5.11.2 |
| <a name="module_ecs_service_taiga_nginx"></a> [ecs\_service\_taiga\_nginx](#module\_ecs\_service\_taiga\_nginx) | terraform-aws-modules/ecs/aws//modules/service | 5.11.2 |
| <a name="module_ecs_service_taiga_protected"></a> [ecs\_service\_taiga\_protected](#module\_ecs\_service\_taiga\_protected) | terraform-aws-modules/ecs/aws//modules/service | 5.11.2 |
| <a name="module_efs"></a> [efs](#module\_efs) | terraform-aws-modules/efs/aws | 1.6.3 |
| <a name="module_naming"></a> [naming](#module\_naming) | git@github.com:adexltd/terraform-naming-convention-module.git | n/a |
| <a name="module_rds"></a> [rds](#module\_rds) | terraform-aws-modules/rds/aws | 6.9.0 |
| <a name="module_route53"></a> [route53](#module\_route53) | terraform-aws-modules/route53/aws//modules/records | 4.1.0 |
| <a name="module_ses-clouddrove"></a> [ses-clouddrove](#module\_ses-clouddrove) | clouddrove/ses/aws | 1.3.3 |
| <a name="module_sm"></a> [sm](#module\_sm) | terraform-aws-modules/secrets-manager/aws | 1.3.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 5.13.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_access_key.test](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_security_group.alb_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.asg_sg_ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_service_discovery_http_namespace.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/service_discovery_http_namespace) | resource |
| [null_resource.push_to_ecr_with_tag](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_password.db_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.email_host_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.rabbitmq_default_pass](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.rabbitmq_erlang_cookie](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.rabbitmq_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.taiga_secret](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_route53_zone.route53_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_enable_deletion_protection"></a> [alb\_enable\_deletion\_protection](#input\_alb\_enable\_deletion\_protection) | alb\_enable\_deletion\_protection | `bool` | `true` | no |
| <a name="input_application"></a> [application](#input\_application) | Application name | `string` | n/a | yes |
| <a name="input_create_monitoring_role"></a> [create\_monitoring\_role](#input\_create\_monitoring\_role) | Create monitoring role | `bool` | `false` | no |
| <a name="input_database_subnet_group_name"></a> [database\_subnet\_group\_name](#input\_database\_subnet\_group\_name) | DB subnet group name | `string` | `null` | no |
| <a name="input_ecr_force_delete"></a> [ecr\_force\_delete](#input\_ecr\_force\_delete) | Force delete ecr | `bool` | `false` | no |
| <a name="input_ecr_scan_on_push"></a> [ecr\_scan\_on\_push](#input\_ecr\_scan\_on\_push) | Scan image when pushed to ECR | `bool` | `true` | no |
| <a name="input_env"></a> [env](#input\_env) | Name of the environment | `string` | n/a | yes |
| <a name="input_naming_environment"></a> [naming\_environment](#input\_naming\_environment) | Name of the environment | `string` | n/a | yes |
| <a name="input_number_of_azs"></a> [number\_of\_azs](#input\_number\_of\_azs) | number of availability zones | `number` | n/a | yes |
| <a name="input_owner"></a> [owner](#input\_owner) | Owner name | `string` | n/a | yes |
| <a name="input_parameter_group_use_name_prefix"></a> [parameter\_group\_use\_name\_prefix](#input\_parameter\_group\_use\_name\_prefix) | Determines whether to use `parameter_group_name` as is or create a unique name beginning with the `parameter_group_name` as the prefix | `bool` | `true` | no |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | Private subnet ids | `list(string)` | `[]` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name | `string` | n/a | yes |
| <a name="input_public_subnet_ids"></a> [public\_subnet\_ids](#input\_public\_subnet\_ids) | Public subnet ids | `list(string)` | `[]` | no |
| <a name="input_rds_deletion_protection"></a> [rds\_deletion\_protection](#input\_rds\_deletion\_protection) | Deletion protection for RDS | `bool` | `true` | no |
| <a name="input_rds_monitoring_interval"></a> [rds\_monitoring\_interval](#input\_rds\_monitoring\_interval) | The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance. To disable collecting Enhanced Monitoring metrics, specify 0. The default is 0. Valid Values: 0, 1, 5, 10, 15, 30, 60. | `number` | `0` | no |
| <a name="input_rds_multi_az"></a> [rds\_multi\_az](#input\_rds\_multi\_az) | Create RDS multi az | `bool` | `true` | no |
| <a name="input_rds_username"></a> [rds\_username](#input\_rds\_username) | Username of RDS | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"us-east-1"` | no |
| <a name="input_skip_final_snapshot"></a> [skip\_final\_snapshot](#input\_skip\_final\_snapshot) | Skip final snapshot | `bool` | `false` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | Range of VPC cidr | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC id | `string` | `""` | no |
| <a name="input_zone_name"></a> [zone\_name](#input\_zone\_name) | Zone name | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
