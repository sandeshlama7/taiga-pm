################################################################################
# Defines the list of output for the created infrastructure
################################################################################
output "resources" {
  description = "AWS resource naming convention"
  value = {

    prefix = {
      name = local.prefix
    }

    ec2 = {
      name = local.ec2
      tags = merge(local.tags, { Name = local.ec2 })
    }

    lt = {
      name = local.lt
      tags = merge(local.tags, { Name = local.lt })
    }

    asg = {
      name = local.asg
      tags = merge(local.tags, { Name = local.asg })
    }

    alb = {
      name = local.alb
      tags = merge(local.tags, { Name = local.asg })
    }

    nlb = {
      name = local.nlb
      tags = merge(local.tags, { Name = local.asg })
    }

    ecr = {
      name = local.ecr
      tags = merge(local.tags, { Name = local.ecr })
    }

    ecs-cluster = {
      name = local.ecs-cluster
      tags = merge(local.tags, { Name = local.ecs-cluster })
    }

    ecs-service = {
      name = local.ecs-service
      tags = merge(local.tags, { Name = local.ecs-service })
    }

    ecs-task = {
      name = local.ecs-task
      tags = merge(local.tags, { Name = local.ecs-task })
    }

    efs = {
      name = local.efs
      tags = merge(local.tags, { Name = local.efs })
    }

    iam-role = {
      name = local.iam-role
      tags = merge(local.tags, { Name = local.iam-role })
    }

    iam-policy = {
      name = local.iam-policy
      tags = merge(local.tags, { Name = local.iam-policy })
    }

    kms = {
      name = local.kms
      tags = merge(local.tags, { Name = local.kms })
    }

    sg = {
      name = local.sg
      tags = merge(local.tags, { Name = local.sg })
    }

    opensearch = {
      name = local.opensearch
      tags = merge(local.tags, { Name = local.opensearch })
    }

    rds-serverless = {
      name = local.rds-serverless
      tags = merge(local.tags, { Name = local.rds-serverless })
    }

    ecr = {
      name = local.ecr
      tags = merge(local.tags, { Name = local.ecr })
    }

    tg = {
      name = local.tg
      tags = merge(local.tags, { Name = local.tg })
    }

    s3 = {
      name = local.s3
      tags = merge(local.tags, { Name = local.s3 })
    }

    code-artifact = {
      name = local.code-artifact
      tags = merge(local.tags, { Name = local.code-artifact })
    }

    sns = {
      name = local.sns
      tags = merge(local.tags, { Name = local.sns })
    }
    sqs = {
      name = local.sqs
      tags = merge(local.tags, { Name = local.sqs })
    }

    rds = {
      name = local.rds
      tags = merge(local.tags, { Name = local.rds })
    }
    cloudtrail = {
      name = local.cloudtrail
      tags = merge(local.tags, { Name = local.cloudtrail })
    }
    lambda = {
      name = local.lambda
      tags = merge(local.tags, { Name = local.lambda })
    }

    dynamodb = {
      name = local.dynamodb
      tags = merge(local.tags, { Name = local.dynamodb })
    }
    vpc = {
      name = local.vpc
      tags = merge(local.tags, { Name = local.vpc })
    }
    eks-cluster = {
      name = local.eks-cluster
      tags = merge(local.tags, { Name = local.eks-cluster })
    }
    eks-node-group = {
      name = local.eks-node-group
      tags = merge(local.tags, { Name = local.eks-node-group })
    }

    waf = {
      name = local.waf
      tags = merge(local.tags, { Name = local.waf })
    }

    guardduty-filter = {
      name = local.guardduty-filter
      tags = merge(local.tags, { Name = local.guardduty-filter })
    }
    cloudwatch-dashboard = {
      name = local.cloudwatch-dashboard
      tags = merge(local.tags, { Name = local.cloudwatch-dashboard })
    }
    data-lifecycle-manager = {
      name = local.data-lifecycle-manager
      tags = merge(local.tags, { Name = local.data-lifecycle-manager })
    }

  }
}

output "default_tags" {
  description = "Default tags applied for AWS resources"
  value       = local.tags
}
