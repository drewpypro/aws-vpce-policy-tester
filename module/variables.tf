variable "services" {
  description = "List of AWS services for VPC endpoints"
  type        = list(string)

  validation {
    condition = alltrue([
      for service in var.services : contains([
        "autoscaling", "dms", "ec2", "ec2messages",
        "elasticloadbalancing", "logs", "monitoring", "rds",
        "secretsmanager", "sns", "sqs", "ssm",
        "ssmmessages", "sts"
      ], service)
    ])
    error_message = "Invalid service provided. Allowed values are: autoscaling, dms, ec2, ec2messages, elasticloadbalancing, logs, monitoring, rds, secretsmanager, sns, sqs, ssm, ssmmessages, sts."
  }
}

variable "subnet_cidrs" {
  default = ["192.168.0.0/16"]
}

variable "vpc_id" {
  description = "vpc id"
}
