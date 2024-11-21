resource "aws_security_group" "test_privatelink_4loop_sg" {
  for_each    = toset(var.services)
  name        = "${each.value}-vpce-sg"
  description = "Allow traffic to/from ${each.value} privatelink endpoint"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.subnet_cidrs
  }

  # Exception rule for ssm to allow port 6969
  dynamic "ingress" {
    for_each = each.value == "ssm" ? [true] : []
    content {
      from_port   = 6969
      to_port     = 6969
      protocol    = "tcp"
      cidr_blocks = ["192.168.69.69/32"]
    }
  }
}

output "security_group_ids_modulev1" {
  description = "Map of service names to security group IDs"
  value       = { for key, sg in aws_security_group.test_privatelink_4loop_sg : key => sg.id }
}