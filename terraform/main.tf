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
  ami           = "ami-028fb9cd5f4fd31d5"
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
    Name = "LokiGrafana"
  }
}

resource "aws_instance" "base" {
  ami           = "ami-0948be65e4c29bce3"
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
    Name = "Learn-Packer-Base"
  }
}


resource "aws_instance" "hashicups" {
  ami           = "ami-09f1adfa86f3adc23"
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
}
