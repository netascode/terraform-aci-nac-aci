module "aci_apic_connectivity_preference" {
  source  = "netascode/apic-connectivity-preference/aci"
  version = ">= 0.8.0"

  interface_preference = "ooband"
}
