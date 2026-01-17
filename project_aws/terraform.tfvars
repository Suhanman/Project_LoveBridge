private_subnet_ids = [
    module.vpc.private_subnets[2],
    module.vpc.private_subnets[3]
    ]
public_subnet_ids  = ["subnet-018d543f22b996546", "subnet-0e5deedcc47ecd058"]
key_name           = "ABC2.pem"
db_username = "root"
db_password = "rhdwn9953!"
vpc_id      = "vpc-0b27fa23072dab233"
eks_api_nacl_id = "acl-08755947d184ef4d8"

cluster_name = "lovebridge-eks"
region       = "ap-northeast-2"



gitlab_username  = "mks0301140"
gitlab_token     = "glpat-Cxn78VAtqFzwtgvDQ3Fo"  # GitLab Personal Access Token

argocd_username    = "admin"
argocd_password    = "admin1234"