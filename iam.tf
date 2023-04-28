resource "aws_iam_role" "ssm" {
  name        = "modify-rds-ssm-automation-role"
  description = "Allows to modify AWS RDS Instances Class"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "AssumeServiceRoleForAWSSystemsManager"
        Principal = {
          Service = "ssm.amazonaws.com"
        }
      },
    ]
  })
  managed_policy_arns = [aws_iam_policy.ssm.arn]

  tags = {
    Name = "modify-rds-ssm-automation-role"
  }
}

resource "aws_iam_policy" "ssm" {
  name        = "modify-rds-ssm-automation-policy"
  description = "Allows to modify AWS RDS Instances Class"

  policy = jsonencode({
    Version : "2012-10-17"
    Statement : [
      {
        Sid : "RDSPolicy",
        Effect : "Allow",
        Action : [
          "rds:DescribeDBInstances",
          "rds:ModifyDBInstance",
          "rds:DescribeDBClusters"
        ],
        Resource : "*"
      },
      {
        Sid : "SSMPolicy",
        Effect : "Allow",
        Action : [
          "ssm:ListDocumentVersions",
          "ssm:StartAutomationExecution",
          "ssm:DescribeDocument",
          "ssm:ModifyDocumentPermission",
          "ssm:GetDocument",
          "ssm:ListDocuments",
          "ssm:GetParameters",
          "ssm:GetParameter",
          "ssm:StopAutomationExecution"
        ],
        Resource : "*"
      }
    ]
  })

  tags = {
    Name = "modify-rds-ssm-automation-policy"
  }
}

resource "aws_iam_role" "eventbridge" {
  name        = "modify-rds-ssm-automation-eventbridge-role"
  description = "Allows to run SSM Automation from EventBridge"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "AssumeServiceRoleForEventBridge"
        Principal = {
          Service = "events.amazonaws.com"
        }
      },
    ]
  })
  managed_policy_arns = [aws_iam_policy.eventbridge.arn]

  tags = {
    Name = "modify-rds-ssm-automation-eventbridge-role"
  }
}

#### For EventBridge ####
locals {
  rds_modify_ssm_docs     = aws_ssm_document.main.name
  rds_modify_ssm_docs_arn = aws_ssm_document.main.arn
}

resource "aws_iam_policy" "eventbridge" {
  name        = "modify-rds-ssm-automation-eventbridge-policy"
  description = "Allows to run SSM Automation EventBridge"

  policy = jsonencode({
    Version : "2012-10-17"
    Statement : [
      {
        Action : "ssm:StartAutomationExecution",
        Effect : "Allow",
        Resource : "${local.rds_modify_ssm_docs_arn}:$DEFAULT"
      },
      {
        Effect : "Allow",
        Action : "iam:PassRole",
        Resource : aws_iam_role.ssm.arn,
        Condition : {
          "StringLikeIfExists" : {
            "iam:PassedToService" : "ssm.amazonaws.com"
          }
        }
      }
    ]
  })

  tags = {
    Name = "modify-rds-ssm-automation-eventbridge-policy"
  }
}
