// provider "aws" {
//     profile = "awsbayombi" # Replace with your AWS profile name if different
//     region  = "us-east-1"  # Replace with your desired AWS region
//   }

//   resource "aws_instance" "terra_jenkins_master" {
//     ami           = "ami-0826b5825a7880550"
//     instance_type = "t2.micro" # Change instance type as needed
//     key_name      = "your-key-pair-name" # Replace with your key pair name

//     tags = {
//       Name = "terra-jenkins-master"
//     }

//     network_interface {
//       device_index          = 0
//       subnet_id             = "subnet-xxxxxxx" # Replace with your subnet ID
//       security_groups       = ["sg-02840ef3d2c5a30af"] # Replace with your security group ID
//       associate_public_ip_address = true # Change to false if in a private subnet
//     }

//     root_block_device {
//       volume_size = 8 # Default volume size in GB, adjust as needed
//       volume_type = "gp2" # General Purpose SSD
//     }

//     lifecycle {
//       create_before_destroy = true
//     }
//   }

//   output "instance_id" {
//     value = aws_instance.terra_jenkins_master.id
//   }

//   output "public_ip" {
//     value = aws_instance.terra_jenkins_master.public_ip
//   }

//   output "private_ip" {
//     value = aws_instance.terra_jenkins_master.private_ip
//   }
  