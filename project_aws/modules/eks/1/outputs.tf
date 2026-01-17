output "cluster_name" {
  value = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "cluster_certificate_authority_data" {
  value = aws_eks_cluster.main.certificate_authority[0].data
}

output "cluster_security_group_id" {
  value = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}

output "oidc_url" {
  value = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

output "cluster_token" {
  value     = data.aws_eks_cluster_auth.this.token
  sensitive = true
}

output "node_iam_role_arn" {
  value = aws_iam_role.eks_node_role.arn
}


