variable "cidr_vpc" {
  description = "CIDR block for the VPC"
  default     = "10.1.0.0/16"
}
variable "cidr_subnet" {
  description = "CIDR block for the subnet"
  default     = "10.1.0.0/24"
}

variable "environment_tag" {
  description = "Environment tag"
  default     = "Learn"
}

variable "region" {
  description = "The region Terraform deploys your instance"
  default     = "us-east-2"
}

variable "hcp_bucket_loki" {
  description = "HCP Packer bucket name for loki image"
  default     = "learn-packer-hcp-loki-tonino"
}

variable "hcp_bucket_hashicups" {
  description = "HCP Packer bucket name for base golden image"
  default     = "learn-packer-hcp-hashicups-tonino"
}

variable "hcp_channel" {
  description = "HCP Packer channel name"
  default     = "production"
}