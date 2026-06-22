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