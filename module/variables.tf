variable "services" {
  type        = list(string)
  description = "List of AWS services for VPC endpoints"
  
  validation {
    condition     = can([regex("^(autoscaling|dms|ec2|ec2messages|elasticloadbalancing|logs|monitoring|rds|secretsmanager|sns|sqs|ssm|ssmmessages|sts)$", "test")])
    error_message = "Invalid service. Must be one of: autoscaling, dms, ec2, ec2messages, elasticloadbalancing, logs, monitoring, rds, secretsmanager, sns, sqs, ssm, ssmmessages, sts"
  }
}

variable "subnet_cidrs" {
  default = ["192.168.0.0/16"]
}

variable "vpc_id" {
  description = "vpc id"
}
