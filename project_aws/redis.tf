data "aws_eks_cluster" "eks0" {
  name = module.eks0.cluster_name
  depends_on = [module.eks0]
}

data "aws_eks_cluster_auth" "eks0" {
  name = module.eks0.cluster_name
}

resource "helm_release" "redis" {
  provider   = helm.eks  # 이미 선언된 provider 사용
  name       = "redis"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "redis"
  namespace  = "default"

  set = [
    {
      name  = "architecture"
      value = "standalone"
    },
    {
      name  = "auth.enabled"
      value = "false"
    },
    {
      name  = "master.persistence.enabled"
      value = "false"
    }
  ]

  depends_on = [module.eks0]
}
