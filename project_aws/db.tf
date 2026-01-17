

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [
    module.vpc.private_subnets[2],
    module.vpc.private_subnets[3]
  ]

  tags = {
    Name = "RDS subnet group"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Allow EKS to access RDS"
  vpc_id = module.vpc.vpc_id

  ingress {
    description     = "Allow MySQL from EKS"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-sg"
  }
}


resource "aws_db_instance" "mariadb_2a" {
  identifier              = "mariadb-2a"
  snapshot_identifier     = "lovebridge-db-backup"  
  instance_class          = "db.t3.micro"
  engine                  = "mariadb"
  engine_version          = "11.4.5"
  port                    = 3306

  availability_zone       = "ap-northeast-2a"
  multi_az                = false
  publicly_accessible     = false
  deletion_protection     = false
  skip_final_snapshot     = true
  
  

  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  backup_retention_period = 7
  apply_immediately       = true
  tags = {
    Name        = "EKS-RDS-MariaDB-2a"
    Environment = "prod"
  }
}

resource "aws_db_instance" "mariadb_replica_2c" {
  identifier               = "lovebridge-db-copy"
  replicate_source_db      = aws_db_instance.mariadb_2a.arn  
  instance_class           = "db.t3.micro"
  engine                   = "mariadb"
  availability_zone        = "ap-northeast-2c"
  publicly_accessible      = false
  auto_minor_version_upgrade = true
  apply_immediately        = true
  skip_final_snapshot = true 

  db_subnet_group_name     = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids   = [aws_security_group.rds_sg.id]

  tags = {
    Name        = "RDS-ReadReplica-2c"
    Environment = "prod"
    Role        = "read-replica"
  }
}


#elasticache 설정

resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "redis-subnet-group"
  subnet_ids = [
    module.vpc.private_subnets[2],
    module.vpc.private_subnets[3]
  ]

  tags = {
    Name = "redis-subnet-group"
  }
}

# Redis용 Security Group
resource "aws_security_group" "redis_sg" {
  name   = "redis-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "redis-sg"
  }
}

# Redis Replication Group (멀티 AZ, 자동 Failover 포함)
resource "aws_elasticache_replication_group" "redis" {
  replication_group_id          = "lovebridge-redis"
  description                   = "LoveBridge Redis Cluster"  
  engine                        = "redis"
  engine_version                = "7.1"
  node_type                     = "cache.t3.micro"
  automatic_failover_enabled    = true
  multi_az_enabled              = true
  transit_encryption_enabled = true 

  num_node_groups               = 1
  replicas_per_node_group       = 1  

  preferred_cache_cluster_azs = ["ap-northeast-2a", "ap-northeast-2c"]

  subnet_group_name  = aws_elasticache_subnet_group.redis_subnet_group.name
  security_group_ids = [aws_security_group.redis_sg.id]

  tags = {
    Name = "redis-replication"
  }
}


# Primary & Reader 엔드포인트 주소
output "redis_primary_endpoint" {
  value = aws_elasticache_replication_group.redis.primary_endpoint_address
}

output "redis_reader_endpoint" {
  value = aws_elasticache_replication_group.redis.reader_endpoint_address
}
