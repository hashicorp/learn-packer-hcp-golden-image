terraform {
  required_version = ">= 0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = "0.17.0"
    }
  }

  cloud {
    hostname = "app.terraform.io"

    workspaces {
      name = "learn-hcp-packer-golden-image"
    }
  }
}

