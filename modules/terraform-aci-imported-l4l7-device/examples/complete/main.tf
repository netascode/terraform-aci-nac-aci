module "aci_imported_l4l7_device" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-imported-l4l7-device"
  version = ">= 0.8.1"

  tenant        = "ABC"
  source_tenant = "DEF"
  source_device = "DEV1"
  description   = "My imported device"
}
