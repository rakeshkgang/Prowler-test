provider "aws" {
  region = "eu-north-1"  
}

resource "aws_instance" "my_ec2" {
  ami           = "ami-02db68a01488594c5"  
  instance_type = "t2.micro"               
  tags = {
    Name = "MyEC2Instance"
  }
}
