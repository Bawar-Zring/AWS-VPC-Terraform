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

resource "aws_internet_gateway" "pub_gw" {
 vpc_id = aws_vpc.main_vpc.id

 tags = {
   Name = "public gateway"
 }
}

resource "aws_route_table" "pub_rt" {
 vpc_id = aws_vpc.main_vpc.id

 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.pub_gw.id
 }

 tags = {
   Name = "public route"
 }
}

resource "aws_route_table_association" "public_route_1" {
 subnet_id = aws_subnet.public_1.id
 route_table_id = aws_route_table.pub_rt.id
}

resource "aws_route_table_association" "public_route_2" {
 subnet_id = aws_subnet.public_2.id
 route_table_id = aws_route_table.pub_rt.id
}







