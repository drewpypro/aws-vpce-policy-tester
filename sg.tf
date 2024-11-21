###  TEST SECURITY GROUPS

resource "aws_security_group" "test_ec2_sg_1" {
  name        = "test-ec2-sg-1"
  description = "Allow traffic to/from ec2"
  vpc_id      = aws_vpc.test_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.SOURCE_SSH_NET]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/1", "128.0.0.0/1"]
  }
}

resource "aws_security_group" "test_ec2_sg_2" {
  name        = "test-ec2-sg-2"
  description = "Allow traffic to/from ec2"
  vpc_id      = aws_vpc.test_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.SOURCE_SSH_NET]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/1", "128.0.0.0/1"]
  }
}

resource "aws_security_group" "test_ec2_sg_3" {
  name        = "test-ec2-sg-2"
  description = "Allow traffic to/from ec2"
  vpc_id      = aws_vpc.test_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.SOURCE_SSH_NET]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/1", "128.0.0.0/1"]
  }
}


# resource "aws_security_group" "test_privatelink_sg" {
#   name        = "test-privatelink-sg"
#   description = "Allow traffic to/from privatelink endpoint"
#   vpc_id      = aws_vpc.test_vpc.id

#   ingress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = [aws_vpc.test_vpc.cidr_block]
#   }
# }
