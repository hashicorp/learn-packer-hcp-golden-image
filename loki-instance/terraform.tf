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
      name = "learn-hcp-packer-golden-image-rln"
    }
  }
}

