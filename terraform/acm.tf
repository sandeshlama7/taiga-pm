# module "acm" {
#   # source = "git@github.com:adexltd/terraform-aws-acm-module.git"
#   source  = "terraform-aws-modules/acm/aws"
#   version = "5.1.1"

#   domain_name = values(module.route53.route53_record_name)[0]
#   zone_id     = data.aws_route53_zone.route53_zone.zone_id

#   validation_method = local.acm.validation_method

#   wait_for_validation = local.acm.wait_for_validation
# }
