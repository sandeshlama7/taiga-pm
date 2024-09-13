################################################################################
# Argument Reference for the resources
################################################################################

variable "aws_region" {
  description = "AWS region used for deployment"
  type        = string
  default     = "us-east-1"

  validation {
    condition     = var.aws_region == "us-east-1" || var.aws_region == "us-east-2" || var.aws_region == "ap-south-1"
    error_message = "Please specify one of the following regions."
  }
}

variable "project_prefix" {
  description = "String prefix that is added to all created resources"
  type        = string
  default     = ""
}

variable "app_name" {
  description = "Name of the application"
  type        = string
}

variable "app_name_short" {
  description = "Short name of the application"
  type        = string

  validation {
    condition     = length(var.app_name_short) <= 5
    error_message = "Please be aware that it should be shorter or equal to 5."
  }
}

variable "resource_function" {
  description = "Type of the: application|database|"
  type        = string
  default     = "application"
}

variable "environment" {
  description = "Type of the environment"
  type        = string
  default     = null
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = <<-EOT
    Delimiter to be used between ID elements.
    Defaults to `-` (hyphen).
  EOT
}
