# Create the Elastic IP
resource "aws_eip" "sonarqube_eip" {
  vpc = true

  # Merge base_tags with custom_tags to form the final tag set
  tags = merge(
    var.tags,
    { Name = "sonarqube-eip" } # Default Name tag
  )
}

# Associate the Elastic IP with the instance
resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.sonarqube.id
  allocation_id = aws_eip.sonarqube_eip.id
}