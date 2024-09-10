# Create VPC Endpoints for each service, referencing the correct policy file based on the selected option
resource "aws_vpc_endpoint" "service_vpc_endpoints" {
  for_each           = toset(var.services)
  vpc_id             = aws_vpc.test_vpc.id
  service_name       = "com.amazonaws.${var.region}.${each.key}"
  vpc_endpoint_type  = "Interface"

  policy = templatefile(
      "${path.module}/policies/${
        var.option == 1 ? "PrincipalOrgID-policy.json" :
        var.option == 2 ? "PrincipalAccount-policy.json" :
        var.option == 3 ? "PrincipalOrgPaths-policy.json" :
        var.option == 4 ? "Resource-policy.json" :
        var.option == 5 ? "broken_policy.json" :
        "PrincipalOrgID-policy.json"
      }",
     {
        service_name = each.key,
        account_id   = var.account_id,
        org_id       = var.org_id,
        org_path     = var.org_path,
        region       = var.region
     }
    )

  security_group_ids = [aws_security_group.test_privatelink_sg.id]
  subnet_ids         = [aws_subnet.endpoint_subnet.id]
}

# Gateway Endpoints for S3 and RDS
resource "aws_vpc_endpoint" "gateway_endpoints" {
  for_each          = toset(var.gateway_services)
  vpc_id            = aws_vpc.test_vpc.id
  service_name      = "com.amazonaws.${var.region}.${each.key}"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.test_rt_1.id]

  policy = templatefile(
      "${path.module}/policies/${
        var.option == 1 ? "PrincipalOrgID-policy.json" :
        var.option == 2 ? "PrincipalAccount-policy.json" :
        var.option == 3 ? "PrincipalOrgPaths-policy.json" :
        var.option == 4 ? "Resource-policy.json" :
        var.option == 5 ? "broken_policy.json" :
        "PrincipalOrgID-policy.json"
      }",
     {
        service_name = each.key,
        account_id   = var.account_id,
        org_id       = var.org_id,
        org_path     = var.org_path,
        region       = var.region
     }
    )
}
