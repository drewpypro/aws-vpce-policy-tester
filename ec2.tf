provider "aws" {
  region     = var.region
}

resource "aws_instance" "test_ec2" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  subnet_id       = aws_subnet.test_subnet.id
  security_groups = [aws_security_group.test_ec2_sg.id]

  tags = {
    Name = "test-ec2-instance"
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "optional"
    http_put_response_hop_limit = 1
    http_protocol_ipv6          = "disabled"
  }

  iam_instance_profile = aws_iam_instance_profile.test_instance_profile.name

  user_data = templatefile("tpl/test_ec2.tpl", {
    public_key             = var.public_key
    startup_script         = file("${path.module}/scripts/test_ec2_startup.sh")
    aws_commands           = file("${path.module}/scripts/aws_commands.json")
  })
}


## ELASTIC IP
resource "aws_eip" "test_ec2_eip" {
  instance = aws_instance.test_ec2.id
  domain   = "vpc"
}

output "test_ec2_instance_id" {
  value       = aws_instance.test_ec2.id
  description = "The instance ID of the test EC2 instance"
}

