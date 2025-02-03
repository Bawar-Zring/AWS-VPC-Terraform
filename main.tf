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
 map_public_ip_on_launch = true

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

resource "aws_instance" "public1" {
 ami = "ami-08461dc8cd9e834e0"
 instance_type = "t2.micro"
 subnet_id = aws_subnet.public_1.id
 key_name = aws_key_pair.ec2_test.key_name
 associate_public_ip_address = true
 vpc_security_group_ids = [aws_security_group.access.id]

 user_data = <<-EOF
 #!/bin/bash
# Use this for your user data (script from top to bottom)
# install httpd (Linux 2 version)
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
EOF

 tags = {
   Name = "public AZ"
 }
}

resource "aws_instance" "private2" {
 ami = "ami-08461dc8cd9e834e0"
 instance_type = "t2.micro"
 subnet_id = aws_subnet.praivate_2.id

 tags = {
   Name = "private AZ"
 }
}

output "public_ip_address1" {
 value = aws_instance.public1.public_ip
}

output "public_ip_address2" {
 value = aws_instance.private2.public_ip
}

resource "aws_key_pair" "ec2_test" {
 key_name = "test"
 public_key = file("./id_rsa.pub.pub")
}

resource "aws_security_group" "access" {
 name = "allow_ssh_http"
 description = "allow ssh and http"
 vpc_id      = aws_vpc.main_vpc.id

 ingress {
   from_port = 22
   to_port = 22
   protocol = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }

 ingress {
   from_port   = 80
   to_port     = 80
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]  
  }

 egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
  }
}

