module "sm" {
  source  = "terraform-aws-modules/secrets-manager/aws"
  version = "1.3.0"

  name_prefix             = local.sm.name
  description             = local.sm.description
  create                  = local.sm.create
  enable_rotation         = local.sm.enable_rotation
  ignore_secret_changes   = local.sm.ignore_secret_changes
  recovery_window_in_days = local.sm.recovery_window_in_days
  create_random_password  = false

  secret_string = jsonencode({
    POSTGRES_HOST          = split(":", module.rds.db_instance_endpoint)[0] # local.ecs.postgres_host
    POSTGRES_PASSWORD      = random_password.db_password.result
    TAIGA_SECRET_KEY       = random_password.taiga_secret.result
    RABBITMQ_PASS          = random_password.rabbitmq_password.result
    EMAIL_HOST_USER_ID     = "Change this with desired value" // Since this is already created from console, I have manually edited secret manager from console once it is created.
    EMAIL_HOST_PASSWORD    = "Change this with desired value" //aws_iam_access_key.test.ses_smtp_password_v4 //random_password.email_host_password.result
    RABBITMQ_ERLANG_COOKIE = random_password.rabbitmq_erlang_cookie.result
  })
}

resource "random_password" "db_password" {
  length           = local.random_password.password_length
  special          = local.random_password.special
  override_special = local.random_password.override_special
}

resource "random_password" "taiga_secret" {
  length           = local.random_password.password_length
  special          = local.random_password.special
  override_special = local.random_password.override_special
}

resource "random_password" "rabbitmq_password" {
  length           = local.random_password.password_length
  special          = local.random_password.special
  override_special = local.random_password.override_special
}

resource "random_password" "email_host_password" {
  length           = local.random_password.password_length
  special          = local.random_password.special
  override_special = local.random_password.override_special
}

resource "random_password" "rabbitmq_erlang_cookie" {
  length           = local.random_password.password_length
  special          = local.random_password.special
  override_special = local.random_password.override_special
}

resource "random_password" "rabbitmq_default_pass" {
  length           = local.random_password.password_length
  special          = local.random_password.special
  override_special = local.random_password.override_special
}
