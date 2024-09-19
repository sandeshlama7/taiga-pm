################################################################################
# variables defination
###############################################################################
variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "naming_environment" {
  description = "Name of the environment"
  type        = string
}

#########################################################
## tag variable               
#########################################################
variable "env" {
  description = "Name of the environment"
  type        = string
}

variable "application" {
  description = "Application name"
  type        = string
}

variable "project" {
  description = "Project name"
  type        = string
}

variable "owner" {
  description = "Owner name"
  type        = string
}

#################################################################################
# variables for VPC
#################################################################################
variable "vpc_id" {
  description = "VPC id"
  type        = string
  default     = ""
}

variable "public_subnet_ids" {
  description = "Public subnet ids"
  type        = list(string)
  default     = []
}

variable "private_subnet_ids" {
  description = "Private subnet ids"
  type        = list(string)
  default     = []
}

variable "vpc_cidr" {
  description = "Range of VPC cidr"
  type        = string
}

variable "number_of_azs" {
  description = "number of availability zones"
  type        = number
}

# variable "create_vpc" {
#   description = "Whether to create vpc module or not"
#   type        = bool
# }

#################################################################################
# variables for ECR
#################################################################################
variable "ecr_force_delete" {
  description = "Force delete ecr"
  type        = bool
  default     = false
}

variable "ecr_scan_on_push" {
  description = "Scan image when pushed to ECR"
  type        = bool
  default     = true
}

#################################################################################
# variables for ALB
#################################################################################
variable "alb_enable_deletion_protection" {
  description = "alb_enable_deletion_protection"
  type        = bool
  default     = true
}
