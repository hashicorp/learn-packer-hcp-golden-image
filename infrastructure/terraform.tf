# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {
  required_version = "~>1.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.49.0"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.88.0"
    }
  }

  cloud {
    workspaces {
      project = "learn-packer-golden-image"
      name    = "learn-hcp-packer-golden-image"
    }
  }
}
