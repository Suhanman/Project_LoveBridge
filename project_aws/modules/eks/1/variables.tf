# modules/eks/variables.tf
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

variable "bastion_sg_id" {
  type = string
}


