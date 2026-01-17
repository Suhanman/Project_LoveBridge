output "nat_sg_id" {
  value = aws_security_group.nat_sg.id
}
output "bastion_sg_id" {
  description = "Bastion 보안 그룹 ID"
  value       = aws_security_group.bastion.id
}