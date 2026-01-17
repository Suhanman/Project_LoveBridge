output "bastion_instance_id" {
  description = "ID of the Bastion EC2 instance"
  value       = aws_instance.bastion.id
}



output "bastion_sg_id" {
  description = "sg id"
  value = aws_security_group.bastion_sg.id
}

output "public_ip" {
  value = aws_instance.bastion.public_ip
}
