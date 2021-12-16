resource "aws_vpc" "main" {
  cidr_block           = var.vpc_subnet
  enable_dns_hostnames = true

}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnets
  map_public_ip_on_launch = "true"
  availability_zone       = var.availability_zone

}

resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnets
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = false

}
