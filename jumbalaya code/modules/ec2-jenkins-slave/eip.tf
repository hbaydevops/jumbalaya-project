# Create the Elastic IP
resource "aws_eip" "jenkins_eip" {
  vpc = true

  # Merge base_tags with custom_tags to form the final tag set
  tags = merge(
    var.tags,
    { Name = "Jenkins-master-eip" } # Default Name tag
  )
}

# Associate the Elastic IP with the instance
resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.ec2.id
  allocation_id = aws_eip.jenkins_eip.id
}