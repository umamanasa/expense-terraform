module "vpc" {
  source   = "git::https://github.com/umamanasa/expense-module-vpc.git"

  for_each = var.vpc
  cidr                        = each.value["cidr"]
  subnets                     = each.value["subnets"]
  default_vpc_id              = var.default_vpc_id
  default_vpc_cidr            = var.default_vpc_cidr
  default_vpc_route_table_id  = var.default_vpc_route_table_id
  tags                        = var.tags
  env                         = var.env
}

module "alb" {
  source   = "git::https://github.com/umamanasa/expense-module-alb.git"

  tags                        = var.tags
  env                         = var.env

  for_each                    = var.alb
  internal                    = each.value["internal"]
  lb_type                     = each.value["lb_type"]
  sg_ingress_cidr             = each.value["sg_ingress_cidr"]
  vpc_id                      = each.value["internal"] ? local.vpc_id : var.default_vpc_id
  subnets                     = each.value["internal"] ? local.app_subnets : data.aws_subnets.subnets.ids
  sg_port                     = each.value["sg_port"]

}

#module "rds" {
#  source   = "git::https://github.com/umamanasa/expense-module-rds.git"
#  tags     = var.tags
#  env      = var.env
#
#  for_each                = var.rds
#  subnet_ids              = local.db_subnets
#  vpc_id                  = local.vpc_id
#  sg_ingress_cidr         = local.app_subnets_cidr
#  rds_type                = each.value["rds_type"]
#  db_port                 = each.value["db_port"]
#  engine_family           = each.value["engine_family"]
#  engine                  = each.value["engine"]
#  engine_version          = each.value["engine_version"]
#  backup_retention_period = each.value["backup_retention_period"]
#  preferred_backup_window = each.value["preferred_backup_window"]
#  skip_final_snapshot     = each.value["skip_final_snapshot"]
#  instance_count          = each.value["instance_count"]
#  instance_class          = each.value["instance_class"]
#}

module "app" {
  source = "git::https://github.com/umamanasa/expense-module-app.git"

  tags                = var.tags
  env                 = var.env
  zone_id             = var.zone_id
  ssh_ingress_cidr    = var.ssh_ingress_cidr
  default_vpc_id              = var.default_vpc_id

  for_each            = var.apps
  component           = each.key
  port                = each.value["port"]
  instance_type       = each.value["instance_type"]
  desired_capacity    = each.value["desired_capacity"]
  max_size            = each.value["max_size"]
  min_size            = each.value["min_size"]
  lb_priority         = each.value["lb_priority"]

  sg_ingress_cidr     = local.app_subnets_cidr
  vpc_id              = local.vpc_id
  subnet_ids          = local.app_subnets

  private_alb_name    = lookup(lookup(lookup(module.alb, "private", null), "alb", null ),"dns_name", null )
  public_alb_name     = lookup(lookup(lookup(module.alb, "public", null), "alb", null ),"dns_name", null )
  private_listener    = lookup(lookup(lookup(module.alb, "private", null), "listener", null ),"arn", null )
  public_listener     = lookup(lookup(lookup(module.alb, "public", null), "listener", null ),"arn", null )
}
