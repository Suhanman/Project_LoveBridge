resource "kubernetes_ingress_v1" "lovebridge_ingress" {
  metadata {
    name      = "lovebridge-ingress"
    namespace = "default"

    annotations = {
      "alb.ingress.kubernetes.io/scheme"              = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"         = "ip"
      "alb.ingress.kubernetes.io/listen-ports"        = "[{\"HTTP\": 80}, {\"HTTPS\": 443}]"
      "alb.ingress.kubernetes.io/certificate-arn"     = "arn:aws:acm:ap-northeast-2:680993828418:certificate/9f19d5d4-1ed0-47b7-b3d6-b1ac1f880d39"
      "alb.ingress.kubernetes.io/ssl-policy"          = "ELBSecurityPolicy-2016-08"
      "external-dns.alpha.kubernetes.io/hostname"     = "lovebridge.click"
    }
  }

  spec {
    ingress_class_name = "alb"

    rule {
      host = "lovebridge.click"

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "lovebridge-service"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}
