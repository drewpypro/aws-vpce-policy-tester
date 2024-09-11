###  test VPC
resource "aws_vpc" "test_vpc" {
  cidr_block           = "192.168.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "aws-test-vpc"
  }
}

resource "aws_subnet" "test_subnet" {
  vpc_id               = aws_vpc.test_vpc.id
  cidr_block           = "192.168.0.0/24"
  availability_zone_id = var.az_id

  tags = {
    Name = "test-subnet"
  }
}

resource "aws_subnet" "endpoint_subnet" {
  vpc_id               = aws_vpc.test_vpc.id
  cidr_block           = "192.168.69.0/24"
  availability_zone_id = var.az_id

  tags = {
    Name = "privatelink-endpoint-subnet"
  }
}

resource "aws_internet_gateway" "test_igw" {
  vpc_id   = aws_vpc.test_vpc.id

  tags = {
    Name = "test-igw"
  }
}

resource "aws_route_table" "test_rt_1" {
  vpc_id   = aws_vpc.test_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test_igw.id
  }

  tags = {
    Name = "test-route-table-1"
  }
}

resource "aws_route_table_association" "test_rta_1" {
  subnet_id      = aws_subnet.test_subnet.id
  route_table_id = aws_route_table.test_rt_1.id
}

resource "aws_route_table_association" "test_rta_2" {
  subnet_id      = aws_subnet.endpoint_subnet.id
  route_table_id = aws_route_table.test_rt_1.id
}

# resource "aws_cloudwatch_log_group" "test_vpc_flow_log_group" {
#   name              = "/aws/vpc/test-flow-logs"
#   retention_in_days = 1
# }

# resource "aws_flow_log" "test_vpc_flow_log" {
#   log_destination_type = "cloud-watch-logs"
#   log_destination      = aws_cloudwatch_log_group.test_vpc_flow_log_group.arn
#   iam_role_arn         = aws_iam_role.test_flow_logs_role.arn
#   vpc_id               = aws_vpc.test_vpc.id
#   traffic_type         = "ALL"
# }
