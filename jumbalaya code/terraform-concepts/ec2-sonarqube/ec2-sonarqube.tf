provider "aws" {
  region = "us-east-1" # Specify your AWS region
}

// # Define an AWS Key Pair
// resource "aws_key_pair" "key" {
//   key_name   = "sonarqube-key"
//   public_key = file("~/.ssh/id_rsa.pub") # Path to your public SSH key

// }

# Generate a new private key using the TLS provider
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Create the key pair in AWS using the public key from the TLS private key
resource "aws_key_pair" "key" {
  key_name   = "sonarqube-key"
  public_key = tls_private_key.example.public_key_openssh
}

# Save the private key to your local machine
resource "local_file" "private_key" {
  content  = tls_private_key.example.private_key_pem
  filename = "/c/Users/14047/Downloads/sonarqube-key.pem" # Save to Downloads folder
}


# Define a Security Group
resource "aws_security_group" "sonarqube_sg" {
  name_prefix = "sonarqube-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH access from anywhere (adjust as needed)
  }

  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SonarQube access from anywhere (adjust as needed)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }
}

# Launch a t2.micro EC2 instance
resource "aws_instance" "sonarqube" {
  ami             = "ami-0e1bed4f06a3b463d" # Ubuntu 22.04 AMI ID (adjust to your region)
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.key.key_name
  security_groups = [aws_security_group.sonarqube_sg.name]

  # User-data script to install SonarQube
  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y openjdk-11-jdk wget unzip
    wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.9.0.65466.zip
    unzip sonarqube-9.9.0.65466.zip -d /opt
    mv /opt/sonarqube-9.9.0.65466 /opt/sonarqube
    useradd -m -d /opt/sonarqube sonarqube
    chown -R sonarqube:sonarqube /opt/sonarqube
    su - sonarqube -c "/opt/sonarqube/bin/linux-x86-64/sonar.sh start"
  EOF

  tags = {
    Name = "SonarQube-Instance"
  }
}

# Create an AMI from the EC2 instance
resource "aws_ami_from_instance" "sonarqube_ami" {
  name               = "sonarqube-ami"
  source_instance_id = aws_instance.sonarqube.id
  depends_on         = [aws_instance.sonarqube]

  # Automatically terminate the EC2 instance once AMI is created
  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "SonarQube-AMI"
  }
}
