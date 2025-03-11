module "aci_atomic_counter" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-atomic-counter"
  version = ">= 0.9.4"

  admin_state = true
  mode        = "trail"
}
