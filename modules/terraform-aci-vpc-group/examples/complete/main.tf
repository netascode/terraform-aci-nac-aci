module "aci_vpc_group" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-vpc-group"
  version = ">= 0.8.0"

  mode = "explicit"
  groups = [{
    name     = "VPC101"
    id       = 101
    policy   = "VPC1"
    switch_1 = 101
    switch_2 = 102
  }]
}
