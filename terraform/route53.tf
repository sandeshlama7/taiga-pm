# module "route53" {
#   source  = "terraform-aws-modules/route53/aws//modules/records"
#   version = "4.1.0"

#   zone_name = local.route53.zone_name

#   records = [
#     {
#       name = local.route53.record
#       type = "A"
#       alias = {
#         name    = module.alb.dns_name
#         zone_id = module.alb.zone_id
#       }
#     }
#   ]
# }
