packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.1-dev"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "ami_prefix" {
  type    = string
  default = "learn-packer-hcp-golden-image"
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "base_east" {
  ami_name      = "${var.ami_prefix}-${local.timestamp}"
  instance_type = "t2.micro"
  region        = "us-east-2"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

source "amazon-ebs" "base_west" {
  ami_name      = "${var.ami_prefix}-${local.timestamp}"
  instance_type = "t2.micro"
  region        = "us-west-2"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

build {
  name = "learn-packer-golden"
  sources = [
    "source.amazon-ebs.base_east",
    "source.amazon-ebs.base_west"
  ]

  # Add SSH public key
  provisioner "file" {
    source      = "../learn-packer.pub"
    destination = "/tmp/learn-packer.pub"
  }

  # Execute setup script
  provisioner "shell" {
    script = "setup.sh"
    # Run script after cloud-init finishes, otherwise you run into race conditions
    execute_command = "/usr/bin/cloud-init status --wait && sudo -E -S sh '{{ .Path }}'"
  }

  # Add auditd rules to temp location
  provisioner "file" {
    source      = "audit.rules"
    destination = "/tmp/audit.rules"
  }

  # Update Docker daemon with Loki logs
  provisioner "file" {
    source      = "docker-daemon.json"
    destination = "/tmp/daemon.json"
  }

  # Add promtail configuration file
  provisioner "file" {
    source      = "promtail.yaml"
    destination = "/tmp/promtail.yaml"
  }

  # Add startup script that will run promtail on instance boot
  provisioner "file" {
    source      = "run-promtail.sh"
    destination = "/tmp/run-promtail.sh"
  }

  # Move temp files to actual destination
  # Must use this method because their destinations are protected 
  provisioner "shell" {
    inline = [
      "sudo cp /tmp/audit.rules /etc/audit/rules.d/audit.rules",
      "sudo mkdir /opt/promtail/",
      "sudo cp /tmp/promtail.yaml /opt/promtail/promtail.yaml",
      "sudo cp /tmp/run-promtail.sh /var/lib/cloud/scripts/per-boot/run-promtail.sh",
      "sudo cp /tmp/daemon.json /etc/docker/daemon.json",
    ]
  }

  # Execute setup script
  provisioner "shell" {
    script = "setup-promtail.sh"
  }

  # HCP Packer settings
  hcp_packer_registry {
    bucket_name = "learn-packer-hcp-golden-base-image"
    description = <<EOT
This is a golden image base built on top of ubuntu 20.04.
    EOT

    labels = {
      "hashicorp-learn" = "learn-packer-hcp-golden-image",
      "ubuntu-version"  = "20.04"
    }
  }
}