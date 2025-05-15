# EC2 Instance Configuration
# This resource creates an EC2 instance with a specific AMI, instance type, and key pair.
resource "aws_instance" "aws_vps" {
  ami = "ami-002fa10fbb7594252" # The AMI ID defines the operating system image to use for the instance.
  # Replace with the correct AMI ID for your region (use AWS Console to get it).

  instance_type = "t2.micro" # Defines the instance type. 't2.micro' is free-tier eligible and a basic instance type.
  # Instance types determine the performance characteristics (CPU, memory, etc.) of your EC2 instance.

  key_name = aws_key_pair.key_pair_name.key_name # Name of the SSH key pair to allow SSH access to the instance.
  # AWS will use the key pair to authenticate when you SSH into the instance.

  subnet_id       = "subnet-032b8e5de17263651"
  security_groups = [aws_security_group.allow_ssh.id] # The EC2 instance will use the security group to define access rules.
  # The security group controls inbound and outbound traffic to/from the instance.


  associate_public_ip_address = true

  # Tagging the instance
  # Tags are used to help identify and organize your resources.
  tags = {
    Name = "AwsVps" # This is the name tag of the EC2 instance, visible in the AWS Console.
    # You can add more tags as needed (e.g., "Environment" = "Production").
  }
}

# Create SSH Key Pair from Existing Public Key
# This resource creates a key pair in AWS using the existing public key file provided.
# The public key should already be generated and stored on your machine (e.g., `id_marcuwynu23_aws.pub`).
resource "aws_key_pair" "key_pair_name" {
  key_name   = "marcuwynu23-aws"              # The name you want to assign to the key pair in AWS.
  public_key = file("id_marcuwynu23_aws.pub") # Path to your existing public key (e.g., id_ed25519.pub).
  # AWS will associate this public key with the EC2 instances created using this key pair.
}

# Create a Security Group with SSH Access
# This resource defines a security group to control the inbound and outbound traffic for the EC2 instances.
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"                      # The name of the security group.
  description = "Allow SSH access from anywhere" # Describes the security group's purpose.
  vpc_id      = "vpc-0d541ad12136d30be"
  # Allow inbound SSH traffic from anywhere (0.0.0.0/0)
  # This opens port 22 (the default SSH port) to allow SSH access from any IP address.
  ingress {
    from_port   = 22            # Port 22 is the default port for SSH.
    to_port     = 22            # SSH traffic is allowed on port 22.
    protocol    = "tcp"         # We are allowing TCP traffic.
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH traffic from any IP address.
    # This is useful for testing but should be restricted to specific IPs in production environments.
  }

  # Allow all outbound traffic (default behavior for security groups)
  egress {
    from_port   = 0             # Allow all outbound traffic from any port.
    to_port     = 0             # Allow all outbound traffic to any port.
    protocol    = "-1"          # The protocol "-1" means all protocols are allowed.
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic to any IP address.
  }
}
