output "security_group_ids" {
  description = "Map of security group IDs keyed by service name"
  value = { for sg in aws_security_group.this : sg.tags["Service"] => sg.id }
}