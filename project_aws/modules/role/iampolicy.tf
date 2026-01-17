resource "aws_iam_policy" "ecr_read_only" {
  name        = "ECRReadOnlyPolicyForEKS"
  description = "Policy for allowing EKS to pull images from ECR"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ],
        Resource = "*"
      }
    ]
  })
}

# Bastion EC2가 사용할 IAM Role
resource "aws_iam_role" "bastion_instance_role" {
  name = "bastion-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
                
      }
    ]
  })
}

# 필요한 정책 직접 부여 (EKS + S3 접근 권한)
resource "aws_iam_policy" "bastion_inline_policy" {
  name        = "bastion-inline-policy"
  description = "Access to EKS and private Helm S3 repo"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
         {
        Effect = "Allow"
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters",
          "eks:AccessKubernetesApi"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "sts:GetCallerIdentity"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        
        Resource = [
          "arn:aws:s3:::lovebridge-helm-chart-bucket",
          "arn:aws:s3:::lovebridge-helm-chart-bucket/*"
        ]
      }
    ]
  })
}

# 정책 붙이기
resource "aws_iam_role_policy_attachment" "bastion_policy_attach" {
  role       = aws_iam_role.bastion_instance_role.name
  policy_arn = aws_iam_policy.bastion_inline_policy.arn
}

# Instance Profile 생성
resource "aws_iam_instance_profile" "bastion_profile" {
  name = "bastion-profile"
  role = aws_iam_role.bastion_instance_role.name
}


