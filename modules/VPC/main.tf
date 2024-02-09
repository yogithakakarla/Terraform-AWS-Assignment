
data "aws_availability_zones" "available" {}

resource "aws_vpc" "Main" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "terraform-vpc-${var.env}"
  }
}

locals {
  public_subnet_bits = 4 // Using /20 subnet mask for consistency
}

resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.Main.id
  tags = {
    Name = "tf-igw-${var.env}"
  }

}
resource "aws_subnet" "public_subnets" {
  vpc_id            = aws_vpc.Main.id
  count             = 3
  cidr_block        = cidrsubnet(var.vpc_cidr, local.public_subnet_bits, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "Public-Subnet-${count.index + 1}"
  }
}

locals {
  private_subnet_bits = 4 // Using /20 subnet mask for consistency
}

resource "aws_subnet" "private_subnets" {
  vpc_id            = aws_vpc.Main.id
  count             = 3
  cidr_block        = cidrsubnet(var.vpc_cidr, local.private_subnet_bits, count.index + 3) // Start from index 3 for private subnets
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "Private-Subnet-${count.index + 1}"
  }
}
resource "aws_route_table" "PublicRT" {
  vpc_id = aws_vpc.Main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }
}
resource "aws_route_table" "PrivateRT" {
  vpc_id = aws_vpc.Main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NATgw.id
  }
}
resource "aws_route_table_association" "PublicRTassociation" {
  route_table_id = aws_route_table.PublicRT.id
  count          = 3
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
}
resource "aws_route_table_association" "PrivateRTassociation" {
  subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
  route_table_id = aws_route_table.PrivateRT.id
  count          = 3
}
resource "aws_eip" "nateIP" {
  domain = "vpc"
}
resource "aws_nat_gateway" "NATgw" {
  allocation_id = aws_eip.nateIP.id
  subnet_id     = "${aws_subnet.public_subnets.*.id}" [0]
}
