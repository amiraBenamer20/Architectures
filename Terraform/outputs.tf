output "aws_instance_dns_public" {
  value = "http://${aws_instance.front_end_server.public_dns}"
  description = "dns of ec2 instane"
}