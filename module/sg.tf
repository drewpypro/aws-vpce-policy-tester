resource "aws_security_group" "test_privatelink_4loop_sg" {
  name        = "${each.value}-vpce-sg"
  description = "Allow traffic to/from ${each.value} privatelink endpoint"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.subnet_cidrs
  }
}

output "security_group_ids" {
  description = "Map of service names to security group IDs"
  value       = { for key, sg in aws_security_group.this : key => sg.id }
}