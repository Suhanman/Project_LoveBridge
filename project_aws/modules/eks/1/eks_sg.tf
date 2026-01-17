resource "aws_security_group" "eks_cluster_sg" {
  name        = "eks-cluster-sg"
  description = "Security group for EKS cluster endpoint"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow Bastion SG to access EKS API"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [var.bastion_sg_id] # Bastion 보안그룹 ID를 변수로 전달
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-cluster-sg"
  }
}
