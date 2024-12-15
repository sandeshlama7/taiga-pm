module "ses-clouddrove" {
  source  = "clouddrove/ses/aws"
  version = "1.3.3"

  name          = "ses-taiga"
  environment   = "sandbox"
  enable_domain = false
  enable_email  = true
  emails        = ["sandeshislama7@gmail.com"]
  # domain = "adex.ltd"
  # iam_name = "taiga-ses" // If SCP allows
  # iam_name = "adex-poc-smtp" //created manually by other with required privilages and shared credentials to me.
}

# resource "aws_iam_access_key" "test" {
#   user = "taiga-ses"
# }
