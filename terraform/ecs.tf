################################################################################
# Cluster
################################################################################

module "ecs_cluster" {
  source = "./modules/terraform-aws-ecs/modules/cluster"

  cluster_name = local.ecs.ecs_cluster_name

  # Capacity provider
  # Allocate 20% capacity to FARGATE and then split the remaining 80% capacity to 50/50 between FARGATE and FARGATE_SPOT
  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 100
      }
    }
  }

  tags = local.tags
}
