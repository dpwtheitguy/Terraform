# aws_compute.tf
# Description: AWS EC2 template
# Daniel Wilson (daniel.p.wilson@live.com)
# SPDX-License-Identifier: CC0-1.0
# This code is released into the public domain and comes with no warranty or guarantee of any kind.
# Version 1.0.0

################################################################################
# AWS EC2 Instances
################################################################################
resource "aws_instance" "ec2_instance" {
  # ami           = var.ami_id
  # ami           = data.aws.ami.latest.id
  instance_type = var.instance_type
  tags = {
    Name                = var.instance_name
    data_classification = var.data_classification
    }
}

################################################################################
# EC2 Vars
################################################################################

# Instance Type
variable "policy_instance_types" {
  description       = "The list of valid instance types"
  sensitive         = false
  type              = list(string)
  default           = ["t2.micro", "t2.small", "t2.medium"]
}

variable "instance_type" {
  description       = "The instance type to use for the EC2 instance"
  sensitive         = false
  type              = string
  default           = "t2.micro"

  validation {
    condition       = can(index(var.policy_instance_types, var.instance_type))
    error_message   = "Invalid instance type. Valid options are: t2.micro, t2.small, t2.medium."
  }
}

# Names
variable "instance_name" {
  description       = "The name to assign to the EC2 instance and Name tag"
  sensitive         = false
  type              = string

  validation {
    condition       = length(trim(var.instance_name)) > 0 && length(trim(var.instance_name)) <= 255
    error_message   = "Instance name cannot be blank and must be no more than 255 characters."
  }
}

# AMI Type
variable "ami_id" {
  description       = "The ID of the Amazon Machine Image (AMI) to use for the EC2 instance if you want to hardcode"
  sensitive         = false
  type              = string

  validation {
    condition       = length(trim(var.ami_id)) > 0
    error_message   = "AMI ID cannot be blank."
  }
}

data "aws_ami" "latest" {
    most_recent     = true
    filter {
        name        = "name"
        values      = ["amzn-ami-hvm-*-x86_64-gp2"]
    }
    filter {
        name        = "virtualization-type"
        values      = ["hvm"]
    }
    owners          = ["amazon"]
}

output "latest_ami_id" {
    value           = data.aws_ami.latest.id
}
