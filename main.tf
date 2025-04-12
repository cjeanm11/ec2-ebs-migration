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

resource "null_resource" "stop_instance" {
  provisioner "local-exec" {
    command = "aws ec2 stop-instances --instance-ids ${var.existing_instance_id} --region ${var.aws_region}"
  }

  triggers = {
    always_run = timestamp()
  }
}

resource "null_resource" "force_detach_existing" {
  depends_on = [null_resource.stop_instance]
  
  provisioner "local-exec" {
    command = <<EOT
    aws ec2 detach-volume --volume-id ${var.existing_volume_id} --region ${var.aws_region}
    aws ec2 wait volume-available --volume-ids ${var.existing_volume_id} --region ${var.aws_region}
    EOT
  }

  triggers = {
    always_run = timestamp()
  }
}

resource "aws_volume_attachment" "reattach_existing" {
  depends_on  = [null_resource.force_detach_existing]
  device_name = var.device_name
  volume_id   = var.existing_volume_id
  instance_id = aws_instance.new_instance.id
}