provider "hcp" {}

data "hcp_packer_image_iteration" "loki" {
  bucket_name = var.hcp_bucket_loki
  channel     = var.hcp_channel
}

data "hcp_packer_image" "loki" {
  bucket_name    = var.hcp_bucket_loki
  cloud_provider = "aws"
  iteration_id   = data.hcp_packer_image_iteration.loki.id
  region         = "us-east-2"
}

data "hcp_packer_image_iteration" "hashicups" {
  bucket_name = var.hcp_bucket_hashicups
  channel     = var.hcp_channel
}

data "hcp_packer_image" "hashicups_west" {
  bucket_name    = var.hcp_bucket_hashicups
  cloud_provider = "aws"
  iteration_id   = data.hcp_packer_image_iteration.hashicups.id
  region         = "us-west-2"
}

data "hcp_packer_image" "hashicups_east" {
  bucket_name    = var.hcp_bucket_hashicups
  cloud_provider = "aws"
  iteration_id   = data.hcp_packer_image_iteration.hashicups.id
  region         = "us-east-2"
}

provider "aws" {
  region = var.region_east
}

provider "aws" {
  alias  = "west"
  region = var.region_west
}

resource "aws_instance" "loki" {
  ami           = data.hcp_packer_image.loki.cloud_image_id
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

/*
resource "aws_instance" "hashicups_east" {
  ami           = data.hcp_packer_image.hashicups_east.cloud_image_id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet_public_east.id
  vpc_security_group_ids = [
    aws_security_group.ssh_east.id,
    aws_security_group.allow_egress_east.id,
    aws_security_group.promtail_east.id,
    aws_security_group.hashicups_east.id,
  ]
  associate_public_ip_address = true

  tags = {
    Name = "Learn-Packer-HashiCups"
  }

  depends_on = [
    aws_instance.loki
  ]
}

resource "aws_instance" "hashicups_west" {
  provider      = aws.west
  ami           = data.hcp_packer_image.hashicups_west.cloud_image_id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet_public_west.id
  vpc_security_group_ids = [
    aws_security_group.ssh_west.id,
    aws_security_group.allow_egress_west.id,
    aws_security_group.promtail_west.id,
    aws_security_group.hashicups_west.id,
  ]
  associate_public_ip_address = true

  tags = {
    Name = "Learn-Packer-HashiCups"
  }

  depends_on = [
    aws_instance.loki
  ]
}
*/
