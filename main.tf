# Provider Configuration
# This block specifies the provider (AWS) and the region where the resources will be created.
provider "aws" {
  region = "ap-southeast-1" # Specify the AWS region where resources will be created.
  # Example regions: us-east-1, eu-west-1, ap-southeast-1 (Singapore), etc.
}

# EC2 Instance Configuration
# This resource creates an EC2 instance with a specific AMI, instance type, and key pair.
resource "aws_instance" "aws_vps" {
  ami = "ami-002fa10fbb7594252" # The AMI ID defines the operating system image to use for the instance.
  # Replace with the correct AMI ID for your region (use AWS Console to get it).

  instance_type = "t2.micro" # Defines the instance type. 't2.micro' is free-tier eligible and a basic instance type.
  # Instance types determine the performance characteristics (CPU, memory, etc.) of your EC2 instance.

  key_name = aws_key_pair.key_pair_name.key_name # Name of the SSH key pair to allow SSH access to the instance.
  # AWS will use the key pair to authenticate when you SSH into the instance.

  security_groups = [aws_security_group.allow_ssh.name] # The EC2 instance will use the security group to define access rules.
  # The security group controls inbound and outbound traffic to/from the instance.

  # Tagging the instance
  # Tags are used to help identify and organize your resources.
  tags = {
    Name = "AwsVps" # This is the name tag of the EC2 instance, visible in the AWS Console.
    # You can add more tags as needed (e.g., "Environment" = "Production").
  }
}
