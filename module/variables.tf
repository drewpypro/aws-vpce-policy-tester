variable "services" {
  validation {
    condition = alltrue([for service in var.services : contains(var.authorized_services, service)])
    error_message = "Unauthorized service provided"
  }
}

variable "authorized_services" {
    description = "List of services authorized for security group creation"
    default = ["autoscaling", "dms", "ec2", "ec2messages",
      "elasticloadbalancing", "logs", "monitoring", "rds",
      "secretsmanager", "sns", "sqs", "ssm",
      "ssmmessages", "sts"]
}

variable "subnet_cidrs" {
  default = ["192.168.0.0/16"]
}

variable "vpc_id" {
  description = "vpc id"
}
