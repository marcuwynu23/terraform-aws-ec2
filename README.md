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

## Resources Created

- `aws_instance.aws_vps` – EC2 virtual machine
- `aws_key_pair.generated_key` – SSH key pair (optional)
- `aws_security_group.allow_ssh` – Security group allowing SSH access

## Remote State Management (S3 Backend)

This module uses AWS S3 as the Terraform backend for remote state management with DynamoDB for state locking.

### Create the Backend Resources

Run the following commands once per AWS account to create the bucket and lock table:

```bash
# Create S3 bucket for Terraform state
aws s3api create-bucket \
  --bucket your-terraform-state-bucket \
  --region ap-southeast-1 \
  --create-bucket-configuration LocationConstraint=ap-southeast-1

# Enable versioning on the bucket
aws s3api put-bucket-versioning \
  --bucket your-terraform-state-bucket \
  --versioning-configuration Status=Enabled

# Create DynamoDB table for state locking
aws dynamodb create-table \
  --table-name terraform-state-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region ap-southeast-1
```

### Configure the Backend

Create a `backend.tfvars` file:

```hcl
bucket         = "your-terraform-state-bucket"
key            = "ec2/terraform.tfstate"
region         = "ap-southeast-1"
dynamodb_table = "terraform-state-lock"
encrypt        = true
```

Initialize with the backend config:

```bash
terraform init -backend-config="backend.tfvars"
```

### GitHub Actions CI/CD

Two workflows are available for automated deployment:

| Workflow | Description |
|----------|-------------|
| `terraform-cd-apply.yml` | Plan and provision infrastructure |
| `terraform-cd-destroy.yml` | Tear down infrastructure |

#### Required GitHub Secrets

| Secret | Description |
|--------|-------------|
| `AWS_ACCESS_KEY_ID` | AWS access key ID |
| `AWS_SECRET_ACCESS_KEY` | AWS secret access key |
| `TF_STATE_BUCKET` | S3 bucket name for Terraform state |
| `TF_STATE_REGION` | AWS region for the state bucket |
| `TF_STATE_LOCK_TABLE` | DynamoDB table for state locking |

## Common Issues

### Instance not reachable
- Check security group inbound rules (port 22)
- Ensure correct key pair is used
- Verify subnet has internet gateway routing

### Invalid AMI
- AMI IDs differ per region; update `ami` variable
