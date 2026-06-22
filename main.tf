variable "ami_id" {
	description = "The AMI ID to use for the EC2 instance"
	default = "ami-0440d3b780d96b29d" # Amazon Linux 2 AMI in us-east-1
}

variable "instance_type" {
	description = "The instance type to use for the EC2 instance"
	default = "t3.micro"
}

variable "server_name" {
	description = "The name tag for the EC2 instance"
	default = "nginx-server"
}

variable "environment" {
	description = "The environment tag for the EC2 instance"
	default = "test-tf"
}

variable "team" {
	description = "The team tag for the EC2 instance"
	default = "DevOps"
}

# provider AWS
provider "aws" {
	region = "us-east-1"
}

# create an EC2 instance
resource "aws_instance" "nginx-server" {
	ami = var.ami_id
	instance_type = var.instance_type

	# use yum because the AMI is Amazon Linux 2
	user_data = <<-EOF
						#!/bin/bash
						sudo yum install -y nginx 
						sudo systemctl enable nginx
						sudo systemctl start nginx
						EOF

	key_name = aws_key_pair.nginx-server-ssh.key_name
	
	vpc_security_group_ids = [
		aws_security_group.nginx-server-sg.id
	]

	tags = {
		Name = var.server_name
		Environment = var.environment
		Owner = "guillerfiore03@gmail.com"
		Team = var.team
		Project = "Terraform Practice"
	}
}

# create a key pair for SSH 
resource "aws_key_pair" "nginx-server-ssh" {
	key_name = "${var.server_name}-ssh"
	public_key = file("${var.server_name}.key.pub")

	tags = {
		Name = "${var.server_name}-ssh"
		Environment = var.environment
		Owner = "guillefiore03@gmail.com"
		Team = var.team
		Project = "Terraform Practice"
	}
}

# create a security group 
resource "aws_security_group" "nginx-server-sg" {
	name = "${var.server_name}-sg"
	description = "Security group allowing HTTP and SSH access"

	# allow SSH
	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	# allow HTTP
	ingress {
		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	# allow outbound traffic
	egress {
		from_port = 0
		to_port = 0
		protocol = "-1" # all protocols
		cidr_blocks = ["0.0.0.0/0"]
	}

	tags = {
		Name = "${var.server_name}-sg"
		Environment = var.environment
		Owner = "guillefiore03@gmail.com"
		Team = var.team
		Project = "Terraform Practice"
	}
}

# output
output "server_public_ip" {
	description = "Public IP address of the nginx server"
	value = aws_instance.nginx-server.public_ip
}

output "server_public_dns" {
	description = "Public DNS name of the nginx server"
	value = aws_instance.nginx-server.public_dns
}
