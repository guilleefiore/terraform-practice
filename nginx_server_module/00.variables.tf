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
	default = "nginx-server-dev"
}

variable "environment" {
	description = "The environment tag for the EC2 instance"
	default = "dev"
}

variable "team" {
	description = "The team tag for the EC2 instance"
	default = "DevOps"
}