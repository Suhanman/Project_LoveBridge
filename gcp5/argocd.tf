provider "helm" {
  alias = "gke"

  kubernetes = {
    config_path              = "~/.kube/config"
    config_context           = "gke_direct-tribute-463400-f2_us-central1_lovebridge-dr-cluster"
    insecure_skip_tls_verify = true
  }
}




resource "helm_release" "argocd" {
  depends_on = [module.gke,null_resource.get_gke_credentials]
  provider   = helm.gke
  name       = "argocd"
  namespace  = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.51.6"
  create_namespace = true
  timeout          = 600

  values = [
    yamlencode({
      server = {
        insecure = true
        service = {
          type = "LoadBalancer"
        }
      }
      redis = {
        enabled  = true
        password = ""
      }
      redis-ha = {
        enabled = false
      }
      configs = {
        secret = {
          argocdServerAdminPassword = "$2a$12$I4Bs8bMJxEZO1FlSPFfrRe1Suru/2fkLcQms5avKJ.3QwXwbylgr6"
        }
        cm = {
          "application.instanceLabelKey" = "argocd.argoproj.io/instance"
          "admin.enabled"                = "true"
          "exec.enabled"                 = "false"
          "timeout.reconciliation"       = "180s"
          "timeout.hard.reconciliation"  = "0s"
          "repositories"                 = []
        }
      }
      
    })
  ]
}
resource "helm_release" "node_exporter" {
  provider   = helm.gke

  name       = "node-exporter"
  namespace  = "monitoring"
  chart      = "prometheus-node-exporter"
  repository = "https://prometheus-community.github.io/helm-charts"
  version    = "4.26.0"

  create_namespace = true

  set = [
    {
      name  = "rbac.create"
      value = "true"
    },
    {
      name  = "serviceAccount.create"
      value = "true"
    },
    {
      name  = "service.type"
      value = "ClusterIP"
    }
  ]
}
