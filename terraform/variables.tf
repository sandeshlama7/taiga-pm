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

#################################################################################
# variables for RDS
#################################################################################
variable "rds_username" {
  description = "Username of RDS"
  type        = string
  default     = null
}

variable "rds_multi_az" {
  description = "Create RDS multi az"
  type        = bool
  default     = true
}

variable "rds_deletion_protection" {
  description = "Deletion protection for RDS"
  type        = bool
  default     = true
}

variable "database_subnet_group_name" {
  description = "DB subnet group name"
  type        = string
  default     = null
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot"
  type        = bool
  default     = false
}

variable "rds_monitoring_interval" {
  description = "The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance. To disable collecting Enhanced Monitoring metrics, specify 0. The default is 0. Valid Values: 0, 1, 5, 10, 15, 30, 60."
  type        = number
  default     = 0
}

variable "create_monitoring_role" {
  description = "Create monitoring role"
  type        = bool
  default     = false
}

variable "parameter_group_use_name_prefix" {
  description = "Determines whether to use `parameter_group_name` as is or create a unique name beginning with the `parameter_group_name` as the prefix"
  type        = bool
  default     = true
}

variable "zone_name" {
  description = "Zone name"
  type        = string
}

variable "secret_test" {
  description = "Secret test"
  type        = string
}
