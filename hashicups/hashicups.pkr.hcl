# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "ami_prefix" {
  type    = string
  default = "learn-packer-hcp-hashicups"
}

data "hcp-packer-version" "golden" {
  bucket_name  = "learn-packer-hcp-golden-base-image"
  channel_name = "production"
}

data "hcp-packer-artifact" "golden_base_east" {
  bucket_name         = data.hcp-packer-version.golden.bucket_name
  version_fingerprint = data.hcp-packer-version.golden.fingerprint
  platform            = "aws"
  region              = "us-east-2"
}

data "hcp-packer-artifact" "golden_base_west" {
  bucket_name         = data.hcp-packer-version.golden.bucket_name
  version_fingerprint = data.hcp-packer-version.golden.fingerprint
  platform            = "aws"
  region              = "us-west-2"
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "hashicups_east" {
  ami_name      = "${var.ami_prefix}-${local.timestamp}"
  instance_type = "t2.micro"
  region        = "us-east-2"
  source_ami    = data.hcp-packer-artifact.golden_base_east.external_identifier
  ssh_username  = "ubuntu"
  tags = {
    Name        = "learn-hcp-packer-hashicups-east"
    environment = "production"
  }
  snapshot_tags = {
    environment = "production"
  }
}

source "amazon-ebs" "hashicups_west" {
  ami_name      = "${var.ami_prefix}-${local.timestamp}"
  instance_type = "t2.micro"
  region        = "us-west-2"
  source_ami    = data.hcp-packer-artifact.golden_base_west.external_identifier
  ssh_username  = "ubuntu"
  tags = {
    Name        = "learn-hcp-packer-hashicups-west"
    environment = "production"
  }
  snapshot_tags = {
    environment = "production"
  }
}

build {
  name = "learn-packer-hashicups"
  sources = [
    "source.amazon-ebs.hashicups_east",
    "source.amazon-ebs.hashicups_west"
  ]

  # Add SSH public key
  provisioner "file" {
    source      = "../learn-packer.pub"
    destination = "/tmp/learn-packer.pub"
  }

  # Add HashiCups configuration file
  provisioner "file" {
    source      = "conf.json"
    destination = "conf.json"
  }

  # Add Docker Compose file
  provisioner "file" {
    source      = "docker-compose.yml"
    destination = "docker-compose.yml"
  }

  # Add startup script that will run hashicups on instance boot
  provisioner "file" {
    source      = "start-hashicups.sh"
    destination = "/tmp/start-hashicups.sh"
  }

  # Move temp files to actual destination
  # Must use this method because their destinations are protected 
  provisioner "shell" {
    inline = [
      "sudo cp /tmp/start-hashicups.sh /var/lib/cloud/scripts/per-boot/start-hashicups.sh",
    ]
  }

  # HCP Packer settings
  hcp_packer_registry {
    bucket_name = "learn-packer-hcp-hashicups-image"
    description = <<EOT
This is an image for hashicups built on top of a golden base image.
    EOT

    bucket_labels = {
      "hashicorp-learn" = "learn-packer-hcp-hashicups-image",
    }
  }
}