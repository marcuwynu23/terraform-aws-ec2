# Output the Public IP of the EC2 Instance
# This output will display the public IP of the EC2 instance after Terraform has finished applying.
# The public IP is necessary to SSH into the instance or connect to any public-facing services.
output "instance_public_ip" {
  value       = aws_instance.aws_vps.public_ip # The public IP of the EC2 instance is retrieved.
  description = "The public IP of the EC2 instance"
}

# Output the Instance ID
# This output will display the unique Instance ID of the EC2 instance.
# The Instance ID is useful for managing and identifying EC2 instances within AWS.
output "instance_id" {
  value       = aws_instance.aws_vps.id # The instance ID is retrieved from the created EC2 instance.
  description = "The unique ID of the EC2 instance"
}

# Output the Instance Name (tagged)
# This output will display the "Name" tag value associated with the EC2 instance.
# This is useful to identify the instance by its friendly name.
output "instance_name" {
  value       = aws_instance.aws_vps.tags["Name"] # The "Name" tag of the EC2 instance is retrieved.
  description = "The Name tag of the EC2 instance"
}
