/*
  module "ses" {
    source  = "cloudposse/ses/aws"
    version = "0.25.0"

    domain        = "adex.ltd"
    zone_id       = module.alb.zone_id
    verify_dkim   = false
    verify_domain = false

    ses_group_enabled = false

    context = {
      enabled             = true
      namespace           = null
      tenant              = null
      environment         = null
      stage               = null
      name                = "example-taiga"
      delimiter           = null
      attributes          = []
      tags                = {}
      additional_tag_map  = {}
      regex_replace_chars = null
      label_order         = []
      id_length_limit     = null
      label_key_case      = null
      label_value_case    = null
      descriptor_formats  = {}
      # Note: we have to use [] instead of null for unset lists due to
      # https://github.com/hashicorp/terraform/issues/28137
      # which was not fixed until Terraform 1.0.0,
      # but we want the default to be all the labels in `label_order`
      # and we want users to be able to prevent all tag generation
      # by setting `labels_as_tags` to `[]`, so we need
      # a different sentinel to indicate "default"
      labels_as_tags = ["unset"]
    }
  }

  # module "ses-clouddrove" {
  #   source  = "clouddrove/ses/aws"
  #   version = "1.3.3"

  #   name        = "taiga-ses"
  #   environment = "sandbox"
  #   domain      = "adex.ltd"


  #   zone_id = module.alb.zone_id
  # }

*/

/*
  resource "aws_ses_email_identity" "ses_email_identity" {
    email = "sameep.sigdel@adex.ltd"
  }

  data "aws_iam_policy_document" "ses_iam_policy_document" {
    statement {
      actions   = ["SES:SendEmail", "SES:SendRawEmail"]
      resources = [aws_ses_email_identity.ses_email_identity.arn]

      principals {
        identifiers = ["*"]
        type        = "AWS"
      }
    }
  }

  resource "aws_ses_identity_policy" "ses_identity_policy" {
    identity = aws_ses_email_identity.ses_email_identity.arn
    name     = "taiga_ses_email_identity"
    policy   = data.aws_iam_policy_document.ses_iam_policy_document.json
  }
*/

module "ses-clouddrove" {
  source  = "clouddrove/ses/aws"
  version = "1.3.3"


  name          = "ses-taiga"
  environment   = "sandbox"
  enable_domain = false
  enable_email  = true
  emails        = ["sameep.sigdel@adex.ltd", "sandesh.lama@adex.ltd", "prashansa.joshi@adex.ltd"]
  # domain        = "adex.ltd"
  iam_name = "taiga-ses"
}

resource "aws_iam_access_key" "test" {
  user = "taiga-ses"
}
