locals {
  flatmap = flatten([
    for service in var.services : [
      for sg_id in var.referenced_security_groups : {
        service_name = service
        sg_id        = sg_id
      }
    ]
  ])
}

resource "aws_security_group" "vpc_endpoint_sg" {
  for_each    = toset(var.services)
  name        = "${each.value}-vpce-sg"
  vpc_id      = var.vpc_id
}

# Security Group Ingress Rules for Referenced Security Groups
resource "aws_vpc_security_group_ingress_rule" "allow_referenced_sg" {
  for_each = { for idx, rule in local.flatmap : idx => rule }

  security_group_id            = aws_security_group.vpc_endpoint_sg[each.value.service_name].id
  referenced_security_group_id    = each.value.sg_id
  from_port                       = 443
  to_port                         = 443
  ip_protocol                     = "tcp"
}

# Custom Security Group Rule for SSM on Port 6969
resource "aws_vpc_security_group_ingress_rule" "custom_ssm_access_rule" {
  count = var.custom_ssm_access_rule.enabled ? 1 : 0

  security_group_id            = aws_security_group.vpc_endpoint_sg["ssm"].id
  referenced_security_group_id = var.custom_ssm_access_rule.sg_id
  from_port                    = 6969
  to_port                      = 6969
  ip_protocol                  = "tcp"
  description                  = "Custom rule to allow access to SSM on port 6969 for specific SG ID"
}

output "security_group_ids_modulev2" {
  description = "Map of service names to security group IDs"
  value       = { for key, sg in aws_security_group.vpc_endpoint_sg : key => sg.id }
}