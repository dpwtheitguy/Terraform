# aws_provider.tf
# Description: AWS Provider Template
# Daniel Wilson (daniel.p.wilson@live.com)
# SPDX-License-Identifier: CC0-1.0
# This code is released into the public domain and comes with no warranty or guarantee of any kind.
# Version 1.0.0

################################################################################
# Provider Declaration here
################################################################################
provider "aws" {
  region        = var.aws_region
  access_key    = var.aws_access_key
  secret_key    = var.aws_secret_key
  version       = var.aws_provider_version
}

################################################################################
# Data for the provider goes here.
################################################################################
variable "aws_region" {
  description   = "The AWS region to use for resources."
  sensitive     = false
  type          = string
  default       = "us-west-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.aws_region))
    error_message = "Invalid AWS region format. The region should be in the format 'us-west-2' or 'eu-central-1'."
  }
}

variable "aws_access_key" {
  description   = "AWS Access key provided by release system"
  sensitive     = true
  type          = string
  default       = ""

validation {
    condition     = length(var.aws_access_key) > 0 && can(regex("^[A-Za-z0-9/+=]+$", var.aws_access_key))
    error_message = "Invalid AWS Access Key format. The key should be a base64-encoded string."
  }
}

variable "aws_secret_key" {
  description   = "AWS Secret key provided by release system"
  sensitive     = true
  type          = string
  default       = ""

  validation {
    condition     = length(var.aws_secret_key) > 0 && can(regex("^[A-Za-z0-9/+=]+$", var.aws_secret_key))
    error_message = "Invalid AWS Secret Key format. The key should be a base64-encoded string."
  }
}

variable "aws_provider_version" {
  type          = string
  description   = "The version of the AWS provider to use. Defaults to latest."
  default       = "latest"
  sensitive     = false

  validation {
    condition     = can(regex("^[0-9]+\\.[0-9]+\\.[0-9]+$|^latest$", var.aws_provider_version))
    error_message = "Invalid AWS provider version format. The version should be in the format 'x.y.z' or 'latest'."
  }
}
