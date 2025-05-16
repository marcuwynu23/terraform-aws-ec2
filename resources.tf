# EC2 Instance Configuration
# This resource creates an EC2 instance with a specific AMI, instance type, and key pair.
resource "aws_instance" "aws_vps" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = local.selected_key_name
  subnet_id                   = var.subnet_id
  security_groups             = [local.selected_sg_id]
  associate_public_ip_address = var.is_public_ip

  tags = {
    Name = var.instance_name
  }
}


resource "aws_key_pair" "generated_key" {
  count      = var.create_key_pair ? 1 : 0
  key_name   = var.aws_key_pair_name
  public_key = file(var.aws_key_pair_public_key)
}

locals {
  selected_key_name = var.create_key_pair ? aws_key_pair.generated_key[0].key_name : var.aws_key_pair_name
}

# Check for Existing Security Group
data "aws_security_group" "existing_sg" {
  count = 1
  filter {
    name   = "group-name"
    values = ["allow_ssh"]
  }
  vpc_id = var.vpc_id
}

# Create Security Group If Not Exists
resource "aws_security_group" "allow_ssh" {
  count = length(data.aws_security_group.existing_sg) == 0 ? 1 : 0

  name        = "allow_ssh"
  description = "Allow SSH access from anywhere"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

locals {
  selected_sg_id = length(data.aws_security_group.existing_sg) > 0 ? data.aws_security_group.existing_sg[0].id : aws_security_group.allow_ssh[0].id
}
