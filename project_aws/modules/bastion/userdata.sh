#!/bin/bash
exec > /var/log/userdata.log 2>&1
set -x

yum update -y
yum install -y curl unzip

# kubectl 최신 버전 설치
KUBECTL_VERSION=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"

# 설치 확인
if [ ! -f kubectl ]; then
  echo "❌ kubectl 다운로드 실패"
  exit 1
fi

chmod +x kubectl
mv kubectl /usr/local/bin/

# 확인 (절대 경로로 지정)
echo "✅ kubectl 설치 완료"
echo "버전 확인:"
/usr/local/bin/kubectl version --client --short

# Update kubeconfig for EKS
sudo -u ec2-user aws eks update-kubeconfig --region ap-northeast-2 --name lovebridge-eks --profile admin



