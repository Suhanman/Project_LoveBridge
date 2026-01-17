
variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "key_name" {
  type = string
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC for EKS and Bastion resources"
}

variable "bastion_instance_profile_name" {
  type        = string
  description = "IAM instance profile name for Bastion EC2"
}
