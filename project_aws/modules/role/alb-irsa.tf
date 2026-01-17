# -------------------------
# EKS 클러스터 참조
# -------------------------
data "aws_eks_cluster" "cluster" {
  name       = var.cluster_name
  depends_on = [var.cluster_dependency]  # ✅ EKS 생성 이후 보장
}

data "aws_eks_cluster_auth" "cluster" {
  name       = var.cluster_name
  depends_on = [var.cluster_dependency]
}

# -------------------------
# OIDC Provider
# -------------------------
data "aws_iam_openid_connect_provider" "oidc" {
  url        = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
  depends_on = [var.cluster_dependency]
}

# -------------------------
# ALB Controller IAM Policy 로드
# -------------------------
resource "aws_iam_policy" "alb_controller_policy" {
  name   = "AWSLoadBalancerControllerIAMPolicy"
  path   = "/"
  policy = file("${path.module}/alb_ingress_iam_policy.json")
}

# -------------------------
# IAM Role for Service Account (IRSA)
# -------------------------
data "aws_iam_policy_document" "alb_assume_role_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.oidc.arn]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = "${replace(data.aws_iam_openid_connect_provider.oidc.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
    }
  }
}

resource "aws_iam_role" "alb_irsa_role" {
  name               = "alb-irsa-role"
  assume_role_policy = data.aws_iam_policy_document.alb_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "alb_policy_attach" {
  role       = aws_iam_role.alb_irsa_role.name
  policy_arn = aws_iam_policy.alb_controller_policy.arn
}

# -------------------------
# Kubernetes ServiceAccount에 IAM Role 연결
# -------------------------
resource "kubernetes_service_account" "alb_sa" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.alb_irsa_role.arn
    }
  }
  depends_on = [aws_iam_role_policy_attachment.alb_policy_attach]
}

# -------------------------
# 변수 선언 (variables.tf 등)
# -------------------------

# EKS 클러스터 이름
# variable "cluster_name" {
#   description = "EKS 클러스터 이름"
#   type        = string
# }

# 클러스터 생성 완료 여부에 대한 의존성 변수 (더미)
#variable "cluster_dependency" {
#  description = "EKS 클러스터 생성 이후 IRSA 동작 보장을 위한 의존성"
#  type        = any
#}
