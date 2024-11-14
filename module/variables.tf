locals {
  authorized_services = toset([
    "autoscaling", "dms", "ec2", "ec2messages",
    "elasticloadbalancing", "logs", "monitoring", "rds",
    "secretsmanager", "sns", "sqs", "ssm",
    "ssmmessages", "sts"
  ])
}

variable "services" {
  type        = list(string)
  description = "List of AWS services for VPC endpoints"

  validation {
    condition     = length(setintersection(toset(var.services), local.authorized_services)) == length(var.services)
    error_message = "Invalid service(s) provided. Allowed values: ${join(", ", local.authorized_services)}"
  }
}

variable "subnet_cidrs" {
  default = ["192.168.0.0/16"]
}

variable "vpc_id" {
  description = "vpc id"
}
