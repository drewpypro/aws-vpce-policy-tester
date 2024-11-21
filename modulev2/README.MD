# [SG per VPC Endpoint](https://github.com/drewpypro/aws-vpce-policy-tester/blob/b162b4bf4f3f611c103794d7f4a4e29470a6a283/module/sg.tf#L1)
![Success](../img/sg4loopmodulev2.png)

# [Custom Rules per Service](https://github.com/drewpypro/aws-vpce-policy-tester/blob/b162b4bf4f3f611c103794d7f4a4e29470a6a283/module/sg.tf#L15)
![Custom Rules](../img/custom_rules.png)


# Vending Workspace Repo

variable "services" {
  default = ["autoscaling", "dms", "ec2", "ec2messages",
    "elasticloadbalancing", "logs", "monitoring", "rds",
    "secretsmanager", "sns", "sqs", "ssm",
  "ssmmessages", "sts"]
}

module "sg_1" {
  source = "./modules/sg_module_1"
}

module "sg_2" {
  source = "./modules/sg_module_2"
}

# Module Repo

# VPC Endpoint Security Group (created in another module or directly here)
resource "aws_security_group" "vpc_endpoint_sg" {
  for_each    = toset(var.services)
  name        = "${each.value}-vpce-sg"
  description = "Allow traffic to/from ${each.value} privatelink endpoint"
  vpc_id      = var.vpc_id
}

# Create Ingress Rules to allow traffic from each referenced SG to the VPC Endpoint SG
resource "aws_vpc_security_group_ingress_rule" "allow_referenced_sg" {
  for_each                        = toset(var.referenced_security_groups)
  security_group_id               = aws_security_group.vpc_endpoint_sg$[each.value].id
  referenced_security_group_id    = each.value
  from_port                       = 443
  to_port                         = 443
  protocol                        = "tcp"
  description                     = "Allow HTTPS traffic from referenced security group ${each.value}"
}
