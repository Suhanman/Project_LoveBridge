variable "project" {
  default = "direct-tribute-463400-f2"
}

variable "region" {
  default = "us-central1"
}

variable "db_password" {
  description = "Database admin user password"
  type        = string
  sensitive   = true
}
variable "bucket_name"{
  type  = string
}


variable "zone" {}
variable "vpc_name" {}
variable "subnet_name" {}
variable "subnet_cidr" {}

variable "vm_name" {}

variable "image" {}

variable "docker_username" {}
variable "docker_password" {}
variable "docker_image" {}



variable "node_count" {
  default = 2
}

variable "machine_type" {
  default = "e2-standard-2"
}

variable "vpc_network_id" {
  description = "VPC 네트워크 ID"
  type        = string
}

variable "gitlab_username" {
  description = "Your GitLab username"
  type        = string
}

variable "gitlab_token" {
  description = "Your GitLab personal access token"
  type        = string
  sensitive   = true
}

