# Create a VPC
resource "aws_vpc" "anish_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    NAME = "Dev"
  }
}
# Create a subnet
resource "aws_subnet" "anish_subnet" {
  vpc_id                  = aws_vpc.anish_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "Dev-subnet"
  }
}
# Create a internet gateway
resource "aws_internet_gateway" "anish_internet_gateway" {
  vpc_id = aws_vpc.anish_vpc.id

  tags = {
    Name = "Dev-igw"
  }
}
# Create a route table
resource "aws_route_table" "anish_route_table" {
  vpc_id = aws_vpc.anish_vpc.id

  tags = {
    Name = "Dev-RT"
  }
}
# Create a route
resource "aws_route" "anish_route" {
  route_table_id         = aws_route_table.anish_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.anish_internet_gateway.id

}
# Create a route table association
resource "aws_route_table_association" "anish_association" {
  subnet_id      = aws_subnet.anish_subnet.id
  route_table_id = aws_route_table.anish_route_table.id
}
resource "aws_security_group" "anish_security_group" {
  name        = "anish_security_group"
  description = "Allow access from only my IP"
  vpc_id      = aws_vpc.anish_vpc.id

  ingress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["136.226.3.79/32"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
      description      = "Incoming traffic"
    },

  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
      description      = "Outgoing traffic"
    },
  ]

  tags = {
    Name = "Dev-sg"
  }
}
resource "aws_key_pair" "anish_key" {
  key_name   = "anishkey"
  public_key = file("~/.ssh/anishkey.pub")
}
resource "aws_instance" "anish_instance" {
  instance_type          = "t2.micro"
  ami                    = data.aws_ami.anish_image.id
  key_name               = aws_key_pair.anish_key.id
  vpc_security_group_ids = [aws_security_group.anish_security_group.id]
  subnet_id              = aws_subnet.anish_subnet.id

  tags = {
    Name = "Dev-instance"
  }
  root_block_device {
    volume_size = 15
  }

}