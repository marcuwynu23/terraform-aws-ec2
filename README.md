# Terraform + AWS CLI Guidelines

## Initialize Terraform

This command initializes the Terraform working directory, downloads necessary provider plugins, and prepares the environment for running Terraform commands.

```sh
terraform init
```

### plan terraform

This command generates an execution plan, showing the changes Terraform will make to your infrastructure without applying them. It helps to preview the modifications.

```sh
terraform plan
```

### apply terraform

This command applies the Terraform configuration, creating, modifying, or deleting resources according to the defined configuration. The -auto-approve flag automatically confirms the operation without asking for confirmation.

```sh
 terraform apply  -auto-approve
```

### destroy terraform (optional)

If you want to destroy all the resources managed by your Terraform configuration, use the following command. The -auto-approve flag will automatically confirm the action.

```sh
terraform destroy -auto-approve
```

### select images to use based on regions in aws cli

To find available Amazon Machine Images (AMIs) for Amazon Linux 2 in a specific region, use the AWS CLI to describe the images. This example searches for amzn2-ami-hvm-\* in the us-east-1 region.

```sh
 aws ec2 describe-images --filters "Name=name,Values=amzn2-ami-hvm-*-x86_64-gp2" --query "Images[*].{ID:ImageId,Name:Name}" --region us-east-1
```

### select running instances based on regions in aws cli

This AWS CLI command will return information about running EC2 instances in a specific region (us-east-2 in this case), including their Instance ID, Type, State, and Public IP address.

```sh
aws ec2 describe-instances --query "Reservations[*].Instances[*].[InstanceId,InstanceType,State.Name,PublicIpAddress]" --region us-east-2
```

### create ssh key pair

To implement security for SSH connections to your EC2 instance, you can create a new SSH key pair using the following command. The -t ed25519 option specifies the creation of an Ed25519 key, which is more secure and recommended over RSA.

```sh
 ssh-keygen -t ed25519 -f <ssh_file>
```

### filter out public ip address that can be use as ssh host using terraform output + jq

To extract the public IP address of an EC2 instance from Terraform output and use it for SSH, pipe the JSON output to jq for filtering:

```sh
terraform output -json | jq -r ".instance_public_ip.value"
```

This command will return the public IP address of the EC2 instance in the output variable instance_public_ip.

### Common Default Usernames for Popular AMIs:

When SSHing into an EC2 instance, the default username depends on the operating system (AMI) used. Here’s a list of common default usernames for popular AMIs:

- **Amazon Linux 2 or Amazon Linux AMI**:  
  **Username**: `ec2-user`
- **Ubuntu**:  
  **Username**: `ubuntu`
- **CentOS**:  
  **Username**: `centos`
- **Debian**:  
  **Username**: `admin` or `debian`
- **Red Hat Enterprise Linux (RHEL)**:  
  **Username**: `ec2-user`
- **Fedora**:  
  **Username**: `fedora`
- **Windows Server** (via RDP, not SSH):  
  **Username**: `Administrator` (for RDP, not SSH)
