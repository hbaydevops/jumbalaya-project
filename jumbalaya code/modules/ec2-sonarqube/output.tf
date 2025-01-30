output "vpc_id" {
  value = data.aws_vpc.vpc.id
}

output "subnet_01" {
  value = data.aws_subnet.subnet_01.id
}

output "sonarqube_ami" {
  // value = data.aws_ami.s8-jenkins-master.id
  value = aws_instance.sonarqube.id
}

output "sonarqube-eip" {
  value = aws_eip.sonarqube_eip.id
}

output "key_pair_data" {
  value = var.key_name
}
