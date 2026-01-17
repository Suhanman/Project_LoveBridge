variable "cluster_name" {
  type = string
}

variable "oidc_url" {
  type = string
}


variable "cluster_dependency" {
  description = "클러스터 의존성 확보용 더미"
  type        = any
}

