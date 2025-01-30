data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["default-vpc"] # Replace with the actual Name tag value of your VPC
  }
}


data "aws_subnet" "subnet_01" {
  filter {
    name   = "tag:Name"
    values = ["subnet-default-1a"]
  }
}


// data "aws_ami" "s8-jenkins-master" {
//   most_recent = true

//   filter {
//     name   = "name"
//     values = ["s8-jenkins-master"]
//   }
// }

/*
data "aws_security_group" "ec2_sg" {
  filter {
    name   = "tag:Name"
    values = ["ec2_security_group"]  # Replace with the exact name of the security group
  }
}

# or

data "aws_security_group" "sg_id" {
  id = "sg-02840ef3d2c5a30af"  # Replace with your actual security group ID
}
*/



# Data source to retrieve an AWS key pair by Name tag
// data "aws_key_pair" "terraform_key" {
//   filter {
//     name   = "tag:Name"
//     values = ["terraform-assignments-key"]  
//   }
// }




