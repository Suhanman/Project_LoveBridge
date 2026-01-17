

resource "kubernetes_config_map" "aws_auth" {
  depends_on = [null_resource.wait_for_eks]
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode([
      {
        rolearn  = "arn:aws:iam::680993828418:role/bastion-instance-role"
        username = "bastion"
        groups   = ["system:masters"]
      },
      {
        rolearn  = module.eks0.node_iam_role_arn
        username = "system:node:{{EC2PrivateDNSName}}"
        groups   = [
          "system:bootstrappers",
          "system:nodes"
        ]
      }
    ])
    # 일시적 추가한 내용
    #mapUsers = yamlencode([
  #{
    #userarn  = "arn:aws:iam::680993828418:user/admin"
    #username = "admin"
   # groups   = ["system:masters"]
  #}
#])
#
  }
  lifecycle {
    ignore_changes = [metadata]           # name은 변경하지 않음
  }
   
  
}

