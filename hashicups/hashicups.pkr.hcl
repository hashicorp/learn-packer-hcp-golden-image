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

data "packer-image-iteration" "hardened_source" {
  bucket_name = "learn-packer-hcp-golden-base-image"
  channel = "production"
}

locals {
  timestamp           = regex_replace(timestamp(), "[- TZ:]", "")
  golden_base_image   = flatten(flatten(data.packer-image-iteration.hardened_source.builds[*].images[*]))
  image_hashicups_us_east_2 = [for x in local.golden_base_image: x if x.region == "us-east-2"][0]
}

source "amazon-ebs" "hashicups" {
  ami_name      = "${var.ami_prefix}-${local.timestamp}"
  instance_type = "t2.micro"
  region        = "us-east-2"
  ami_regions   = ["us-east-2", "us-west-2"]
  source_ami    = local.image_hashicups_us_east_2.image_id
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

  # HCP Packer settings
  hcp_packer_registry {
    bucket_name = "learn-packer-hcp-hashicups-image"
    description = <<EOT
This is an image for hashicups built on top of a golden base image.
    EOT

    labels = {
      "hashicorp-learn"       = "learn-packer-hcp-golden-image",
      "ubuntu-version"        = "20.04"
    }
  }
}