## IAM FOR PRODUCER VM
resource "aws_iam_policy" "test_policy" {
  name        = "TestPolicy"
  description = "Policy for Test EC2 instances applied using instance profile"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "BadIamPolicy"
        Effect = "Allow"
        Action = [
            "autoscaling:*",
            "dms:*",
            "dynamodb:*",
            "ec2:*",
            "ec2messages:*",
            "elasticloadbalancing:*",
            "logs:*",
            "monitoring:*",
            "rds:*",
            "s3:*",
            "secretsmanager:*",
            "sns:*",
            "sqs:*",
            "ssm:*",
            "ssmmessages:*",
            "sts:*"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "test_role" {
  name     = "TestRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "test_policy_attachment" {
  role       = aws_iam_role.test_role.name
  policy_arn = aws_iam_policy.test_policy.arn
}

resource "aws_iam_instance_profile" "test_instance_profile" {
  name     = "TestInstanceProfile"
  role     = aws_iam_role.test_role.name
}

# ## FLOW LOGS IAM

# resource "aws_iam_role" "producer_flow_logs_role" {
#   provider = aws.producer
#   name     = "flow-logs-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Action = "sts:AssumeRole",
#         Effect = "Allow",
#         Principal = {
#           Service = "vpc-flow-logs.amazonaws.com",
#         },
#       },
#     ],
#   })
# }

# resource "aws_iam_policy" "producer_flow_logs_policy" {
#   provider = aws.producer
#   name     = "flow-logs-policy"

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Action = [
#           "logs:CreateLogStream",
#           "logs:PutLogEvents",
#         ],
#         Effect   = "Allow",
#         Resource = "*",
#       },
#     ],
#   })
# }

# resource "aws_iam_role_policy_attachment" "producer_flow_logs_role_attachment" {
#   provider   = aws.producer
#   role       = aws_iam_role.producer_flow_logs_role.name
#   policy_arn = aws_iam_policy.producer_flow_logs_policy.arn
# }
