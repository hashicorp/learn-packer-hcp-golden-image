# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# us-east-2 region
resource "aws_security_group" "ssh_east" {
  name   = "ssh_22"
  vpc_id = aws_vpc.vpc_east.id

  # SSH access from the VPC
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_egress_east" {
  name   = "allow_egress"
  vpc_id = aws_vpc.vpc_east.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "promtail_east" {
  name   = "promtail_9800"
  vpc_id = aws_vpc.vpc_east.id

  ingress {
    from_port   = 9800
    to_port     = 9800
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "hashicups_east" {
  name   = "hashicups_19090"
  vpc_id = aws_vpc.vpc_east.id

  ingress {
    from_port   = 19090
    to_port     = 19090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "loki_grafana_east" {
  name   = "loki_grafana_3100_3000"
  vpc_id = aws_vpc.vpc_east.id

  ingress {
    from_port   = 3100
    to_port     = 3100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# us-west-2 region
resource "aws_security_group" "ssh_west" {
  provider = aws.west
  name     = "ssh_22"
  vpc_id   = aws_vpc.vpc_west.id

  # SSH access from the VPC
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_egress_west" {
  provider = aws.west
  name     = "allow_egress"
  vpc_id   = aws_vpc.vpc_west.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "promtail_west" {
  provider = aws.west
  name     = "promtail_9800"
  vpc_id   = aws_vpc.vpc_west.id

  ingress {
    from_port   = 9800
    to_port     = 9800
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "hashicups_west" {
  provider = aws.west
  name     = "hashicups_19090"
  vpc_id   = aws_vpc.vpc_west.id

  ingress {
    from_port   = 19090
    to_port     = 19090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "loki_grafana_west" {
  provider = aws.west
  name     = "loki_grafana_3100_3000"
  vpc_id   = aws_vpc.vpc_west.id

  ingress {
    from_port   = 3100
    to_port     = 3100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}