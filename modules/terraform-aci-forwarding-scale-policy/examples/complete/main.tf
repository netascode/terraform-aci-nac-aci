module "aci_forwarding_scale_policy" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-forwarding-scale-policy"
  version = ">= 0.8.0"

  name    = "HIGH-DUAL-STACK"
  profile = "high-dual-stack"
}
