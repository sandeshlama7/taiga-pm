
################################################################################
# Decides the creation of the VPC, calculating the length of subnets and the creation of the subnets
################################################################################
locals {
  len_public_subnets   = max(length(var.public_subnets), length(var.public_subnet_ipv6_prefixes))
  len_private_subnets  = max(length(var.private_subnets), length(var.private_subnet_ipv6_prefixes))
  len_database_subnets = max(length(var.database_subnets), length(var.database_subnet_ipv6_prefixes))

  max_subnet_length = max(
    local.len_private_subnets,
    local.len_public_subnets,
    local.len_database_subnets,
  )

  vpc_id     = try(aws_vpc.this[0].id, null)
  create_vpc = var.create_vpc

  create_public_subnets = local.create_vpc && local.len_public_subnets > 0
  # create_public_network_acl = local.create_public_subnets && var.public_dedicated_network_acl

  create_private_subnets     = local.create_vpc && local.len_private_subnets > 0
  create_private_network_acl = local.create_private_subnets && var.private_dedicated_network_acl

  create_database_subnets     = local.create_vpc && local.len_database_subnets > 0
  create_database_route_table = local.create_database_subnets && var.create_database_subnet_route_table
  create_database_network_acl = local.create_database_subnets && var.database_dedicated_network_acl

}

################################################################################
# Decides NAT gateway creation and network
################################################################################

locals {
  nat_gateway_count = var.single_nat_gateway ? 1 : var.one_nat_gateway_per_az ? length(var.azs) : local.max_subnet_length
  nat_gateway_ips   = var.reuse_nat_ips ? var.external_nat_ip_ids : try(aws_eip.nat[*].id, [])
}

################################################################################
# Decides Flow Log Creation and management
################################################################################

locals {
  # Only create flow log if user selected to create a VPC as well
  enable_flow_log = var.create_vpc && var.enable_flow_log

  create_flow_log_cloudwatch_iam_role  = local.enable_flow_log && var.flow_log_destination_type != "s3" && var.create_flow_log_cloudwatch_iam_role
  create_flow_log_cloudwatch_log_group = local.enable_flow_log && var.flow_log_destination_type != "s3" && var.create_flow_log_cloudwatch_log_group

  flow_log_destination_arn                  = local.create_flow_log_cloudwatch_log_group ? try(aws_cloudwatch_log_group.flow_log[0].arn, null) : var.flow_log_destination_arn
  flow_log_iam_role_arn                     = var.flow_log_destination_type != "s3" && local.create_flow_log_cloudwatch_iam_role ? try(aws_iam_role.vpc_flow_log_cloudwatch[0].arn, null) : var.flow_log_cloudwatch_iam_role_arn
  flow_log_cloudwatch_log_group_name_suffix = var.flow_log_cloudwatch_log_group_name_suffix == "" ? local.vpc_id : var.flow_log_cloudwatch_log_group_name_suffix
}

################################################################################
# locals for the route tables
################################################################################
locals {
  public_route_table_ids  = aws_route_table.public[*].id
  private_route_table_ids = aws_route_table.private[*].id
}
