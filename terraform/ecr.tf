#ECR with KMS encryption
module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "2.3.0"

  repository_name = local.ecr.ecr_name

  repository_type                 = local.ecr.ecr_repository_type
  repository_image_tag_mutability = local.ecr.image_tag_mutability
  repository_force_delete         = local.ecr.ecr_force_delete
  repository_encryption_type      = local.ecr.encryption_type
  repository_image_scan_on_push   = local.ecr.scan_on_push
  create_lifecycle_policy         = local.ecr.create_lifecycle_policy

  tags = local.tags

}

resource "null_resource" "push_to_ecr_with_tag" {
  depends_on = [module.ecr]

  triggers = {
    always_run = "${timestamp()}" # Forces it to rerun each time
  }
  provisioner "local-exec" {

    # docker pull taigaio/taiga-front:latest &
    # docker pull taigaio/taiga-back:latest &
    # docker pull taigaio/taiga-protected:latest &
    # docker pull taigaio/taiga-events:latest &
    # docker pull rabbitmq:3.8-management-alpine &
    # docker pull nginx:1.19-alpine
    # wait
    command = <<EOT
    aws ecr get-login-password --region ${local.region} | docker login --username AWS --password-stdin ${local.ecr_repo}
    docker tag taigaio/taiga-front:latest ${module.ecr.repository_url}:front-latest
    docker tag taigaio/taiga-back:latest ${module.ecr.repository_url}:back-latest
    docker tag taigaio/taiga-protected:latest ${module.ecr.repository_url}:protected-latest
    docker tag taigaio/taiga-events:latest ${module.ecr.repository_url}:events-latest
    docker tag rabbitmq:3.8-management-alpine ${module.ecr.repository_url}:rabbitmq-latest
    docker tag nginx:1.19-alpine ${module.ecr.repository_url}:nginx-latest
    
    docker push ${module.ecr.repository_url}:front-latest &
    docker push ${module.ecr.repository_url}:back-latest &
    docker push ${module.ecr.repository_url}:protected-latest &
    docker push ${module.ecr.repository_url}:events-latest &
    docker push ${module.ecr.repository_url}:rabbitmq-latest &
    docker push ${module.ecr.repository_url}:nginx-latest &
    wait

    EOT
  }
}
