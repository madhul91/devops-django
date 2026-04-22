output "public_ip" {
  description = "Public IP address of EC2"
  value       = aws_instance.devops_ec2.public_ip
}


