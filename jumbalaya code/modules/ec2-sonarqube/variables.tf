variable "aws_region" {
  description = "The region in aws"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "The EC2 instance type"
  type        = string
  default     = "t2.medium"
}

variable "instance_name" {
  description = "The EC2 instance name"
  type        = string
  default     = "terra-sonarqube"
}

variable "key_name" {
  description = "The key name for EC2 instance "
  type        = string
  default     = "terraform-assignments-key"
}


# Define the security group 
variable "security_group_name" {
  description = "The security group ID to associate with EC2 instances"
  type        = string
  default     = "terra-sonarqube-sg"
}


# Define the root block device volume size in GB
variable "root_volume" {
  description = "The size of the root block device in GB"
  type        = number
  default     = 30
}

# Elastic IP VPC setting
variable "eip_vpc" {
  description = "Specify whether the Elastic IP is for a VPC"
  type        = bool
  default     = true
}

variable "aws_s3_bucket" {
  description = "s3 bucket by terraform"
  type        = string
  default     = "terraform-s3-bucket-10"
}

variable "aws_dynamodb_table" {
  description = "DynamoDB table by terraform"
  type        = string
  default     = "a1helene_terraform_state_lock"
}

variable "backend_key" {
  description = "DynamoDB table by terraform"
  type        = string
  default     = "ec2"
}
# Instance ID to associate with the Elastic IP
/*
variable "eip_instance_id" {
  description = "The ID of the instance to associate with the Elastic IP"
  type        = string
  default     = aws_instance.ec2.id
}

variable "eip_allocation_id" {
    description = "The ID of the instance to associate with the Elastic IP"
    type        = string
    default     = aws_eip.jenkins_eip.id
  }
*/

# Base tags for resources
variable "tags" {
  description = "Base tags to be applied to all resources"
  type        = map(string)
  default = {
    "owner"          = "EK TECH SOFTWARE SOLUTION"
    "environment"    = "dev"
    "project"        = "del"
    "create_by"      = "Terraform"
    "cloud_provider" = "aws"
  }
}

# Custom tags, allowing the user to add extra or override tags
# variable "custom_tags" {
#   description = "Custom tags to be merged with the base tags"
#   type        = map(string)
#   default     = {}
# }

