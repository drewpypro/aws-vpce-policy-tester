variable "services" {
  description = "List of AWS services for VPC endpoints"
  type        = list(string)

  validation {
    condition = alltrue([
      for service in var.services : service in [
        "autoscaling", "dms", "ec2", "ec2messages",
        "elasticloadbalancing", "logs", "monitoring", "rds",
        "secretsmanager", "sns", "sqs", "ssm",
        "ssmmessages", "sts"
      ]
    ])
    error_message = "Invalid service(s) provided. Allowed values: autoscaling, dms, ec2, ec2messages, elasticloadbalancing, logs, monitoring, rds, secretsmanager, sns, sqs, ssm, ssmmessages, sts."
  }
}


variable "subnet_cidrs" {
  validation {
    condition     = alltrue([for cidr in var.subnet_cidrs : length(regex("[0-9]+$", cidr)) > 0 && tonumber(regex("[0-9]+$", cidr)) >= 25])
    error_message = "Subnet is big doo doo (must be /25 or less)"
  }
}

variable "vpc_id" {
  description = "vpc id"
}
