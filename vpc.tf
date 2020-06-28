provider "aws" {
#  profile = "my"
  region  = "eu-west-1"
}

resource "aws_vpc" "hillel5_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Hillel5 VPC"
  }
}

resource "aws_security_group" "hillel5_sg_ssh" {
  name        = "hillel5_sg_ssh"
  description = "SSH security_group for hillel5"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "hillel5_sg_http" {
  name        = "hillel5_sg_http"
  description = "for homework purposes"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
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

resource "aws_subnet" "hillel5_sn_public_a" {
  vpc_id                  = aws_vpc.hillel5_vpc.id
  cidr_block              = "10.0.10.0/24"
  map_public_ip_on_launch = true
  availability_zone_id    = "euw1-az1"
  tags = {
    Name = "Hillel5 Public Subnet A"
  }
}

resource "aws_subnet" "hillel5_sn_public_b" {
  vpc_id                  = aws_vpc.hillel5_vpc.id
  cidr_block              = "10.0.20.0/24"
  map_public_ip_on_launch = true
  availability_zone_id    = "euw1-az2"
  tags = {
    Name = "Hillel5 Public Subnet B"
  }
}

resource "aws_subnet" "hillel5_sn_private_a" {
  vpc_id               = aws_vpc.hillel5_vpc.id
  cidr_block           = "10.0.11.0/24"
  availability_zone_id = "euw1-az2"
  tags = {
    Name = "Hillel5 Private Subnet A"
  }

}

resource "aws_subnet" "hillel5_sn_private_b" {
  vpc_id               = aws_vpc.hillel5_vpc.id
  cidr_block           = "10.0.21.0/24"
  availability_zone_id = "euw1-az2"
  tags = {
    Name = "Hillel5 Private Subnet B"
  }
}

resource "aws_subnet" "hillel5_sn_database_a" {
  vpc_id               = aws_vpc.hillel5_vpc.id
  cidr_block           = "10.0.12.0/24"
  availability_zone_id = "euw1-az2"
  tags = {
    Name = "Hillel5 Subnet DB A"
  }
}


resource "aws_subnet" "hillel5_sn_database_b" {
  vpc_id               = aws_vpc.hillel5_vpc.id
  cidr_block           = "10.0.22.0/24"
  availability_zone_id = "euw1-az2"
  tags = {
    Name = "Hillel5 Subnet DB  B"
  }
}

resource "aws_internet_gateway" "hillel5_igw" {
  vpc_id = aws_vpc.hillel5_vpc.id
  tags = {
    Name = "Hillel5 IGW"
  }
}

resource "aws_eip" "hillel5_eip_a" {
  vpc = true
  tags = {
    Name = "Hillel5 EIP A"
  }
}

resource "aws_eip" "hillel5_eip_b" {
  vpc = true
  tags = {
    Name = "Hillel5 EIP B"
  }
}

resource "aws_nat_gateway" "hillel5_nat_a" {
  subnet_id     = aws_subnet.hillel5_sn_database_a.id
  allocation_id = aws_eip.hillel5_eip_a.id
  tags = {
    Name = "Hillel5 NAT A"
  }
}

resource "aws_nat_gateway" "hillel5_nat_b" {
  subnet_id     = aws_subnet.hillel5_sn_database_b.id
  allocation_id = aws_eip.hillel5_eip_b.id
  tags = {
    Name = "Hillel5 NAT B"
  }
}

resource "aws_route_table" "hillel5_rt_public_a" {
  vpc_id = aws_vpc.hillel5_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.hillel5_igw.id
  }
  
  tags = {
    Name = "Hillel5 Public Route Table A"
  }
}


resource "aws_route_table" "hillel5_rt_public_b" {
  vpc_id = aws_vpc.hillel5_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.hillel5_igw.id
  }

  tags = {
    Name = "Hillel5 Public Route Table B"
  }
}

resource "aws_route_table_association" "hillel5_rta_pub_a" {
  subnet_id      = aws_subnet.hillel5_sn_public_a.id
  route_table_id = aws_route_table.hillel5_rt_public_a.id
}

resource "aws_route_table_association" "hillel5_rta_pub_b" {
  subnet_id      = aws_subnet.hillel5_sn_public_b.id
  route_table_id = aws_route_table.hillel5_rt_public_b.id
}

resource "aws_route_table" "hillel5_rt_private_a" {
  vpc_id = aws_vpc.hillel5_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.hillel5_nat_a.id
  }
  tags = {
    Name = "Hillel5 Private Route Table A"
  }
}

resource "aws_route_table_association" "hillel5_rta_private_a" {
  subnet_id      = aws_subnet.hillel5_sn_private_a.id
  route_table_id = aws_route_table.hillel5_rt_private_a.id
}

resource "aws_route_table" "hillel5_rt_private_b" {
  vpc_id = aws_vpc.hillel5_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.hillel5_nat_b.id
  }
  tags = {
    Name = "Hillel5 Private Route Table A"
  }
}

resource "aws_route_table_association" "hillel5_rta_private_b" {
  subnet_id      = aws_subnet.hillel5_sn_private_b.id
  route_table_id = aws_route_table.hillel5_rt_private_b.id
}

resource "aws_instance" "hillel5_instance_http" {
  ami                    = "ami-0ea3405d2d2522162"
  count                  = 1
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.hillel5_sg_ssh.id, aws_security_group.hillel5_sg_http.id]
  key_name               = "aws_admin"

  tags = {
    Name    = "Hillel5 Linux Webserver"
  }
}

resource "aws_instance" "hillel5_instance_db" {
  ami                    = "ami-0ea3405d2d2522162"
  count                  = 1
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.hillel5_sg_ssh.id, aws_security_group.hillel5_sg_http.id]
  key_name               = "aws_admin"
#  subnet_id              = [hillel5_sn_database_a.id]
#  private_ip             = "10.0.12.17"

  tags = {
    Name    = "Hillel5 DB Server"
  }
}
