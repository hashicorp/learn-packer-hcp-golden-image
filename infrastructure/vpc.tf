# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# us-east-2 region
resource "aws_vpc" "vpc_east" {
  cidr_block           = var.cidr_vpc_east
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "igw_east" {
  vpc_id = aws_vpc.vpc_east.id
}

resource "aws_subnet" "subnet_public_east" {
  vpc_id            = aws_vpc.vpc_east.id
  cidr_block        = var.cidr_subnet_east
  availability_zone = "us-east-2a"
}

resource "aws_route_table" "rtb_public_east" {
  vpc_id = aws_vpc.vpc_east.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_east.id
  }
}

resource "aws_route_table_association" "rta_subnet_public_east" {
  subnet_id      = aws_subnet.subnet_public_east.id
  route_table_id = aws_route_table.rtb_public_east.id
}

# us-west-2 region
resource "aws_vpc" "vpc_west" {
  provider             = aws.west
  cidr_block           = var.cidr_vpc_west
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "igw_west" {
  provider = aws.west
  vpc_id   = aws_vpc.vpc_west.id
}

resource "aws_subnet" "subnet_public_west" {
  provider          = aws.west
  vpc_id            = aws_vpc.vpc_west.id
  cidr_block        = var.cidr_subnet_west
  availability_zone = "us-west-2a"
}

resource "aws_route_table" "rtb_public_west" {
  provider = aws.west
  vpc_id   = aws_vpc.vpc_west.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_west.id
  }
}

resource "aws_route_table_association" "rta_subnet_public_west" {
  provider       = aws.west
  subnet_id      = aws_subnet.subnet_public_west.id
  route_table_id = aws_route_table.rtb_public_west.id
}