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

  # Merge base_tags with custom_tags to form the final tag set
  tags = merge(
    var.tags,
    { Name = var.security_group_name } # Default Name tag
  )

}