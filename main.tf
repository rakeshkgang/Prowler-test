provider "aws" {
  region = "eu-north-1"  # Change this to your desired region
}

# Create a new VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "MyVPC"
  }
}

# Create a subnet within the VPC
resource "aws_subnet" "my_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-north-1a"  # Change based on your region
  map_public_ip_on_launch = true

  tags = {
    Name = "MySubnet"
  }
}

# Create an internet gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "MyInternetGateway"
  }
}

# Create a route table
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "MyRouteTable"
  }
}

# Associate the route table with the subnet
resource "aws_route_table_association" "my_route_table_association" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_route_table.id
}

# Create an EC2 instance in the new subnet
resource "aws_instance" "my_ec2" {
  ami           = "ami-02db68a01488594c5"  
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.my_subnet.id

  tags = {
    Name = "MyEC2Instance"
  }
}
