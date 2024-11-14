variable "services" {
  type        = list(string)
  description = "List of AWS services for VPC endpoints"
}

locals {
  allowed_services = toset([
    "autoscaling", "dms", "ec2", "ec2messages",
    "elasticloadbalancing", "logs", "monitoring", "rds",
    "secretsmanager", "sns", "sqs", "ssm",
    "ssmmessages", "sts"
  ])

  invalid_services = [
    for s in var.services : s if !contains(local.allowed_services, s)
  ]

  validate = length(local.invalid_services) == 0 ? true : tobool(
    "Invalid services found: ${join(", ", local.invalid_services)}"
  )
}

variable "subnet_cidrs" {
  default = ["192.168.0.0/16"]
}

variable "vpc_id" {
  description = "vpc id"
}
