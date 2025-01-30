provider "aws" {
  region = "us-east-1" # Replace with your desired AWS region
}

resource "aws_security_group" "sonarqube_sg" {
  name        = "sonarqube_sg"
  description = "Security group for SonarQube EC2 instance"

  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "sonarqube" {
  ami             = "ami-0e1bed4f06a3b463d"     # Ubuntu 22.04,Replace with a valid Ubuntu AMI ID
  instance_type   = "t2.medium"                 # Choose an appropriate instance type
  key_name        = "terraform-assignments-key" # Replace with your SSH key pair name
  security_groups = [aws_security_group.sonarqube_sg.name]
  

  user_data       = file("${path.module}/script/sonarqube_install2.sh")
  root_block_device {
    volume_size =  30
  }
  tags = {
    Name = "SonarQube-EC2"
  }
}
  