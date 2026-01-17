variable "vpc_id" {
  type        = string
  description = "VPC ID for the NAT instance"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type for NAT"
}

variable "nat_security_group_id" {
  type        = string
  description = "NAT 인스턴스에 사용할 보안 그룹 ID"
}
variable "private_route_table_ids" {
  type = list(string)
}





