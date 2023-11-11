module "aci_banner" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-banner"
  version = ">= 0.8.0"

  apic_gui_banner_url = "http://1.1.1.1"
  apic_gui_alias      = "PROD"
  apic_cli_banner     = "My CLI Banner"
  switch_cli_banner   = "My Switch Banner"
}
