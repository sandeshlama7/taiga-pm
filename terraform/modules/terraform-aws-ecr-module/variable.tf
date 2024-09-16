variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

################################################################################
# Repository
################################################################################
variable "create" {
  description = "Determines whether resources will be created (affects all resources)"
  type        = bool
  default     = true
}
variable "repository_type" {
  description = "The type of repository to create. Either `public` or `private`"
  type        = string
  default     = "private"
}
variable "name" {
  description = "The name of the repository"
  type        = string
  default     = ""
}

variable "force_delete" {
  description = "If `true`, will delete the repository even if it contains images. Defaults to `false`"
  type        = bool
  default     = false
}

variable "image_tag_mutability" {
  description = "The tag mutability setting for the repository. Must be one of: `MUTABLE` or `IMMUTABLE`."
  type        = string
  default     = "IMMUTABLE"
  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "The image_tag_mutability must be either MUTABLE or IMMUTABLE."
  }
}


variable "scan_on_push" {
  description = "Indicates whether images are scanned after being pushed to the repository (true) or not scanned (false)."
  type        = bool
  default     = true
}

variable "lifecycle_policy" {
  description = "Manages the ECR repository lifecycle policy"
  type        = string
  default     = null
}

variable "encryption_type" {
  description = "The encryption type to use for the repository. Valid values are `AES256` or `KMS`"
  type        = string
  default     = "KMS"
  validation {
    condition     = contains(["AES256", "KMS"], var.encryption_type)
    error_message = "The encryption_type must be either AES256 or KMS."
  }
}

variable "kms_key" {
  description = "The ARN of the KMS key to use when encryption_type is `KMS`. If not specified when encryption_type is `KMS`, uses a new KMS key. Otherwise, uses the default AWS managed key for ECR."
  type        = string
  default     = null
}

################################################################################
# Repository Policy
################################################################################
variable "policy" {
  description = "Manages the ECR repository policy"
  type        = any
  default     = null
}

variable "public_policy" {
  description = "Manages the ECR public repository policy"
  type        = string
  default     = null
}
