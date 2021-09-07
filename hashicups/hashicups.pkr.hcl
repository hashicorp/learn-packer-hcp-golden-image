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
  default = "learn-packer-hcp-hashicups"
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "hashicups" {
  ami_name      = "${var.ami_prefix}-${local.timestamp}"
  instance_type = "t2.micro"
  region        = "us-east-2"
  source_ami    = "ami-0848adeeaf368110a"
  // source_ami_filter {
  //   filters = {
  //     name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
  //     root-device-type    = "ebs"
  //     virtualization-type = "hvm"
  //   }
  //   most_recent = true
  //   owners      = ["099720109477"]
  // }
  ssh_username = "ubuntu"
}

build {
  name = "learn-packer-hashicups"
  sources = [
    "source.amazon-ebs.hashicups"
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
}
