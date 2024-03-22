components = {
  frontend = {
    name          = "frontend"
    instance_type = "t2.micro"
  }
  mysql = {
    name          = "mysql"
    instance_type = "t2.micro"
  }
  backend = {
    name          = "backend"
    instance_type = "t2.micro"
  }
}

security_groups = [ "sg-041096a23e28b0eb0" ]
zone_id         = "Z0365188L7MG2LV8YN4J"
