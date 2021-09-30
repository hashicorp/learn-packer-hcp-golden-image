provider "hcp" {}

data "hcp_packer_image_iteration" "loki" {
  bucket_name  = var.hcp_bucket_loki
  channel = var.hcp_channel
}

data "hcp_packer_image" "loki" {
  bucket_name     = var.hcp_bucket_loki
  cloud_provider = "aws"
  iteration_id   = data.hcp_packer_image_iteration.loki.id
  region          = "us-east-2"
}

provider "aws" {
  region = var.region_east
}

resource "aws_instance" "loki" {
  ami           = data.hcp_packer_image.loki.id
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
