
$action = $args[0]
$ssh_username = "ec2-user"


if ($action -eq "destroy") {
    Write-Host "Destroying Terraform resources..."
    terraform destroy -auto-approve
    exit 0
}
if ($action -eq "apply") {
    Write-Host "Applying Terraform configurations..."
    terraform apply -auto-approve

}

# Extract Outputs
$public_ip = (terraform output -json | ConvertFrom-Json).instance_public_ip.value
$ssh_private_key = (terraform output -json | ConvertFrom-Json).aws_key_pair_private_key.value

# Ensure Private Key Path (Assuming it's in the current directory)
$ssh_private_key_path = ".\$ssh_private_key"

if (-Not (Test-Path $ssh_private_key_path)) {
    Write-Error "❌ Private key file not found: $ssh_private_key_path"
    exit 1
}


# Execute SSH Command
& ssh -o StrictHostKeyChecking=no -i $ssh_private_key_path $ssh_username@$public_ip "ls -l /"
