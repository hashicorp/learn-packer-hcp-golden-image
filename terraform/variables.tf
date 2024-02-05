# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "cidr_vpc_east" {
  description = "CIDR block for the VPC"
  default     = "10.1.0.0/16"
}
variable "cidr_subnet_east" {
  description = "CIDR block for the subnet"
  default     = "10.1.0.0/24"
}

variable "cidr_vpc_west" {
  description = "CIDR block for the VPC"
  default     = "10.2.0.0/16"
}
variable "cidr_subnet_west" {
  description = "CIDR block for the subnet"
  default     = "10.2.0.0/24"
}

variable "environment_tag" {
  description = "Environment tag"
  default     = "Learn"
}

variable "region_east" {
  description = "The default region where Terraform deploys your resources"
  default     = "us-east-2"
}

variable "region_west" {
  description = "The second region where Terraform deploys your resources"
  default     = "us-west-2"
}

variable "hcp_bucket_loki" {
  description = "HCP Packer bucket name for loki image"
  default     = "learn-packer-hcp-loki-image"
}

variable "hcp_bucket_hashicups" {
  description = "HCP Packer bucket name for base golden image"
  default     = "learn-packer-hcp-hashicups-image"
}

variable "hcp_channel" {
  description = "HCP Packer channel name"
  default     = "production"
}