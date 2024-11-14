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
  
  validate_services = [
    for service in var.services:
    service if !contains(local.allowed_services, service)
  ]
}

resource "null_resource" "validate_services" {
  count = length(local.validate_services) > 0 ? fail("Invalid services specified: ${join(", ", local.validate_services)}") : 0
}

variable "subnet_cidrs" {
  default = ["192.168.0.0/16"]
}

variable "vpc_id" {
  description = "vpc id"
}
