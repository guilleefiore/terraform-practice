# output
output "server_public_ip" {
	description = "Public IP address of the nginx server"
	value = aws_instance.nginx-server.public_ip
}

output "server_public_dns" {
	description = "Public DNS name of the nginx server"
	value = aws_instance.nginx-server.public_dns
}
