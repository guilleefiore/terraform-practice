# provider AWS
provider "aws" {
	region = "us-east-1"
}

# create an EC2 instance
resource "aws_instance" "nginx-server" {
	ami = "ami-0440d3b780d96b29d"
	instance_type = "t3.micro"

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
		Name = "nginx-server"
		Environment = "test"
		Owner = "guillerfiore03@gmail.com"
		Team = "DevOps"
		Project = "Terraform Practice"
	}
}

# create a key pair for SSH 
resource "aws_key_pair" "nginx-server-ssh" {
	key_name = "nginx-server-ssh"
	public_key = file("nginx-server.key.pub")

	tags = {
		Name = "nginx-server-ssh"
		Environment = "test"
		Owner = "guillefiore03@gmail.com"
		Team = "DevOps"
		Project = "Terraform Practice"
	}
}

# create a security group 
resource "aws_security_group" "nginx-server-sg" {
	name = "nginx-server-sg"
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
		Name = "nginx-server-sg"
		Environment = "test"
		Owner = "guillefiore03@gmail.com"
		Team = "DevOps"
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
