provider "helm" {
  alias = "eks"

  kubernetes = {
    host                   = module.eks0.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks0.cluster_certificate_authority_data)
    token                  = module.eks0.cluster_token
    config_path = "~/.kube/config"
  }
}

# ✅ ALB Controller 설치
resource "helm_release" "alb_controller" {
  provider   = helm.eks
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = "1.6.2"

  values = [
    yamlencode({
      clusterName = var.cluster_name
      region      = var.region
      vpcId       = local.vpc_id

      serviceAccount = {
        create = false
        name   = "aws-load-balancer-controller"
      }

      image = {
        repository = "602401143452.dkr.ecr.ap-northeast-2.amazonaws.com/amazon/aws-load-balancer-controller"
      }

      ingressClass = "alb"
      enableServiceMutatorWebhook = true
    })
  ]

  depends_on = [module.eks0, module.iam_role]
}

# ✅ Argo CD 설치 + Ingress (ALB + external-dns + 인증서) 자동 구성
resource "helm_release" "argocd" {
  provider   = helm.eks
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.51.6"
  namespace  = "argocd"
  create_namespace = true
  

  values = [
    yamlencode({
      # ──────────────── 1) 관리자 비밀번호 설정 ────────────────
      configs = {
        secret = {
          # admin1234 를 bcrypt 로 해시한 예시
          argocdServerAdminPassword = "$2a$12$2IMNkoxtsib33xo/thSvgOdVzTtEbiMha3dHPDrc/C1DqcOlrVRQu"
        }
      }

      server = {
        extraArgs = ["--insecure"]

        service = {
          type = "NodePort"
          ports = [
            { name = "http",  port = 80,  targetPort = 8080 },
            { name = "https", port = 443, targetPort = 8083 }
          ]
        }

        ingress = {
          enabled          = true
          ingressClassName = "alb"
          servicePort      = "http"
          hosts            = ["argocd.lovebridge.click"]
          annotations = {
            "alb.ingress.kubernetes.io/scheme"               = "internet-facing"
            "alb.ingress.kubernetes.io/target-type"          = "ip"
            "alb.ingress.kubernetes.io/listen-ports"         = "[{\"HTTP\":80},{\"HTTPS\":443}]"
            "alb.ingress.kubernetes.io/certificate-arn"      = "arn:aws:acm:ap-northeast-2:680993828418:certificate/9f19d5d4-1ed0-47b7-b3d6-b1ac1f880d39"
            "alb.ingress.kubernetes.io/ssl-policy"           = "ELBSecurityPolicy-2016-08"
            "external-dns.alpha.kubernetes.io/hostname"      = "argocd.lovebridge.click"
            "alb.ingress.kubernetes.io/healthcheck-path"     = "/fail"
            "alb.ingress.kubernetes.io/healthcheck-port"     = "80"
            "alb.ingress.kubernetes.io/healthcheck-protocol" = "HTTP"
            "alb.ingress.kubernetes.io/backend-protocol"     = "HTTP"
            "alb.ingress.kubernetes.io/backend-port"         = "http"
          }
          paths    = ["/"]
          pathType = "Prefix"
        }
      }
    })
  ]
}
