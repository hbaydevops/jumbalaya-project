resource "aws_security_group" "ec2_sg" {
  name        = var.security_group_name
  description = "Allow SSH and HTTP"
  vpc_id      = data.aws_vpc.vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
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