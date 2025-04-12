### EBS Volume Migration to New EC2 Instance with Terraform

This Terraform script provides two different strategies to migrate an existing AWS EBS volume to a new EC2 instance, based on the current Git branch.

1.	Snapshot-Based Strategy (i.e. `git checkout main`):
*	Captures the state of the existing EBS volume by creating a snapshot.
*	Uses the snapshot to create a new EBS volume.
*	Launches a new EC2 instance with the specified AMI and attaches the new EBS volume.

**Pro**: Reliable backup with easy recovery; snapshot portability.
**Con**: Storage costs, time-consuming, and extra complexity.


2.	Direct Copy Strategy (i.e. `git checkout direct_copy`):
*	Directly copies the existing EBS volume to a new volume without creating a snapshot.
*	Launches a new EC2 instance and attaches the newly created volume to it.

**Pro**: Faster, no snapshot storage costs, and simpler.
**Con**: No backup, potential data corruption, limited flexibility.

3.	Reattach Existing EBS Volume Strategy (i.e. `git checkout reattach`):
*	Stops the existing EC2 instance.
*	Detaches the existing EBS volume from the current EC2 instance.
*	Launches a new EC2 instance.
*	Attaches the previously detached EBS volume to the new EC2 instance.

**Pro**: Cost-effective, no data duplication, and maintains data integrity.
**Con**: Downtime required, data loss risk, and complexity in handling.


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
existing_instance_id = "..." # used for reattach strategy (3)