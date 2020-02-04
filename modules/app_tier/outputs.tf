output "app_security_group_id" {
  description = "this is the id from my security group from my app"
  value = aws_security_group.app_security_dm.id
}
output "app_subnet_one" {
  description = "this is the 1st subnet"
  value = aws_subnet.public[0].id
}
output "app_subnet_two" {
  description = "this is the 2nd subnet"
  value = aws_subnet.public[1].id
}
output "app_subnet_three" {
  description = "this is the 3rd subnet"
  value = aws_subnet.public[2].id
}

output "app_instance" {
  description = "these are the app instances"
  value = aws_instance.app_instance
}
