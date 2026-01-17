output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnets
}

output "private_subnet_ids" {
  value = module.vpc.private_subnets
}

output "bastion_public_ip" {
  description = "Public IP address of the Bastion EC2 instance"
  value       = module.bastion.public_ip
}

output "node_iam_role_arn" {
  value = module.eks0.node_iam_role_arn
}

output "bastion_role_arn" {
  value = "arn:aws:iam::680993828418:role/bastion-instance-role"
}

output "cluster_name" {
  value = module.eks0.cluster_name
}

output "oidc_url" {
  value = module.eks0.oidc_url
}

output "cluster_endpoint" {
  value = module.eks0.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  value = module.eks0.cluster_certificate_authority_data
}

output "cluster_token" {
  value     = module.eks0.cluster_token
  sensitive = true
}
