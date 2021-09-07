resource "aws_security_group" "ssh" {
  name   = "ssh_22"
  vpc_id = aws_vpc.vpc.id

  # SSH access from the VPC
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_egress" {
  name   = "allow_egress"
  vpc_id = aws_vpc.vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "promtail" {
  name   = "promtail_9800"
  vpc_id = aws_vpc.vpc.id

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

resource "aws_security_group" "hashicups" {
  name   = "hashicups_19090"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 19090
    to_port     = 19090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "loki_grafana" {
  name   = "loki_grafana_3100_3000"
  vpc_id = aws_vpc.vpc.id

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
