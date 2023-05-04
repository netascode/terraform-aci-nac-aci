module "banner" {
  source  = "netascode/nac-aci/aci"
  version = ">= 0.7.0"

  model = {
    apic = {
      fabric_policies = {
        banners = {
          apic_cli_banner = "My APIC Banner"
        }
      }
    }
  }

  manage_fabric_policies = true
}
