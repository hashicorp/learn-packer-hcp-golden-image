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
  default = "learn-packer-hcp-loki-server"
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

data "amazon-ami" "ubuntu-focal" {
  region = "us-east-2"
  filters = {
    name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }
  most_recent = true
  owners      = ["099720109477"]
}

source "amazon-ebs" "base" {
  ami_name      = "${var.ami_prefix}-${local.timestamp}"
  instance_type = "t2.micro"
  region        = "us-east-2"
  source_ami    = data.amazon-ami.ubuntu-focal.id
  ssh_username  = "ubuntu"
  tags = {
    Name        = "learn-hcp-packer-loki"
    environment = "production"
  }
  snapshot_tags = {
    environment = "production"
  }
}

build {
  name = "learn-packer-loki-server"
  sources = [
    "source.amazon-ebs.base"
  ]

  # Add SSH public key
  provisioner "file" {
    source      = "../learn-packer.pub"
    destination = "/tmp/learn-packer.pub"
  }

  # Add Loki configuration file
  provisioner "file" {
    source      = "loki-local-config.yaml"
    destination = "loki-local-config.yaml"
  }

  # Add startup script that will run loki and grafana on instance boot
  provisioner "file" {
    source      = "start-loki-grafana.sh"
    destination = "/tmp/start-loki-grafana.sh"
  }

  # Execute setup script
  provisioner "shell" {
    script = "loki-setup.sh"
    # Run script after cloud-init finishes, otherwise you run into race conditions
    execute_command = "/usr/bin/cloud-init status --wait && sudo -E -S sh '{{ .Path }}'"
  }

  # Move temp files to actual destination
  # Must use this method because their destinations are protected
  provisioner "shell" {
    inline = [
      "sudo cp /tmp/start-loki-grafana.sh /var/lib/cloud/scripts/per-boot/start-loki-grafana.sh",
      "rm /tmp/start-loki-grafana.sh",
    ]
  }

  # HCP Packer settings
  hcp_packer_registry {
    bucket_name = "learn-packer-hcp-loki-image"
    description = <<EOT
This is an image for loki built on top of ubuntu 20.04.
    EOT

    bucket_labels = {
      "hashicorp-learn" = "learn-packer-hcp-loki-image",
      "ubuntu-version"  = "20.04"
    }
  }
}
