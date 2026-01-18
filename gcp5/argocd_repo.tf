# ✅ GitLab 저장소 등록 (Argo CD UI에 보이도록 Secret 생성)
resource "kubectl_manifest" "gitlab_repo" {
  yaml_body = <<YAML
apiVersion: v1
kind: Secret
metadata:
  name: gitlab-repo-secret
  namespace: argocd
  labels:
    argocd.argoproj.io/secret-type: repository
stringData:
  type: git
  url: https://gitlab.com/sooj-group/dating-app.git
  username: ${var.gitlab_username}
  password: ${var.gitlab_token}
YAML

  depends_on = [
    helm_release.argocd,module.gke,null_resource.get_gke_credentials
  ]
  
}

# ✅ Argo CD Application 생성 (GitOps 대상)
resource "kubectl_manifest" "argocd_app" {
  yaml_body = <<YAML
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: dating-app
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://gitlab.com/sooj-group/dating-app.git
    targetRevision: main
    path: k8s
  destination:
    server: https://kubernetes.default.svc
    namespace: default
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
YAML

  depends_on = [
    kubectl_manifest.gitlab_repo
  ]
}

# ✅ Docker Hub 인증용 Secret
resource "kubectl_manifest" "dockerhub_secret" {
  yaml_body = <<YAML
apiVersion: v1
kind: Secret
metadata:
  name: dockerhub-secret
  namespace: default
type: kubernetes.io/dockerconfigjson
data:
  .dockerconfigjson: "${base64encode(jsonencode({
    auths = {
      "https://index.docker.io/v1/" = {
        username = var.docker_username
        password = var.docker_password
        auth     = base64encode("${var.docker_username}:${var.docker_password}")
      }
    }
  }))}"
YAML
}


