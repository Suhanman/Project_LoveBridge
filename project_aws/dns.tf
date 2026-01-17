# 1. ServiceAccount
resource "kubernetes_service_account" "external_dns" {
  metadata {
    name      = "external-dns"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/name" = "external-dns"
    }
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.external_dns.arn
    }
  }
}

# 2. ClusterRole
resource "kubernetes_cluster_role" "external_dns" {
  metadata {
    name = "external-dns"
    labels = {
      "app.kubernetes.io/name" = "external-dns"
    }
  }

  rule {
    api_groups = [""]
    resources  = ["services", "endpoints", "pods", "nodes"]
    verbs      = ["get", "watch", "list"]
  }

  rule {
    api_groups = ["extensions", "networking.k8s.io"]
    resources  = ["ingresses"]
    verbs      = ["get", "watch", "list"]
  }
}

# 3. ClusterRoleBinding
resource "kubernetes_cluster_role_binding" "external_dns_viewer" {
  metadata {
    name = "external-dns-viewer"
    labels = {
      "app.kubernetes.io/name" = "external-dns"
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.external_dns.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.external_dns.metadata[0].name
    namespace = "kube-system"
  }
}

# 4. Deployment
resource "kubernetes_deployment" "external_dns" {
  metadata {
    name      = "external-dns"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/name" = "external-dns"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/name" = "external-dns"
      }
    }

    strategy {
      type = "Recreate"
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/name" = "external-dns"
        }
        annotations = {
          "eks.amazonaws.com/role-arn" = aws_iam_role.external_dns.arn
        }
      }

      spec {
        service_account_name = kubernetes_service_account.external_dns.metadata[0].name

        security_context {
          fs_group = 65534
        }

        container {
          name  = "external-dns"
          image = "bitnami/external-dns:0.13.1"

          args = [
            "--source=service",
            "--source=ingress",
            "--domain-filter=lovebridge.click",
            "--provider=aws",
            "--policy=sync",
            "--aws-zone-type=public",
            "--registry=txt",
            "--txt-owner-id=Z057064919GL8WQWUETYS",
          ]
        }
      }
    }
  }
}
