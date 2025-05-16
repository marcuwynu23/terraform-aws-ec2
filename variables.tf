
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-southeast-1" # Default region for AWS resources
}
variable "ami" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-002fa10fbb7594252"
  # default = "ami-01938df366ac2d954"
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
  default     = "t2.micro" # Default instance type
}


variable "instance_name" {
  description = "Name of the EC2 instance"
  type        = string
  default     = "AwsVps" # Default name for the EC2 instance

}
variable "subnet_id" {
  description = "value of subnet id"
  type        = string
  default     = "subnet-032b8e5de17263651"
}

variable "vpc_id" {
  description = "value of vpc id"
  type        = string
  default     = "vpc-0d541ad12136d30be"

}

variable "is_public_ip" {
  description = "value of public ip"
  type        = bool
  default     = true
}
variable "create_key_pair" {
  description = "Set to true if you want Terraform to create a key pair"
  type        = bool
  default     = false
}

variable "aws_key_pair_name" {
  description = "Name of the SSH key pair to allow SSH access to the instance"
  type        = string
  default     = "marcuwynu23-aws"
}


variable "aws_key_pair_public_key" {
  description = "Path to the existing public key file"
  type        = string
  default     = "./credentials/id_marcuwynu23_aws.pub"

}


variable "aws_key_pair_private_key" {
  description = "Path to the existing public key file"
  type        = string
  default     = "./credentials/id_marcuwynu23_aws"

}


