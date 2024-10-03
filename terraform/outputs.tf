# # output "secrets_manager_arn" {
# #   value = "${module.sm.secret_arn}:POSTGRES_PASSWORD::"
# # }


# output "secrets" {
#   value = jsondecode(nonsensitive(data.aws_secretsmanager_secret_version.secret_version.secret_string))
# }
