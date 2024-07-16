module "aci_vpc_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-vpc-policy"
  version = ">= 0.8.0"

  name                = "VPC1"
  peer_dead_interval  = 300
  delay_restore_timer = 200
}
