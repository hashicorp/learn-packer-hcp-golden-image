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
}

provider "aws" {
  region = var.region
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

resource "aws_instance" "hashicups" {
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

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "terraform"
      private_key = "${file("../learn-packer")}"
      host        = self.public_ip
    }
    inline = [
      "sudo sed -i 's/WILL_BE_REPLACED_BY_TF/${aws_instance.loki.public_ip}/g' /opt/promtail/promtail.yaml",
      "sudo sed -i 's/WILL_BE_REPLACED_BY_TF/${aws_instance.loki.public_ip}/g' /etc/docker/daemon.json",
      "sudo systemctl restart docker",
      "sudo cd /home/ubuntu && sudo docker-compose up -d",
      "sudo cd /opt/promtail && sudo nohup ./promtail-linux-amd64 -config.file=./promtail.yaml &"
    ]
  }
}
