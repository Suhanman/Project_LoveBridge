apiVersion: argoproj.io/v1alpha1
kind: Repository
metadata:
  name: gitlab-repo
  namespace: argocd
spec:
  type: git
  url: https://gitlab.com/sooj-group/dating-app.git
  username: "${gitlab_username}"
  password: "${gitlab_token}"
