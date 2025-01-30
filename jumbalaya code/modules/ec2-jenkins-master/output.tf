output "vpc_id" {
  value = data.aws_vpc.vpc.id
}

output "subnet_01" {
  value = data.aws_subnet.subnet_01.id
}

output "jenkins_master_ami" {
  // value = data.aws_ami.s8-jenkins-master.id
  value = aws_instance.ec2.id
}

output "Jenkins-master-eip" {
  value = aws_eip.jenkins_eip.id
}

output "key_pair_data" {
  value = var.key_name
}
