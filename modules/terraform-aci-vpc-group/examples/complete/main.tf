module "aci_vpc_group" {
  source  = "netascode/vpc-group/aci"
  version = ">= 0.2.0"

  mode = "explicit"
  groups = [{
    name     = "VPC101"
    id       = 101
    policy   = "VPC1"
    switch_1 = 101
    switch_2 = 102
  }]
}
