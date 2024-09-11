variable "option" {
  type        = number
  description = "Set this to 1 (PrincipalOrgID), 2 (PrincipalAccount), 3 (ResourceRestriction), 4 (OU-Path) or 5 (Deny All)"
  default     = 3 
}

locals {
  option_description = {
    1 = "PrincipalOrgID"
    2 = "PrincipalAccount"
    3 = "PrincipalOrgPaths"
    4 = "ResourceRestriction"
    5 = "DenyAll"
  }
}

# Define a list of services that need VPC endpoints
variable "services" {
  default = ["autoscaling", "dms", "ec2", "ec2messages",
    "elasticloadbalancing", "logs", "monitoring", "rds",
    "secretsmanager", "sns", "sqs", "ssm",
  "ssmmessages", "sts"]
}


variable "gateway_services" {
  default = ["dynamodb", "s3"]
}

variable "az_id" {
  description = "Set your az-id or else good luck trying to get anything to work between accounts"
  type        = string
  default     = "use1-az2"
}

variable "region" {
  description = "The AWS region to create resources in"
  type        = string
  default     = "us-east-1"
}

variable "availability_zone" {
  description = "The availability zone to use for the subnet"
  type        = string
  default     = "us-east-1a"
}

variable "org_id" {
  description = "org-id must be configured in your aws accounts and supplied as a variable"
  type        = string
}

variable "org_path" {
  description = "OU Path must be configured in your aws accounts and supplied as a variable"
  type        = string
}

variable "account_id" {
  description = "An account must be created prior to test and this is mandatory variable"
  type        = string
}

variable "ami_id" {
  description = "The AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0427090fd1714168b" # Adjust as necessary
}

variable "instance_type" {
  description = "The instance type for the EC2 instance"
  type        = string
  default     = "c4.large"
}

variable "source_ssh_network" {
  description = "Public IP to SSH to consumer ec2"
  type        = string
}

variable "public_key" {
  description = "Public SSH key"
  type        = string
}

