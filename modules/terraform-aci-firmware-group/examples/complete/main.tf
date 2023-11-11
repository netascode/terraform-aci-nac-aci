module "aci_firmware_group" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-firmware-group"
  version = ">= 0.8.0"

  name     = "UG1"
  node_ids = [101, 103]
}
