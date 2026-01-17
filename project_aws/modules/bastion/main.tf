# Bastion 인스턴스용 보안 그룹
resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Allow SSH from my IP"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # 실제 배포 시엔 본인 IP로 제한하는 것을 권장합니다
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



# 최신 Amazon Linux 2023 AMI ID 조회
data "aws_ssm_parameter" "al2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-x86_64"
}

# Bastion EC2 인스턴스 생성
resource "aws_instance" "bastion" {
  ami                         = data.aws_ssm_parameter.al2023_ami.value
  instance_type               = "t3.micro"
  subnet_id                   = var.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true
  key_name                    = "ABC2"  # 보유한 키페어 이름과 일치해야 함
  iam_instance_profile        = var.bastion_instance_profile_name

  user_data = file("${path.module}/userdata.sh")

  tags = {
    Name = "bastion-host"
  }
}