################################################################################
# Defines the list of output for the created infrastructure
################################################################################

output "repository_arn" {
  description = "Full ARN of the repository"
  value       = try(aws_ecr_repository.this[0].arn, aws_ecrpublic_repository.this[0].arn, null)
}

output "repository_name" {
  description = "Repository name"
  value       = try(aws_ecr_repository.this[0].name, aws_ecrpublic_repository.this[0].id, null)
}

output "repository_url" {
  description = "Repository url"
  value       = try(aws_ecr_repository.this[0].repository_url, aws_ecrpublic_repository.this[0].repository_uri, null)
}

output "registry_id" {
  description = "The registry ID where the repository was created."
  value       = try(aws_ecr_repository.this[0].registry_id, aws_ecrpublic_repository.this[0].registry_id, null)
}
