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

variable "region_east" {
  description = "The default region Terraform deploys your instance"
  default     = "us-east-2"
}

variable "region_west" {
  description = "The second region Terraform deploys your instance"
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