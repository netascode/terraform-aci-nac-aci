module "aci_fabric_isis_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-fabric-isis-policy"
  version = ">= 0.8.0"

  redistribute_metric = 60
}
