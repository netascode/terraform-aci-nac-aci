module "banner" {
  source  = "netascode/aci/aci"
  version = "0.1.0"

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
