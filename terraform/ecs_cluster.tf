################################################################################
# Cluster
################################################################################

module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "5.11.4"

  cluster_name = local.ecs.ecs_cluster_name

  depends_on = [null_resource.push_to_ecr_with_tag, module.alb]

  # Capacity provider
  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 100
        base   = 0
      }
    }
  }

  tags = local.tags
}


################################################################################
# Supporting Resources
################################################################################

resource "aws_service_discovery_http_namespace" "this" {
  name        = local.ecs.service_discovery_http_namespace_name
  description = "CloudMap namespace for ${local.ecs.service_discovery_http_namespace_name}"
  tags        = local.tags
}
