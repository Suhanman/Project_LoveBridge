# OIDC Provider (module.eks0.oidc_url은 https://로 시작하는 전체 URL)
data "aws_iam_openid_connect_provider" "eks0" {
  url = module.eks0.oidc_url
}

# external-dns AssumeRole Policy 생성
data "aws_iam_policy_document" "external_dns_assume_role_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.eks0.arn]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks0.oidc_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:external-dns"]
    }
  }
}

# IAM Role 생성
resource "aws_iam_role" "external_dns" {
  name               = "AWSEKSRoute53Role"
  assume_role_policy = data.aws_iam_policy_document.external_dns_assume_role_policy.json
}

# external-dns가 사용할 Policy (Route53 접근 권한)
resource "aws_iam_policy" "external_dns" {
  name = "ExternalDNSPolicy-v2"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "route53:ChangeResourceRecordSets",
        "route53:ListHostedZones",
        "route53:ListResourceRecordSets"
      ],
      Resource = "*"
    }]
  })
}

# IAM Role에 Policy 부착
resource "aws_iam_role_policy_attachment" "external_dns_attach" {
  role       = aws_iam_role.external_dns.name
  policy_arn = aws_iam_policy.external_dns.arn
}

# 출력
output "external_dns_role_arn" {
  description = "external-dns에서 사용할 IAM Role ARN"
  value       = aws_iam_role.external_dns.arn
}





