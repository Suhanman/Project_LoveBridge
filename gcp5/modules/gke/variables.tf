variable "region" {
  description = "GCP region (예: us-central1)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_name" {
  description = "서브넷 이름"
  type        = string
}

variable "node_count" {
  description = "GKE 노드 수"
  type        = number
}

variable "machine_type" {
  description = "GCE 머신 타입 (예: e2-standard-2)"
  type        = string
}


variable "project" {}