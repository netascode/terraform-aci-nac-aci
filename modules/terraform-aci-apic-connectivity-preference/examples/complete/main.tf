module "aci_apic_connectivity_preference" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-apic-connectivity-preference"
  version = ">= 0.8.0"

  interface_preference = "ooband"
}
