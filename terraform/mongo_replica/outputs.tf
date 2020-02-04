# Add IPs
output "db_instance_ip1" {
  value = aws_instance.db_instance.private_ip
}

output "db_instance_ip2" {
  value = aws_instance.db_instance.private_ip
}

output "db_instance_ip3" {
  value = aws_instance.db_instance.private_ip
}
