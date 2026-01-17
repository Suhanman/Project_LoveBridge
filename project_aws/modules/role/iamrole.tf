resource "aws_iam_openid_connect_provider" "oidc" {
  url             = var.oidc_url
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da0afd10df6"]

  depends_on = [var.cluster_dependency]  # ✅ 클러스터 생성 후 실행 보장
}


resource "aws_iam_role" "ecr_role" {
  name = "eks-ecr-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = aws_iam_openid_connect_provider.oidc.arn
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${replace(var.oidc_url, "https://", "")}:sub" = "system:serviceaccount:default:ecr-sa"
          }
        }
      }
    ]
  })
}



resource "aws_iam_role_policy_attachment" "ecr_policy_attach" {
  role       = aws_iam_role.ecr_role.name
  policy_arn = aws_iam_policy.ecr_read_only.arn
}


