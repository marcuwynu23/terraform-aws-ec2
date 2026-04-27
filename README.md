# Terraform AWS EC2 Instance Provisioning

This Terraform project provisions a single EC2 instance on AWS with optional SSH key pair creation and automatic security group handling.

---

## Overview

This configuration creates:

- An EC2 instance
- A security group allowing SSH access
- An optional AWS key pair (or uses an existing one)
- Public IP association (optional)

It is designed for simple VPS-style deployments.

---

## Resources Created

- `aws_instance.aws_vps` – EC2 instance
- `aws_security_group.allow_ssh` – SSH access security group (if not existing)
- `aws_key_pair.generated_key` – Optional SSH key pair
- Data source: `aws_security_group.existing_sg` – Checks if SG already exists

---

## Prerequisites

Ensure the following are installed and configured:

- Terraform >= 1.0
- AWS CLI configured (`aws configure`)
- Valid AWS credentials with permissions for EC2, VPC, and IAM (key pairs)

Verify:

```sh
terraform -v
aws sts get-caller-identity
```

---

## File Structure

```
.
├── main.tf
├── variables.tf
├── outputs.tf
└── credentials/
    ├── id_marcuwynu23_aws
    └── id_marcuwynu23_aws.pub
```

---

## Variables

Key configurable inputs:

- `aws_region` – AWS region (default: ap-southeast-1)
- `ami` – AMI ID for EC2 instance
- `instance_type` – EC2 instance type (default: t2.micro)
- `instance_name` – Name tag for instance
- `subnet_id` – Subnet where instance will be deployed
- `vpc_id` – VPC ID used for security group
- `is_public_ip` – Whether to assign public IP
- `create_key_pair` – Whether Terraform creates SSH key pair
- `aws_key_pair_name` – SSH key pair name
- `aws_key_pair_public_key` – Path to public key file
- `aws_key_pair_private_key` – Path to private key file (used for reference only)

---

## Usage

### 1. Initialize Terraform

```sh
terraform init
```

---

### 2. Validate Configuration

```sh
terraform validate
```

---

### 3. Plan Deployment

```sh
terraform plan
```

---

### 4. Apply Infrastructure

```sh
terraform apply -auto-approve
```

---

### 5. Destroy Infrastructure

```sh
terraform destroy -auto-approve
```

---

## SSH Access

After deployment, connect to the EC2 instance:

```sh
ssh -i <private_key_file> ubuntu@<public_ip>
```

Or for Amazon Linux:

```sh
ssh -i <private_key_file> ec2-user@<public_ip>
```

---

## Outputs

After apply, Terraform provides:

- `instance_public_ip` – Public IP of EC2 instance
- `instance_id` – EC2 instance ID
- `instance_name` – Instance Name tag
- `aws_key_pair_private_key` – Path to private key file (reference only)

---

## Security Considerations

- SSH access is currently open to `0.0.0.0/0` (not production-safe)
- Recommended to restrict SSH access to your IP only:

```hcl
cidr_blocks = ["YOUR_IP/32"]
```

- Store private keys securely and never commit them to version control

---

## Notes

- If `create_key_pair = false`, Terraform uses an existing key pair
- Security group lookup assumes `allow_ssh` exists or will be created
- AMI IDs are region-specific and must be updated accordingly

---

## Common Issues

### Instance not reachable

- Check security group inbound rules (port 22)
- Ensure correct key pair is used
- Verify subnet has internet gateway routing

### Invalid AMI

- AMI IDs differ per region; update `ami` variable

---

## Cleanup

To remove all resources:

```sh
terraform destroy -auto-approve
```

---

## Summary

This Terraform setup provides a minimal but flexible EC2 provisioning system with:

- Optional SSH key generation
- Reusable security group logic
- Public IP access
- Configurable infrastructure variables
