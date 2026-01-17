output "oidc_url" {
  value = aws_iam_openid_connect_provider.oidc.url
}

output "bastion_instance_profile_name" {
  description = "Name of the instance profile for Bastion EC2"
  value       = aws_iam_instance_profile.bastion_profile.name
}

# ALB Controller용 IAM Role ARN
output "alb_irsa_role_arn" {
  description = "IAM Role ARN for ALB Controller (IRSA)"
  value       = aws_iam_role.alb_irsa_role.arn
}

# ALB Controller용 Kubernetes ServiceAccount 이름
output "alb_service_account_name" {
  description = "Service Account name for ALB Controller"
  value       = kubernetes_service_account.alb_sa.metadata[0].name
}

# ALB Controller용 ServiceAccount 네임스페이스
output "alb_service_account_namespace" {
  description = "Service Account namespace for ALB Controller"
  value       = kubernetes_service_account.alb_sa.metadata[0].namespace
}

output "irsa_created" {
  value = true
}

