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
  # AMI for loki and hashicups image
  loki_images          = flatten(flatten(data.hcp_packer_image_iteration.loki.builds[*].images[*]))
  image_loki_us_east_2 = [for x in local.loki_images: x if x.region == "us-east-2"][0]

  hashicups_images          = flatten(flatten(data.hcp_packer_image_iteration.hashicups.builds[*].images[*]))
  image_hashicups_us_east_2 = [for x in local.hashicups_images: x if x.region == "us-east-2"][0]
}

provider "aws" {
  region = var.region
}
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*20*-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

// data "template_file" "user_data" {
//   template = file("./add-ssh.yaml")
// }

resource "aws_instance" "loki" {
  // ami           = data.aws_ami.ubuntu.id
  ami           = local.image_loki_us_east_2.image_id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet_public.id
  vpc_security_group_ids = [
    aws_security_group.ssh.id,
    aws_security_group.allow_egress.id,
    aws_security_group.loki_grafana.id,
  ]
  associate_public_ip_address = true
  // user_data                   = file("./start_loki_grafana.sh")
  // user_data                   = data.template_file.user_data.rendered

  tags = {
    Name = "Learn-Packer-LokiGrafana"
  }
}

// resource "aws_instance" "base" {
//   ami           = local.image_golden_us_east_2.image_id
//   instance_type = "t2.micro"
//   subnet_id     = aws_subnet.subnet_public.id
//   vpc_security_group_ids = [
//     aws_security_group.ssh.id,
//     aws_security_group.allow_egress.id,
//     aws_security_group.promtail.id,
//     aws_security_group.hashicups.id,
//   ]
//   associate_public_ip_address = true
//   // user_data                   = data.template_file.user_data.rendered

//   tags = {
//     Name = "Learn-Packer-Base"
//   }

//   depends_on = [
//     aws_instance.loki
//   ]

//   provisioner "remote-exec" {
//     inline = [
//       "sed -i 's/WILL_BE_REPLACED_BY_TF/${aws_instance.loki.public_ip}/g' /opt/promtail/promtail.yaml",
//       "sed -i 's/WILL_BE_REPLACED_BY_TF/${aws_instance.loki.public_ip}/g' /etc/docker/daemon.json"
//     ]
//   }
// }


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
  // user_data                   = data.template_file.user_data.rendered

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
