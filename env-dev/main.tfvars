default_vpc_id              = "vpc-027d9d74cfa8ed833"
default_vpc_cidr            = "172.31.0.0/16"
default_vpc_route_table_id  = "rtb-0c2ca2a512e7fa3d7"
env                         = "dev"
zone_id                     = "Z0365188L7MG2LV8YN4J"
ssh_ingress_cidr            = ["172.31.22.91/32"]    #Workstation Private_ip
monitoring_ingress_cidr     = ["172.31.31.99/32"]    #prometheus private_ip

tags = {
  company_name = "XYZ Tech"
  business_unit = "Ecommerce"
  project_name  = "Expense project"
  cost_center   = "ecom_rs"
  created_by    = "terraform"
}

az = ["us-east-1a", "us-east-1b"]

vpc = {
  main = {
    cidr = "10.0.0.0/16"
    subnets = {
      public = {
        public1 = { cidr = "10.0.0.0/24", az = "us-east-1a" }
        public2 = { cidr = "10.0.1.0/24", az = "us-east-1b" }
      }
      app = {
        app1 = { cidr = "10.0.2.0/24", az = "us-east-1a" }
        app2 = { cidr = "10.0.3.0/24", az = "us-east-1b" }
      }
      db = {
        db1 = { cidr = "10.0.4.0/24", az = "us-east-1a" }
        db2 = { cidr = "10.0.5.0/24", az = "us-east-1b" }
      }
    }
  }
}

alb = {
  public = {
    internal        = false
    lb_type         = "application"
    sg_ingress_cidr = ["0.0.0.0/0"]
    sg_port         = 80
  }
  private = {
    internal        = true
    lb_type         = "application"
    sg_ingress_cidr = ["172.31.0.0/16", "10.0.0.0/16"]
    sg_port         = 80
  }
}

rds = {
  main = {
    rds_type                = "mysql"
    db_port                 = 3306
    engine_family           = "aurora-mysql5.7"
    engine                  = "aurora-mysql"
    engine_version          = "5.7.mysql_aurora.2.11.3"
    backup_retention_period = 5
    preferred_backup_window = "07:00-09:00"
    skip_final_snapshot     = true
    instance_count          = 1
    instance_class          = "db.t3.small"
  }
}

apps = {
  expense-frontend = {
    instance_type     = "t2.micro"
    port              = 80
    desired_capacity  = 1
    max_size          = 3
    min_size          = 1
    lb_priority       = 1
    lb_type           = "public"
    parameters        = []
    tags              = { Monitor_Nginx = "yes" }
  }
  expense-backend = {
    instance_type     = "t2.micro"
    port              = 8080
    desired_capacity  = 1
    max_size          = 3
    min_size          = 1
    lb_priority       = 2
    lb_type           = "private"
    parameters        = ["rds"]
    tags              = {}
  }
}
