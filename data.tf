data "aws_subnet" "subnets" {
  filter {
    name = "vpc_id"
    values = [var.default_vpc_id]
  }
}