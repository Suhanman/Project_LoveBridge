project      = "direct-tribute-463400-f2"
region       = "us-central1"
zone         = "us-central1-a"

vpc_name     = "dr-vpc"
subnet_name  = "dr-subnet"
subnet_cidr  = "10.0.0.0/24"

vm_name      = "dr-spring-vm"
machine_type = "e2-standard-2"

image        = "debian-cloud/debian-11"

docker_username = "choiyeram"
docker_password = "rhdwn9953!"
docker_image    = "choiyeram/boot:latest"
db_password = "1234"
vpc_network_id = "projects/direct-tribute-463400-f2/global/networks/dr-vpc"

gitlab_username = "mks0301140"
gitlab_token    = "glpat-Cxn78VAtqFzwtgvDQ3Fo"  # GitLab에서 생성한 Personal Access Token
bucket_name     = "lovebridge-db-backups"
