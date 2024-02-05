# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "hcp" {}

data "hcp_packer_version" "loki" {
  bucket_name  = var.hcp_bucket_loki
  channel_name = var.hcp_channel
}

data "hcp_packer_artifact" "loki" {
  bucket_name         = data.hcp_packer_version.loki.bucket_name
  version_fingerprint = data.hcp_packer_version.loki.fingerprint
  platform            = "aws"
  region              = "us-east-2"
}

provider "aws" {
  region = var.region_east
}

# This provider is used to deploy resources to 
# the us-west-2 region
provider "aws" {
  alias  = "west"
  region = var.region_west
}

resource "aws_instance" "loki" {
  ami           = data.hcp_packer_artifact.loki.external_identifier
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet_public_east.id
  vpc_security_group_ids = [
    aws_security_group.ssh_east.id,
    aws_security_group.allow_egress_east.id,
    aws_security_group.loki_grafana_east.id,
  ]
  associate_public_ip_address = true

  tags = {
    Name = "Learn-Packer-LokiGrafana"
  }
}