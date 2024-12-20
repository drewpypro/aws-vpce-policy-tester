variable "services" {
  type        = list(string)
  description = "List of AWS services for VPC endpoints"

  validation {
    condition = alltrue([
      for service in var.services : contains([
        "autoscaling", "dms", "ec2", "ec2messages", "elasticloadbalancing",
        "logs", "monitoring", "rds", "secretsmanager",
        "sns", "sqs", "ssm", "ssmmessages", "sts"
      ], service)
    ])
    error_message = "Invalid service(s) provided. Allowed values: autoscaling, dms, ec2, ec2messages, elasticloadbalancing, logs, monitoring, rds, secretsmanager, sns, sqs, ssm, ssmmessages, sts."
  }
}

locals {
    authorized_services = [
        "autoscaling", "dms", "ec2", "ec2messages", "elasticloadbalancing", 
        "logs", "monitoring", "rds", "secretsmanager", 
        "sns", "sqs", "ssm", "ssmmessages", "sts"
    ]
}

variable "vpc_id" {
  description = "vpc id"
}

variable "referenced_security_groups" {
  description = "referenced-sg's"
  type = list(string)
}

variable "custom_ssm_access_rule" {
  description = "Custom rule to allow specific SG ID access to SSM on port 6969"
  type = object({
    sg_id    = string
    enabled  = bool
  })
  default = {
    sg_id   = null
    enabled = false
  }
}