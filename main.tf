provider "aws" {
 region = "eu-west-3"
}

resource "aws_vpc" "main_vpc" {
 cidr_block = "10.0.0.0/16"

 tags = {
   Name = "Main VPC"
 }
}

resource "aws_subnet" "public_1" {
 vpc_id = aws_vpc.main_vpc.id
 cidr_block = "10.0.1.0/24"
 availability_zone = "eu-west-3a"

 tags = {
   Name = "public 1"
 }
}

resource "aws_subnet" "public_2" {
 vpc_id = aws_vpc.main_vpc.id
 cidr_block = "10.0.2.0/24"
 availability_zone = "eu-west-3b"

 tags = {
   Name = "public 2"
 }
}

resource "aws_subnet" "praivate_1" {
 vpc_id = aws_vpc.main_vpc.id
 cidr_block = "10.0.3.0/24"
 availability_zone = "eu-west-3a"

 tags = {
   Name = "private 1"
 }
}

resource "aws_subnet" "praivate_2" {
 vpc_id = aws_vpc.main_vpc.id
 cidr_block = "10.0.4.0/24"
 availability_zone = "eu-west-3b"

 tags = {
   Name = "private 2"
 }
}

resource "aws_internet_gateway" "GW" {
 vpc_id = aws_vpc.main_vpc.id

 tags = {
   Name = "Gateway"
 }
}

resource "aws_route_table" "RT" {
 vpc_id = aws_vpc.main_vpc.id

 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.GW.id
 }

 tags = {
   Name = "public route"
 }
}
