output "db_instance_ip1" {
  value = aws_instance.mongo_instance1.private_ip
}

output "db_instance_ip2" {
  value = aws_instance.mongo_instance2.private_ip
}

output "db_instance_ip3" {
  value = aws_instance.mongo_instance3.private_ip
}
