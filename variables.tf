variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "ami_name_filter" {
  type    = list(string)
  default = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
}

variable "virtualization_type" {
  type    = list(string)
  default = ["hvm"]
}

variable "ami_owners" {
  type    = list(string)
  default = ["099720109477"]  # Canonical
}

variable "existing_volume_id" {
  type        = string
  description = "The ID of the existing EBS volume"
}

variable "availability_zone" {
  type        = string
  description = "The availability zone for the new EBS volume"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "device_name" {
  type    = string
  default = "/dev/xvdf"
}

variable "user_data" {
  type    = string
  default = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y apache2
    sed -i -e 's/80/8080/' /etc/apache2/ports.conf
    echo "Hello World" > /var/www/html/index.html
    systemctl restart apache2
  EOF
}

variable "existing_security_group_id" {
  type        = string
  description = "The ID of an existing security group to be used for the EC2 instance"
  default     = ""
}

variable "security_group_name" {
  type    = string
  default = "my-security-group"
}

variable "ingress_from_port" {
  type    = number
  default = 8080
}

variable "ingress_to_port" {
  type    = number
  default = 8080
}

variable "ingress_protocol" {
  type    = string
  default = "tcp"
}

variable "ingress_cidr_blocks" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "egress_cidr_blocks" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "instance_name" {
  type    = string
  default = "ec2-ebs-migration"
}
variable "volume_size" {
  type        = number
  description = "The size of the new EBS volume in GiB"
  default     = 8  
}

