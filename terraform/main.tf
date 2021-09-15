provider "hcp" {}

data "hcp_packer_image_iteration" "loki" {
  bucket  = var.hcp_bucket_loki
  channel = var.hcp_channel
}

data "hcp_packer_image_iteration" "hashicups" {
  bucket  = var.hcp_bucket_hashicups
  channel = var.hcp_channel
}

locals {
  # AMI for Loki and HashiCups image
  loki_images          = flatten(flatten(data.hcp_packer_image_iteration.loki.builds[*].images[*]))
  image_loki_us_east_2 = [for x in local.loki_images: x if x.region == "us-east-2"][0]

  hashicups_images          = flatten(flatten(data.hcp_packer_image_iteration.hashicups.builds[*].images[*]))
  image_hashicups_us_east_2 = [for x in local.hashicups_images: x if x.region == "us-east-2"][0]
  image_hashicups_us_west_2 = [for x in local.hashicups_images: x if x.region == "us-west-2"][0]
}

provider "aws" {
  region = var.region_east
}

provider "aws" {
  alias  = "west"
  region = var.region_west
}

resource "aws_instance" "loki" {
  ami           = local.image_loki_us_east_2.image_id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet_public.id
  vpc_security_group_ids = [
    aws_security_group.ssh.id,
    aws_security_group.allow_egress.id,
    aws_security_group.loki_grafana.id,
  ]
  associate_public_ip_address = true

  tags = {
    Name = "Learn-Packer-LokiGrafana"
  }
}

/*
resource "aws_instance" "hashicups_east" {
  ami           = local.image_hashicups_us_east_2.image_id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet_public.id
  vpc_security_group_ids = [
    aws_security_group.ssh.id,
    aws_security_group.allow_egress.id,
    aws_security_group.promtail.id,
    aws_security_group.hashicups.id,
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
  ami           = local.image_hashicups_us_west_2.image_id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet_public.id
  vpc_security_group_ids = [
    aws_security_group.ssh.id,
    aws_security_group.allow_egress.id,
    aws_security_group.promtail.id,
    aws_security_group.hashicups.id,
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
