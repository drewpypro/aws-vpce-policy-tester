# Check hash of files if they change then trigger policy change. 
resource "null_resource" "policy_trigger" {
  triggers = {
    policy = filemd5("${path.module}/policies/${var.option == 1 ? "PrincipalOrgID-policy.json" :
      var.option == 2 ? "PrincipalAccount-policy.json" :
      var.option == 3 ? "PrincipalOrgPaths-policy.json" :
      var.option == 4 ? "Resource-policy.json" :
      var.option == 5 ? "broken_policy.json" :
    "PrincipalOrgID-policy.json"}")
  }
}

resource "null_resource" "s3_policy_trigger" {
  triggers = {
    policy = filemd5("${path.module}/policies/s3/${var.option == 1 ? "PrincipalOrgID-policy.json" :
      var.option == 2 ? "PrincipalAccount-policy.json" :
      var.option == 3 ? "PrincipalOrgPaths-policy.json" :
      var.option == 4 ? "Resource-policy.json" :
      var.option == 5 ? "broken_policy.json" :
    "PrincipalOrgID-policy.json"}")
  }
}

resource "null_resource" "monitoring_policy_trigger" {
  triggers = {
    policy = filemd5("${path.module}/policies/monitoring/${var.option == 1 ? "PrincipalOrgID-policy.json" :
      var.option == 2 ? "PrincipalAccount-policy.json" :
      var.option == 3 ? "PrincipalOrgPaths-policy.json" :
      var.option == 4 ? "Resource-policy.json" :
      var.option == 5 ? "broken_policy.json" :
    "PrincipalOrgID-policy.json"}")
  }
}

# Create VPC Endpoints for each service, referencing the correct policy file based on the selected option
resource "aws_vpc_endpoint" "service_vpc_endpoints" {
  for_each            = toset(var.services)
  vpc_id              = aws_vpc.test_vpc.id
  service_name        = "com.amazonaws.${var.region}.${each.key}"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  policy = templatefile(
    each.key == "monitoring"
    ? "${path.module}/policies/monitoring/${
      var.option == 1 ? "PrincipalOrgID-policy.json" :
      var.option == 2 ? "PrincipalAccount-policy.json" :
      var.option == 3 ? "PrincipalOrgPaths-policy.json" :
      var.option == 4 ? "Resource-policy.json" :
      var.option == 5 ? "broken_policy.json" :
      "PrincipalOrgID-policy.json"
    }"
    : "${path.module}/policies/${
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

  depends_on = [null_resource.policy_trigger, null_resource.monitoring_policy_trigger]
}

# Gateway Endpoints for S3 and RDS
resource "aws_vpc_endpoint" "gateway_endpoints" {
  for_each          = toset(var.gateway_services)
  vpc_id            = aws_vpc.test_vpc.id
  service_name      = "com.amazonaws.${var.region}.${each.key}"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.test_rt_1.id]

  policy = templatefile(
    "${path.module}/policies/s3/${
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

  depends_on = [null_resource.s3_policy_trigger]
}
