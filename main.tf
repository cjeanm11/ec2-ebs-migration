provider "aws" {
  region = var.aws_region
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = var.ami_name_filter
  }

  filter {
    name   = "virtualization-type"
    values = var.virtualization_type
  }

  owners = var.ami_owners
}

# Create a new EBS volume directly from the existing EBS volume (Direct Copy)
resource "aws_ebs_volume" "new_data_volume_copy" {
  availability_zone = var.availability_zone
  size             = var.volume_size

  tags = {
    Name = "migrated-volume-${var.instance_name}"
  }
}

resource "aws_security_group" "sg_8080" {
  name = var.security_group_name

  ingress {
    from_port   = var.ingress_from_port
    to_port     = var.ingress_to_port
    protocol    = var.ingress_protocol
    cidr_blocks = var.ingress_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.egress_cidr_blocks
  }
}

resource "aws_instance" "new_instance" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.sg_8080.id]
  user_data              = var.user_data

  tags = {
    Name = "EC2-${var.instance_name}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_volume_attachment" "ebs_attach_copy" {
  device_name  = var.device_name
  volume_id    = aws_ebs_volume.new_data_volume_copy.id
  instance_id  = aws_instance.new_instance.id
}

output "volume_id" {
  value = aws_ebs_volume.new_data_volume_copy.id
}