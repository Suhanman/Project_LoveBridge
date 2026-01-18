variable "project" {
  description = "GCP 프로젝트 ID"
  type        = string
}

variable "region" {
  description = "GCP 리전"
  type        = string
}

variable "vpc_name" {
  description = "VPC 이름"
  type        = string
}

variable "subnet_name" {
  description = "서브넷 이름"
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR 블록 (예: 10.0.0.0/24)"
  type        = string
}

variable "subnet_cidr_db" {
  description = "CIDR 블록 (예: 10.0.0.0/24)"
  type        = string
}

variable "subnet_cidr_kuber" {
  description = "CIDR 블록 (예: 10.0.0.0/24)"
  type        = string
}
