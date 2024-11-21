# Security Groups for VPC Endpoints
resource "aws_security_group" "vpc_endpoint_sg" {
  for_each    = toset(var.services)
  name        = "${each.value}-vpce-sg"
  description = "Allow traffic to/from ${each.value} PrivateLink endpoint"
  vpc_id      = var.vpc_id
}

# Security Group Ingress Rules for Referenced Security Groups
resource "aws_vpc_security_group_ingress_rule" "allow_referenced_sg" {
  for_each                        = { for sg_id in var.referenced_security_groups : sg_id => sg_id }
  security_group_id               = aws_security_group.vpc_endpoint_sg[each.key].id
  referenced_security_group_id    = each.value
  from_port                       = 443
  to_port                         = 443
  ip_protocol                        = "tcp"
  description                     = "Allow HTTPS traffic from referenced security group ${each.value}"
}

output "security_group_ids" {
  description = "Map of service names to security group IDs"
  value       = { for key, sg in aws_security_group.test_privatelink_4loop_sg : key => sg.id }
}