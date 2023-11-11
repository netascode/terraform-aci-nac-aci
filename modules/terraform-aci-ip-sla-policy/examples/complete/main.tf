module "aci_ip_sla_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-ip-sla-policy"
  version = ">= 0.8.0"

  name        = "ABC"
  description = "My Description"
  tenant      = "TEN1"
  multiplier  = 10
  frequency   = 120
  sla_type    = "tcp"
  port        = 65001
}
