variable "db_instance_name" {}
variable "db_name" {}
variable "db_user" {}
variable "db_password" {
  sensitive = true
}
variable "region" {}
variable "tier" {}

variable "vpc_network_id" {
  description = "VPC self_link to be used for private IP connection"
  type        = string
}

variable "bucket_name"{
  type  = string
}


variable "project"{
  type = string
}


