variable "vpc_id" {
  type        = string
  description = "ID of the VPC where security group will be created"
}

variable "db_username" {
    type = string
  
}

variable "db_password" {
    type = string
  
}


# 루트 variables.tf
variable "public_subnet_ids" {
  type = list(string)
}


variable "key_name" {
  type = string
}

variable "enable_dns_support" {
  type    = bool
  default = true
}

variable "enable_dns_hostnames" {
  type    = bool
  default = true
}


variable "cluster_name" {
  description = "EKS 클러스터 이름"
  type        = string
}

variable "region" {
  description = "AWS 리전"
  type        = string
}


variable "eks_api_nacl_id" {
  description = "Optional EKS NACL ID"
  type        = string
  default     = ""
}



variable "gitlab_username" {
  type        = string
  description = "GitLab 사용자 이름 (예: your@email.com)"
}

variable "gitlab_token" {
  type        = string
  description = "GitLab Personal Access Token (PAT)"
  sensitive   = true
}


variable "argocd_username" {
  type        = string
  description = "Argo CD 로그인 사용자 이름 (기본: admin)"
  default     = "admin"
}

variable "argocd_password" {
  type        = string
  description = "Argo CD 로그인 비밀번호 (평문)"
  
}




