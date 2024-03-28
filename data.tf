data "aws_subnets" "subnets" {
  filter {
    name = "vpc_id"
    values = [var.default_vpc_id]
  }
}
