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