output "instance_ip" {
  value = aws_instance.anish_instance.public_ip
  description = "Public IP of my instance"
}

output "region" {
  value = aws_instance.anish_instance.availability_zone
  description = "The region where the instance is deployed"
}
output "name" {
  value = aws_instance.anish_instance.vpc_security_group_ids
  description = "The security group attached to my instance"
}