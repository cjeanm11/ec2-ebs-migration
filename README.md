### EBS Volume Migration to New EC2 Instance with Terraform

This Terraform script uses a snapshot-based strategy to migrate an existing AWS EBS volume to a new EC2 instance. The process involves the following steps:

1.	**Capture the state of the existing EBS volume**: Create a snapshot of the existing EBS volume to preserve its data.
2.	**Create a new EBS volume from the snapshot**: Generate a new EBS volume from the snapshot, making it identical to the original.
3.	**Launch a new EC2 instance**: Deploy a new EC2 instance with a specified AMI tailored for the environment.
4.	**Attach the new EBS volume to the EC2 instance**: Connect the newly created EBS volume to the EC2 instance for data accessibility.

`terraform.tfvars` file exemple:

```hcl
aws_region            = "us-east-1"
existing_volume_id    = "vol-....."
availability_zone     = "us-east-1a"
instance_type         = "t2.micro"
volume_size           = 10  
device_name           = "/dev/xvdf"
ami_name_filter       = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
security_group_name   = "my-security-group"
virtualization_type   = ["hvm"]
ingress_from_port   = 8080
ingress_to_port     = 8080
ingress_protocol    = "tcp"
ingress_cidr_blocks = ["0.0.0.0/0"]
egress_cidr_blocks  = ["0.0.0.0/0"]
user_data           = "echo hello world > /var/tmp/test.txt"
instance_name       = "my-instance"
```