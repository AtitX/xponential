aws_region                             = "ap-southeast-1"
profile                                = "default"
base_name                              = "dev"

vpc_cidr                               = "10.0.0.0/16"
vpc_enable_nat_gateway                 = true
vpc_single_nat_gateway                 = true

vpc_create_database_subnet_group       = true
vpc_create_database_subnet_route_table = true

instance_type                          = "t3.small"
environment                            = "Dev"
owner                                  = "Atit"