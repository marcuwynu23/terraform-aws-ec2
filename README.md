# Terraform AWS EC2 Instance Provisioning

This Terraform project provisions a single EC2 instance on AWS with optional SSH key pair creation and automatic security group handling.

## Prerequisites

Ensure the following are installed and configured:
- Terraform >= 1.0
- AWS CLI configured (`aws configure`)
- Valid AWS credentials with permissions for EC2, VPC, and IAM (key pairs)

Verify:

```bash
aws sts get-caller-identity
```

## Setup & Deployment

1. **Initialize Terraform**:
   ```bash
   terraform init
   ```

2. **Validate Configuration**:
   ```bash
   terraform validate
   ```

3. **Plan Deployment**:
   ```bash
   terraform plan
   ```

4. **Apply Infrastructure**:
   ```bash
   terraform apply -auto-approve
   ```

5. **SSH Access**:
   ```bash
   ssh -i <private_key_file> ubuntu@<public_ip>
   ```
   Or for Amazon Linux: `ssh -i <private_key_file> ec2-user@<public_ip>`

6. **Destroy** (when no longer needed):
   ```bash
   terraform destroy -auto-approve
   ```

## Usage as a Module

Reference this repository as a Terraform module in your own configurations:

```hcl
module "ec2_instance" {
  source = "github.com/marcuwynu23/terraform-aws-ec2?ref=main"

  aws_region    = "ap-southeast-1"
  ami           = "ami-002fa10fbb7594252"
  instance_type = "t2.micro"
  instance_name = "my-app-vm"
  subnet_id     = "subnet-xxx"
  vpc_id        = "vpc-xxx"
}
```

Then use the outputs in your configuration:

```hcl
output "ec2_ip" {
  value = module.ec2_instance.instance_public_ip
}
```

All variables and outputs documented below are available when using this as a module.

## Variables

| Variable | Description | Type | Default |
|----------|-------------|------|---------|
| `aws_region` | AWS region | `string` | `"ap-southeast-1"` |
| `ami` | AMI ID for the EC2 instance | `string` | `"ami-002fa10fbb7594252"` |
| `instance_type` | EC2 instance type | `string` | `"t2.micro"` |
| `instance_name` | Name tag for instance | `string` | `"AwsVps"` |
| `subnet_id` | Subnet ID | `string` | (required) |
| `vpc_id` | VPC ID | `string` | (required) |
| `is_public_ip` | Assign public IP | `bool` | `true` |
| `create_key_pair` | Create SSH key pair | `bool` | `false` |
| `aws_key_pair_name` | SSH key pair name | `string` | `"marcuwynu23-aws"` |
| `aws_key_pair_public_key` | Path to public key file | `string` | `"./credentials/id_marcuwynu23_aws.pub"` |
| `aws_key_pair_private_key` | Path to private key file | `string` | `"./credentials/id_marcuwynu23_aws"` |

## Outputs

| Output | Description |
|--------|-------------|
| `instance_public_ip` | Public IP of EC2 instance |
| `instance_id` | EC2 instance ID |
| `instance_name` | Instance Name tag |
| `aws_key_pair_private_key` | Path to private key file |

## Security Considerations

- SSH access is currently open to `0.0.0.0/0` (not production-safe)
- Recommended to restrict SSH access to your IP only
- Store private keys securely and never commit them to version control

## Common Issues

### Instance not reachable
- Check security group inbound rules (port 22)
- Ensure correct key pair is used
- Verify subnet has internet gateway routing

### Invalid AMI
- AMI IDs differ per region; update `ami` variable
