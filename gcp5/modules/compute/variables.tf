variable "vm_name" {
  description = "VM 인스턴스 이름"
  type        = string
}

variable "machine_type" {
  description = "VM 머신 타입 (e2-micro 등)"
  type        = string
}

variable "zone" {
  description = "GCP zone (예: us-central1-a)"
  type        = string
}

variable "image" {
  description = "VM에 사용할 이미지 (예: debian-cloud/debian-11)"
  type        = string
}

variable "vpc_id" {
  description = "VPC 네트워크 ID"
  type        = string
}

variable "subnet_name" {
  description = "서브넷 이름"
  type        = string
}

variable "startup_script" {
  description = "VM 시작 시 실행할 명령어"
  type        = string
  default     = ""
}


variable "docker_username" {}
variable "docker_password" {}
variable "docker_image" {}
