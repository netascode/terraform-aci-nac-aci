module "aci_vpc_policy" {
  source  = "netascode/vpc-policy/aci"
  version = ">= 0.1.0"

  name               = "VPC1"
  peer_dead_interval = 300
}
