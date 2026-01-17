terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0"
    }

    argocd = {
      source  = "oboukili/argocd"  # ✅ HashiCorp가 아님
      version = ">= 5.0.0"
    }
  }
}


provider "aws" {
  region  = "ap-northeast-2"
  profile = "default"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"

  name = "lovebridge-vpc"
  cidr = "10.0.0.0/16"
  azs  = ["ap-northeast-2a", "ap-northeast-2c"]

  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.11.0/24", "10.0.12.0/24", "10.0.21.0/24", "10.0.22.0/24"]

  manage_default_route_table = false
  create_igw                 = true
  enable_nat_gateway         = false
  enable_dns_support         = var.enable_dns_support
  enable_dns_hostnames       = var.enable_dns_hostnames

  map_public_ip_on_launch = true

  public_subnet_tags = {
    "kubernetes.io/role/elb"               = "1"
    "kubernetes.io/cluster/lovebridge-eks" = "shared"
  }

  tags = {
    Project = "lovebridge"
  }
}

module "sg" {
  source = "./modules/sg"
  vpc_id = module.vpc.vpc_id
}



module "nat" {
  source                = "./modules/nat"
  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.vpc.public_subnets
  instance_type         = "t3.micro"
  nat_security_group_id = module.sg.nat_sg_id
  private_route_table_ids = [
    module.vpc.private_route_table_ids[0],
    module.vpc.private_route_table_ids[1]
  ]
}

module "eks0" {
  source          = "./modules/eks/1"
  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnets
  private_subnets = module.vpc.private_subnets
  key_name        = var.key_name
  bastion_sg_id   = module.sg.bastion_sg_id
  
}

resource "null_resource" "wait_for_eks" {
  depends_on = [module.eks0]
}

provider "kubernetes" {
  host                   = module.eks0.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks0.cluster_certificate_authority_data)
  token                  = module.eks0.cluster_token
  config_path = "~/.kube/config"
}

module "iam_role" {
  source       = "./modules/role"
  cluster_name = module.eks0.cluster_name
  oidc_url     = module.eks0.oidc_url
  cluster_dependency  = module.eks0.cluster_name  # dummy 값만 넘김
#  depends_on   = [module.eks0]
}

module "bastion" {
  source                         = "./modules/bastion"
  public_subnets                 = module.vpc.public_subnets
  private_subnets                = module.vpc.private_subnets
  vpc_id                         = module.vpc.vpc_id
  key_name                       = "ABC2"
  bastion_instance_profile_name = module.iam_role.bastion_instance_profile_name
  depends_on                     = [module.iam_role]
}

locals {
  private_route_table_map = {
    "rtb-a" = module.vpc.private_route_table_ids[0]
    "rtb-b" = module.vpc.private_route_table_ids[1]
    "rtb-c" = module.vpc.private_route_table_ids[2]
    "rtb-d" = module.vpc.private_route_table_ids[3]
  }

  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnets
  oidc_url          = module.eks0.oidc_url
}

resource "aws_security_group_rule" "allow_https_from_bastion" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = module.eks0.cluster_security_group_id
  source_security_group_id = module.sg.bastion_sg_id
  description              = "Allow Bastion SG to access EKS API"
  depends_on               = [module.eks0]
}

resource "aws_route" "nat_route" {
  for_each               = local.private_route_table_map
  route_table_id         = each.value
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = module.nat.nat_interface_id
}

provider "argocd" {
  server_addr = "https://argocd.lovebridge.click"  # ALB Ingress 도메인
  username    = var.argocd_username
  password    = var.argocd_password
  insecure    = true  # ACM 인증서 사용하므로 false
 }

# provider "argocd" {
#   server_addr = "https://argocd.lovebridge.click"
#   auth_token  = "dummy"  # 임시로 테스트
#   insecure    = true
# }


 resource "argocd_repository" "external_dns_gitlab" {
   repo     = "https://gitlab.com/sooj-group/dating-app-k8s-aws.git"
   username = var.gitlab_username
   password = var.gitlab_token

   depends_on = [helm_release.argocd]
 }

resource "argocd_application" "external_dns" {
  metadata {
    name      = "external-dns"
    namespace = "argocd"
  }

  spec {
    project = "default"

    source {
      repo_url        = argocd_repository.external_dns_gitlab.repo
      target_revision = "main"
      path            = "k8s"  # 👈 여기에 YAML들이 있음

      directory {
        recurse = true
      }
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "kube-system"
    }

    sync_policy {
      automated {
        prune     = true
        self_heal = true
      }

      sync_options = [
        "CreateNamespace=false"
      ]
    }
  }

  depends_on = [helm_release.argocd]
}
