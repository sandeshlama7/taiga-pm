module "acm" {
  source = "git@github.com:adexltd/terraform-aws-acm-module.git"

  domain_name            = values(module.route53.route53_record_name)[0]
  validation_method      = local.acm.validation_method
  validate_using_route53 = true
  zone_id                = data.aws_route53_zone.route53_zone.zone_id

}
