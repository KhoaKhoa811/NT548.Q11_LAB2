# AMI Data Source - Get latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Key Pair for EC2 access
resource "aws_key_pair" "deployer" {
  key_name   = "${var.project_name}-key"
  public_key = var.ssh_public_key

  tags = {
    Name        = "${var.project_name}-key"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Bastion Host EC2 Instance
resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = var.bastion_instance_type
  key_name                    = aws_key_pair.deployer.key_name
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.bastion_sg_id]
  associate_public_ip_address = true

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    encrypted             = true
    delete_on_termination = true

    tags = {
      Name        = "${var.project_name}-bastion-root-volume"
      Environment = var.environment
    }
  }

  monitoring = true

  tags = {
    Name        = "${var.project_name}-bastion"
    Environment = var.environment
    Project     = var.project_name
    Role        = "bastion"
  }
}

# Application EC2 Instance (in private subnet)
resource "aws_instance" "app_server" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.app_instance_type
  key_name               = aws_key_pair.deployer.key_name
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [var.app_sg_id]

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 30
    encrypted             = true
    delete_on_termination = true

    tags = {
      Name        = "${var.project_name}-app-root-volume"
      Environment = var.environment
    }
  }

  monitoring = true

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              yum install -y docker
              systemctl start docker
              systemctl enable docker
              usermod -aG docker ec2-user
              EOF
  )

  tags = {
    Name        = "${var.project_name}-app-server"
    Environment = var.environment
    Project     = var.project_name
    Role        = "application"
  }
}

