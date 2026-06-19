# provider configuration for AWS
provider "aws" {
  region = "us-east-1"
}

# resource to create an EC2 
resource "aws_instance" "nginx-server" {
  ami = "ami-0440d3b780d96b29d"
  instance_type = "t3.micro"
}