resource "aws_key_pair" "deployer" {
  key_name   = "terra-automate-key"
  public_key = file("${path.module}/terra-key.pub")
}

resource "aws_default_vpc" "default" {}

resource "aws_security_group" "allow_user_to_connect" {
  name        = "allow_tls"
  description = "Allow user to connect"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    description = "Allow SSH (22)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP (80)"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS (443)"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outgoing traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mysecurity"
  }
}

resource "aws_instance" "testinstance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.allow_user_to_connect.id]

  tags = {
    Name = "Automate"
  }

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }
}


