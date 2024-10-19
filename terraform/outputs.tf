# # output "secrets_manager_arn" {
# #   value = "${module.sm.secret_arn}:POSTGRES_PASSWORD::"
# # }


# output "secrets" {
#   value = jsondecode(nonsensitive(data.aws_secretsmanager_secret_version.secret_version.secret_string))
# }

# output "route53_domain" {
#     value = values(module.route53.route53_record_name)[0]
# }

# output "smtp_user" {
#   value = module.ses-clouddrove.iam_access_key_id
# }

# output "smtp_password" {
#   value     = module.ses-clouddrove.iam_access_key_secret
#   sensitive = true
# }

# output "aws_iam_smtp_password_v4" {
#   value     = aws_iam_access_key.test.ses_smtp_password_v4
#   sensitive = true
# }

# output "aws_iam_smtp_user" {
#   value = aws_iam_access_key.test.id
# }
