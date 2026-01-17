resource "aws_eip" "nat_eip" {
  domain   = "vpc"  # ✅ 이렇게 바꿔줘
  instance = aws_instance.nat.id
}

resource "aws_instance" "nat" {
  ami                         = "ami-01ad0c7a4930f0e43"  # ✅ 직접 지정
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_ids[0]
  vpc_security_group_ids      = [var.nat_security_group_id]
  source_dest_check           = false
  associate_public_ip_address = false  # 수동으로 EIP 연결 예정

  tags = {
    Name = "nat-instance"
  }
}

resource "aws_eip_association" "nat_eip_assoc" {
  instance_id   = aws_instance.nat.id
  allocation_id = aws_eip.nat_eip.id
}

