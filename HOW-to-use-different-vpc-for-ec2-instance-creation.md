# How to use different vpc for ec2 instance creation

## create vpc instance

## set vpc id in aws_aws_security_group

```yml
vpc_id      = "vpc-0d541ad12136d30be"
```

## set subnet id in aws_instance creation

```yml
subnet_id       = "subnet-032b8e5de17263651"
```

associate public ip address

```yml
associate_public_ip_address = true
```
